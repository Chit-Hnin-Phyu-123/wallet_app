import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_app/bloc/transfer_bloc.dart/transfer_bloc.dart';
import 'package:wallet_app/components/my_toggle_button.dart';
import 'package:wallet_app/services/check_connection.dart';

import '../models/transfer/transfer.dart';
import '../services/sqlite_database/db_config.dart';
import '../services/sqlite_database/db_services.dart';

class HistoryPage extends StatefulWidget {
  final String currentUserId;
  const HistoryPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isTransfer = true;
  set string(bool value) => setState(() => isTransfer = value);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isTransfer ? "Transfer History" : 'Received History'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MyToggleButton(
                isTransfer: (val) => setState(() => isTransfer = val),
              ),
            ),
            isTransfer
                ? TransferHistoryScreen(
                    currentUserId: widget.currentUserId,
                  )
                : ReceiveHistoryScreen(
                    currentUserId: widget.currentUserId,
                  ),
          ],
        ),
      ),
    );
  }
}

class TransferHistoryScreen extends StatefulWidget {
  final String currentUserId;
  const TransferHistoryScreen({
    Key? key,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<TransferHistoryScreen> createState() => _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends State<TransferHistoryScreen> {
  TransferBloc transferBloc = TransferBloc();
  @override
  void initState() {
    super.initState();
    transferBloc.add(
      GetHistoryList(
        userId: widget.currentUserId,
        isTransfer: true,
      ),
    );
    getHistoryFromLocal();
    checkOnline();
  }

  bool isOnline = false;

  void checkOnline() async {
    isOnline = await checkConnection();
  }

  List<Transfer> historyList = [];
  void getHistoryFromLocal() async {
    final db = await DBConfig.instance;
    final data = await DBServices(database: db).getTransferHistoryFromLocalDB();
    setState(() {
      historyList = data;

      print(historyList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isOnline
          ? BlocProvider(
              create: (_) => transferBloc,
              child: BlocBuilder<TransferBloc, TransferState>(
                builder: (context, state) {
                  if (state is TransferLoading) {
                    return Container(
                      color: Colors.transparent,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is GetHistorySuccess) {
                    return ListView(
                      children: [
                        for (var history in state.historyList)
                          HistoryScreen(history: history, isTransfer: true)
                      ],
                    );
                  } else if (state is TransferError) {
                    return const Center(
                      child: Text("Loading Error"),
                    );
                  }
                  return Container();
                },
              ),
            )
          : ListView(
              children: [
                for (var history in historyList)
                  HistoryScreen(history: history, isTransfer: true)
              ],
            ),
    );
  }
}

class ReceiveHistoryScreen extends StatefulWidget {
  final String currentUserId;
  const ReceiveHistoryScreen({
    Key? key,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<ReceiveHistoryScreen> createState() => _ReceiveHistoryScreenState();
}

class _ReceiveHistoryScreenState extends State<ReceiveHistoryScreen> {
  TransferBloc transferBloc = TransferBloc();
  @override
  void initState() {
    super.initState();
    transferBloc.add(
      GetHistoryList(
        userId: widget.currentUserId,
        isTransfer: false,
      ),
    );
    getHistoryFromLocal();
    checkOnline();
  }

  bool isOnline = false;

  void checkOnline() async {
    isOnline = await checkConnection();
  }

  List<Transfer> historyList = [];
  void getHistoryFromLocal() async {
    final db = await DBConfig.instance;
    final data = await DBServices(database: db).getReceiveHistoryFromLocalDB();
    setState(() {
      historyList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isOnline
          ? BlocProvider(
              create: (_) => transferBloc,
              child: BlocBuilder<TransferBloc, TransferState>(
                builder: (context, state) {
                  if (state is TransferLoading) {
                    return Container(
                      color: Colors.transparent,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is GetHistorySuccess) {
                    return ListView(
                      children: [
                        for (var history in state.historyList)
                          HistoryScreen(history: history, isTransfer: false)
                      ],
                    );
                  } else if (state is TransferError) {
                    return const Center(
                      child: Text("Loading Error"),
                    );
                  }
                  return Container();
                },
              ),
            )
          : ListView(
              children: [
                for (var history in historyList)
                  HistoryScreen(history: history, isTransfer: false)
              ],
            ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final Transfer history;
  final bool isTransfer;
  const HistoryScreen(
      {Key? key, required this.history, required this.isTransfer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isTransfer
                    ? '-${history.amount.toString()} SGD to ${history.userName}'
                    : '+${history.amount.toString()} SGD from ${history.userName}',
                style: const TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  history.userEmail,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                history.timestamp,
                style: const TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
