import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'db_query.dart';

class DBConfig {
  static const _dbName = "wallet_local_database.db";
  static const _version = 1;
  static Database? _db;

  static Future<Database> get instance async {
    _db ??= await _config();
    return _db!;
  }

  static Future<Database> _config() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    _db = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
    return _db!;
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute(DBQuery.createBalanceTableQuery);
    await db.execute(DBQuery.createTransferHistoryTableQuery);
    await db.execute(DBQuery.createReceiveHistoryTableQuery);
  }
}