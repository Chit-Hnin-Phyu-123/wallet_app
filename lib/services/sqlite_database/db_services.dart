import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../models/transfer/transfer.dart';

class DBServices {
  final Database database;
  DBServices({required this.database});
  Future<int> addBalance(Map<String, dynamic> dataRow) async {
    await database.delete('balance');
    return await database.insert('balance', dataRow);
  }

  Future<int> getBalanceFromLocalDB() async {
    List balanceList = await database.query('balance');
    int balance = 0;
    if (balanceList.isNotEmpty) {
      balance = balanceList[0]['balance'];
    }
    return balance;
  }

  Future<int> addTransferHistory(Map<String, dynamic> dataRow) async {
    await database.delete('transfer_history');
    return await database.insert('transfer_history', dataRow);
  }

  Future<List<Transfer>> getTransferHistoryFromLocalDB() async {
    List dataList = await database.query('transfer_history');
    List<Transfer> returnList = [];
    for (var data in dataList) {
      returnList.add(
        Transfer(
          amount: data['amount'],
          timestamp: data['timestamp'],
          userId: data['user_name'],
          userName: data['user_id'],
          userEmail: data['user_email'],
        ),
      );
    }
    return returnList;
  }

  Future<int> addReceiveHistory(Map<String, dynamic> dataRow) async {
    await database.delete('receive_history');
    return await database.insert('receive_history', dataRow);
  }

  Future<List<Transfer>> getReceiveHistoryFromLocalDB() async {
    List dataList = await database.query('receive_history');
    List<Transfer> returnList = [];
    for (var data in dataList) {
      returnList.add(
        Transfer(
          amount: data['amount'],
          timestamp: data['timestamp'],
          userId: data['user_name'],
          userName: data['user_id'],
          userEmail: data['user_email'],
        ),
      );
    }
    return returnList;
  }
}
