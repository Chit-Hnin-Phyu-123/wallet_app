class DBQuery
{
  static const String createBalanceTableQuery = "CREATE TABLE IF NOT EXISTS balance ( id INTEGER PRIMARY KEY, balance INTEGER)";
  static const String createTransferHistoryTableQuery = "CREATE TABLE IF NOT EXISTS transfer_history ( id INTEGER PRIMARY KEY, amount INTEGER, timestamp TEXT, user_name TEXT, user_id TEXT, user_email TEXT)";
  static const String createReceiveHistoryTableQuery = "CREATE TABLE IF NOT EXISTS receive_history ( id INTEGER PRIMARY KEY, amount INTEGER, timestamp TEXT, user_name TEXT, user_id TEXT, user_email TEXT)";
}
