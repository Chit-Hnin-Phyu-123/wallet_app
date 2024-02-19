import 'package:cloud_firestore/cloud_firestore.dart';
import 'token_data.dart';
import 'set_pretty_logger.dart';
import 'send_notification/noti_req_body.dart';
import 'send_notification/send_notification.dart';

class NotificationService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference deviceCollection =
      FirebaseFirestore.instance.collection('devices');

  Future<void> sendNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    final notification = SendNotification(setPrettyLogger());
    final notiBody = NotiBody(title: title, body: body);
    final reqBody = NotiReqBody(
      to: token,
      notification: notiBody,
    );
    await notification.send(TokenData.cloudMessageServerKey, reqBody);
  }
}
