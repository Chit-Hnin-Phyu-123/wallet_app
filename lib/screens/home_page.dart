import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/bloc/balance_bloc/balance_bloc.dart';
import 'package:wallet_app/bloc/user_bloc/user_bloc.dart';
import 'package:wallet_app/screens/history_page.dart';
import 'package:wallet_app/services/check_connection.dart';
import 'package:wallet_app/services/sqlite_database/db_services.dart';
import 'dart:developer' as developer;
import '../components/money_transfer_dialog.dart';
import '../services/sqlite_database/db_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User currentUser = FirebaseAuth.instance.currentUser as User;
  BalanceBloc balance = BalanceBloc();
  UserBloc users = UserBloc();

  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    balance.add(GetBalance(userId: currentUser.uid));
    users.add(GetUserList(userId: currentUser.uid));
    getBalanceFromLocal();
  }

  int balanceFromLocalDB = 0;
  void getBalanceFromLocal() async {
    final db = await DBConfig.instance;
    final data = await DBServices(database: db).getBalanceFromLocalDB();
    setState(() {
      balanceFromLocalDB = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget balanceScreen = Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          const Text(
            "Balance",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          BlocProvider(
            create: (_) => balance,
            child: BlocBuilder<BalanceBloc, BalanceState>(
              builder: (context, state) {
                if (state is BalanceLoading) {
                  return const Text(
                    "Loading Balance",
                    style: TextStyle(fontSize: 25),
                  );
                } else if (state is BalanceSuccess) {
                  return Text(
                    "${state.balance.balance} SGD",
                    style: const TextStyle(fontSize: 30),
                  );
                } else if (state is BalanceError) {
                  return const Text(
                    "Error on Loading Balance",
                    style: TextStyle(fontSize: 30),
                  );
                }
                return Text(
                  "$balanceFromLocalDB SGD",
                  style: const TextStyle(fontSize: 30),
                );
              },
            ),
          )
        ],
      ),
    );

    Widget userScreen = BlocProvider(
      create: (_) => users,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Container(
              color: Colors.transparent,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is UserSuccess) {
            return Column(
              children: [
                for (var user in state.userList)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  user.email,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MoneyTransferDialog(
                                      user: user,
                                      currentUserId: currentUser.uid,
                                      currentUserName:
                                          currentUser.displayName.toString(),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Transfer',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            );
          } else if (state is UserError) {
            return const Center(
              child: Text("Loading Error"),
            );
          }
          return Container();
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("${currentUser.displayName}'s Wallet"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    currentUserId: currentUser.uid,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [balanceScreen, userScreen],
          ),
        ),
      ),
    );
  }
}
