import 'package:mysql1/mysql1.dart';

class Database {
  static MySqlConnection? _connection;

  static Future<MySqlConnection> getConnection() async {
    if (_connection == null) {
      final settings = ConnectionSettings(
        host: 'localhost', // Replace with your DB host
        port: 3306, // Default MySQL port
        user: 'root', // Replace with your DB username
        password: 'password', // Replace with your DB password
        db: 'flutter_backend', // Replace with your DB name
      );
      _connection = await MySqlConnection.connect(settings);
    }
    return _connection!;
  }

  static Future<void> closeConnection() async {
    await _connection?.close();
    _connection = null;
  }
}
