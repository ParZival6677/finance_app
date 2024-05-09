import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'finance_app.db');
    print(path);

    var database = await openDatabase(path, version: 1, onCreate: initDB);
    return database;
  }

  Future<void> initDB(Database database, int version) async {
    await database.execute(
      "CREATE TABLE PhoneNumbers ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "phone TEXT"
          ")",
    );
  }

  Future<void> insertPhoneNumber(String phoneNumber) async {
    final db = await database;
    await db.insert('PhoneNumbers', {'phone': phoneNumber});
  }

  Future<List<String>> getPhoneNumbers() async {
    final db = await database;
    var res = await db.query('PhoneNumbers');
    List<String> phoneNumbers = res.isNotEmpty ? res.map((c) => c['phone'] as String).toList() : [];
    return phoneNumbers;
  }
}

class DatabaseHelper {
  static DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_app.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE savings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        category TEXT,
        iconPath TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE loans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        category TEXT,
        iconPath TEXT
      )
    ''');
  }
  Future<int> insertSavings(double amount, String category, String iconPath) async {
    Database db = await database;
    return await db.insert('savings', {'amount': amount, 'category': category, 'iconPath': iconPath});
  }

  Future<int> insertLoans(double amount, String category, String iconPath) async {
    Database db = await database;
    return await db.insert('loans', {'amount': amount, 'category': category, 'iconPath': iconPath});
  }

  Future<List<Map<String, dynamic>>> getSavings() async {
    Database db = await database;
    return await db.query('savings');
  }

  Future<List<Map<String, dynamic>>> getLoans() async {
    Database db = await database;
    return await db.query('loans');
  }

  Future<int> updateSavings(int id, double amount, String iconPath) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE savings SET amount = amount + ? WHERE id = ?',
      [amount, id],
    );
  }

  Future<int> updateLoans(int id, double amount, String iconPath) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE loans SET amount = amount + ? WHERE id = ?',
      [amount, id],
    );
  }

  Future<int> deleteSavings(int id) async {
    Database db = await database;
    return await db.delete('savings', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteLoans(int id) async {
    Database db = await database;
    return await db.delete('loans', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<int>> findCategoryIdsByName(String categoryName) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'savings',
        columns: ['id'],
        where: 'category = ?',
        whereArgs: [categoryName],
      );
      List<int> categoryIds = [];
      for (var row in result) {
        categoryIds.add(row['id'] as int);
      }
      return categoryIds;
    } catch (error) {
      print("Ошибка при поиске идентификаторов категории: $error");
      return [];
    }
  }

  Future<bool> checkCategoryExists(String category) async {
    final db = await database;

    var result = await db.query('savings', where: 'category = ?', whereArgs: [category]);

    return result.isNotEmpty;
  }

  Future<bool> checkLoansCategoryExists(String category) async {
    final db = await database;

    var result = await db.query('savings', where: 'category = ?', whereArgs: [category]);

    return result.isNotEmpty;
  }

  Future<String> getCategoryIconsSavings(String category) async {
    final db = await database;
    var result = await db.query('savings', where: 'category = ?', whereArgs: [category]);
    if (result.isNotEmpty) {
      return result.first['iconPath'] as String;
    } else {
      return '';
    }
  }

  Future<List<int>> findCategoryIdsByNameLoans(String categoryName) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'loans',
        columns: ['id'],
        where: 'category = ?',
        whereArgs: [categoryName],
      );
      List<int> categoryIds = [];
      for (var row in result) {
        categoryIds.add(row['id'] as int);
      }
      return categoryIds;
    } catch (error) {
      print("Ошибка при поиске идентификаторов категории: $error");
      return [];
    }
  }


  Future<String> getCategoryIconsLoans(String category) async {
    final db = await database;
    var result = await db.query('loans', where: 'category = ?', whereArgs: [category]);
    if (result.isNotEmpty) {
      return result.first['iconPath'] as String;
    } else {
      return '';
    }
  }



}
