part of 'repositories.dart';

class _Repositories implements Repositories {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Users>> getUsers(String currentUserId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .where('id', isNotEqualTo: currentUserId)
        .get();

    List<Users> userList = [];

    for (var doc in querySnapshot.docs) {
      // Cast doc.data() to Map<String, dynamic>
      Map<String, dynamic> data = doc.data();

      // Convert each document to a Users object and add it to the list
      Users user = Users.fromJson(data);
      userList.add(user);
    }

    return userList;
  }

  @override
  Future<UserCredential> userSignIn() async {
    UserCredential user = await signInWithGoogleAndAddToFirestore();
    return user;
  }

  // Sign in with Google and add user data to Firestore
  Future<UserCredential> signInWithGoogleAndAddToFirestore() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Obtain Google Sign-In authentication tokens
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create Firebase credential with Google authentication tokens
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in with Firebase using the Google credentials
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        // Add user data to Firestore
        await addUserDataToFirestore(userCredential.user!);

        return userCredential;
      } else {
        // User cancelled Google Sign-In
        throw Exception('Google Sign-In cancelled by user');
      }
    } catch (e) {
      throw Exception('Error signing in with Google: $e');
    }
  }

  // Add user data to Firestore
  Future<void> addUserDataToFirestore(User user) async {
    // Check if the user document already exists in Firestore
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    // If the user document doesn't exist, add it to Firestore
    if (!userDoc.exists) {
      // add user to database
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'Email': user.email,
        'Name': user.displayName,
        'PhotoUrl': user.photoURL,
        'DeviceToken': fcmToken,
      });

      // add balance to user
      await _firestore
          .collection('wallets')
          .doc(user.uid)
          .set({'Balance': 10000});
    } else {
      //
    }
  }

  @override
  Future<Balance> getBalance(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> balanceList =
        await _firestore.collection('wallets').doc(userId).get();
    Map<String, dynamic> balanceMap =
        balanceList.data() as Map<String, dynamic>;
    Balance balance = Balance(balance: balanceMap['Balance']);

    await addBalanceToLocalDB(balanceMap);

    return balance;
  }

  Future<bool> addBalanceToLocalDB(Map<String, dynamic> balanceMap) async {
    final db = await DBConfig.instance;
    try {
      final dbServices = DBServices(database: db);

      await dbServices.addBalance(balanceMap);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Balance> transferMoney(
      Users receiver, String userId, String userName, int amount) async {
    Timestamp currentTime = Timestamp.fromDate(DateTime.now());

    await _firestore
        .collection('transactions')
        .doc(userId)
        .collection('out')
        .add({
      'Amount': amount,
      'Timestamp': currentTime,
      'UserId': receiver.id,
      'UserName': receiver.name,
      'UserEmail': receiver.email
    });

    await _firestore
        .collection('transactions')
        .doc(receiver.id)
        .collection('in')
        .add({
      'Amount': amount,
      'Timestamp': currentTime,
      'UserId': receiver.id,
      'UserName': receiver.name,
      'UserEmail': receiver.email
    });

    Balance receiverBalance = await getBalance(receiver.id);

    await _firestore.collection('wallets').doc(receiver.id).set({
      'Balance': receiverBalance.balance + amount,
    });

    Balance currentUserBalance = await getBalance(userId);

    await _firestore.collection('wallets').doc(userId).set({
      'Balance': currentUserBalance.balance - amount,
    });

    await NotificationService().sendNotification(
        title: 'Received',
        body: 'Received $amount SGD from $userName',
        token: receiver.token);

    return await getBalance(userId);
  }

  @override
  Future<List<Transfer>> getHistory(
      String currentUserId, bool isTransfer) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('transactions')
        .doc(currentUserId)
        .collection(isTransfer ? 'out' : 'in')
        .get();

    List<Transfer> userList = [];

    for (var doc in querySnapshot.docs) {
      // Cast doc.data() to Map<String, dynamic>

      Map<String, dynamic> data = doc.data();

      Map<String, dynamic> dataMap = {
        'Amount': data['Amount'],
        'Timestamp': data['Timestamp'].toDate().toString(),
        'UserEmail': data['UserEmail'],
        'UserId': data['UserId'],
        'UserName': data['UserName']
      };

      await addHistoryToLocalDB(dataMap, isTransfer);

      // Convert each document to a Users object and add it to the list
      Transfer user = Transfer.fromJson(dataMap);
      userList.add(user);

      print("userList >>>>>> $userList");
    }

    return userList;
  }

  Future<bool> addHistoryToLocalDB(
      Map<String, dynamic> dataMap, bool isTransfer) async {
    final db = await DBConfig.instance;
    try {
      final dbServices = DBServices(database: db);

      if (isTransfer) {
        await dbServices.addTransferHistory(dataMap);
      } else {
        await dbServices.addReceiveHistory(dataMap);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
