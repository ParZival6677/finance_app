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
    await db.execute('''
    CREATE TABLE accounts(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL,
      category TEXT,
      iconPath TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE plans(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      amount REAL,
      category TEXT,
      iconPath TEXT,
      plannedAmount REAL
    )
  ''');
  }



  // ===================Savings====================== //

  Future<int> insertSavings(double amount, String category, String iconPath) async {
    Database db = await database;
    return await db.insert('savings', {'amount': amount, 'category': category, 'iconPath': iconPath});
  }


  Future<List<Map<String, dynamic>>> getSavings() async {
    Database db = await database;
    return await db.query('savings');
  }

  Future<int> updateSavings(int id, double amount, String iconPath) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE savings SET amount = amount + ? WHERE id = ?',
      [amount, id],
    );
  }

  Future<int> updateSavingsSum(String categoryName, double newAmount) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE savings SET amount = ? WHERE category = ?',
      [newAmount, categoryName],
    );
  }

  Future<int> deleteSavings(int id) async {
    Database db = await database;
    return await db.delete('savings', where: 'id = ?', whereArgs: [id]);
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

  Future<String> getCategoryIconsSavings(String category) async {
    final db = await database;
    var result = await db.query('savings', where: 'category = ?', whereArgs: [category]);
    if (result.isNotEmpty) {
      return result.first['iconPath'] as String;
    } else {
      return '';
    }
  }

  Future<double> getCategorySum(String categoryName) async {
    try {
      List<Map<String, dynamic>> savings = await getSavings();
      double sum = 0;
      for (var saving in savings) {
        if (saving['category'] == categoryName) {
          sum += saving['amount'];
        }
      }
      return sum;
    } catch (error) {
      print('Ошибка при получении суммы категории: $error');
      throw error;
    }
  }

  Future<int> updateCategoryNameSavings(String oldCategoryName, String newCategoryName) async {
    Database db = await database;
    return await db.update('savings', {'category': newCategoryName}, where: 'category = ?', whereArgs: [oldCategoryName]);
  }



  // =================Loans=================== //

  Future<int> insertLoans(double amount, String category, String iconPath) async {
    Database db = await database;
    return await db.insert('loans', {'amount': amount, 'category': category, 'iconPath': iconPath});
  }

  Future<List<Map<String, dynamic>>> getLoans() async {
    Database db = await database;
    return await db.query('loans');
  }


  Future<int> updateLoans(int id, double amount, String iconPath) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE loans SET amount = amount + ? WHERE id = ?',
      [amount, id],
    );
  }

  Future<int> updateLoansSum(String categoryName, double newAmount) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE loans SET amount = ? WHERE category = ?',
      [newAmount, categoryName],
    );
  }


  Future<int> deleteLoans(int id) async {
    Database db = await database;
    return await db.delete('loans', where: 'id = ?', whereArgs: [id]);
  }



  Future<bool> checkLoansCategoryExists(String category) async {
    final db = await database;

    var result = await db.query('savings', where: 'category = ?', whereArgs: [category]);

    return result.isNotEmpty;
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


  Future<int> updateCategoryNameLoans(String oldCategoryName, String newCategoryName) async {
    Database db = await database;
    return await db.update('loans', {'category': newCategoryName}, where: 'category = ?', whereArgs: [oldCategoryName]);
  }


  /* ===========================================
  ===================Accounts===================
  =============================================*/


  Future<int> insertAccounts(double amount, String category, String iconPath) async {
    Database db = await database;
    int accountId = await db.insert('accounts', {
      'amount': amount,
      'category': category,
      'iconPath': iconPath,
    });
    return accountId;
  }


  Future<List<Map<String, dynamic>>> getAccounts() async {
    Database db = await database;
    List<Map<String, dynamic>> accounts = await db.query('accounts');
    return accounts;
  }

  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    Database db = await database;
    List<Map<String, dynamic>> accounts = await db.query('accounts');
    return accounts;
  }


  Future<int> updateAccounts(int id, double amount, String iconPath) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE accounts SET amount = ? WHERE id = ?',
      [amount, id],
    );
  }

  Future<int> updateAccountsSum(String categoryName, double newAmount) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE accounts SET amount = ? WHERE category = ?',
      [newAmount, categoryName],
    );
  }

  Future<int> deleteAccounts(int id) async {
    Database db = await database;
    return await db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<int>> findAccountsCategoryIdsByName(String categoryName) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'accounts',
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

  Future<bool> checkAccountsCategoryExists(String category) async {
    final db = await database;

    var result = await db.query('accounts', where: 'category = ?', whereArgs: [category]);

    return result.isNotEmpty;
  }

  Future<String> getAccountsCategoryIcons(String category) async {
    final db = await database;
    var result = await db.query('accounts', where: 'category = ?', whereArgs: [category]);
    if (result.isNotEmpty) {
      return result.first['iconPath'] as String;
    } else {
      return '';
    }
  }

  Future<double> getAccountsCategorySum(String categoryName) async {
    try {
      List<Map<String, dynamic>> accounts = await getAccounts();
      double sum = 0;
      for (var account in accounts) {
        if (account['category'] == categoryName) {
          sum += account['amount'];
        }
      }
      return sum;
    } catch (error) {
      print('Ошибка при получении суммы категории: $error');
      throw error;
    }
  }

  Future<int> updateAccountsCategoryName(String oldCategoryName, String newCategoryName) async {
    Database db = await database;
    return await db.update('accounts', {'category': newCategoryName}, where: 'category = ?', whereArgs: [oldCategoryName]);
  }

  Future<Map<String, dynamic>> getAccountById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> accounts = await db.query('accounts', where: 'id = ?', whereArgs: [id], limit: 1);
    return accounts.isNotEmpty ? accounts.first : {};
  }

  // ======================Plans==================== //

  Future<int> insertPlans(double amount, String category, String iconPath, double plannedAmount) async {
    Database db = await database;
    int planId = await db.insert('plans', {
      'amount': amount,
      'category': category,
      'iconPath': iconPath,
      'plannedAmount': plannedAmount,
    });
    return planId;
  }

  Future<List<Map<String, dynamic>>> getPlans() async {
    Database db = await database;
    List<Map<String, dynamic>> plans = await db.query('plans');
    return plans;
  }

  Future<List<Map<String, dynamic>>> getAllPlansWithInfo() async {
    Database db = await database;
    List<Map<String, dynamic>> plans = await db.rawQuery('''
      SELECT p.id, p.amount, p.category, p.iconPath, p.plannedAmount, s.amount AS savingAmount, a.amount AS accountAmount
      FROM plans p
      LEFT JOIN savings s ON p.category = s.category
      LEFT JOIN accounts a ON p.category = a.category
    ''');
    return plans;
  }

  Future<int> updatePlans(int id, double amount, String iconPath, double plannedAmount) async {
    Database db = await database;
    return await db.rawUpdate(
      'UPDATE plans SET amount = ?, iconPath = ?, plannedAmount = ? WHERE id = ?',
      [amount, iconPath, plannedAmount, id],
    );
  }

  Future<int> deletePlans(int id) async {
    Database db = await database;
    return await db.delete('plans', where: 'id = ?', whereArgs: [id]);
  }


  Future<List<int>> findPlansCategoryIdsByName(String categoryName) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'plans',
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

  Future<bool> checkPlansCategoryExists(String category) async {
    final db = await database;

    var result = await db.query('plans', where: 'category = ?', whereArgs: [category]);

    return result.isNotEmpty;
  }

  Future<String> getPlansCategoryIcons(String category) async {
    final db = await database;
    var result = await db.query('plans', where: 'category = ?', whereArgs: [category]);
    if (result.isNotEmpty) {
      return result.first['iconPath'] as String;
    } else {
      return '';
    }
  }

  Future<double> getPlansCategorySum(String categoryName) async {
    try {
      List<Map<String, dynamic>> plans = await getPlans();
      double sum = 0;
      for (var plan in plans) {
        if (plan['category'] == categoryName) {
          sum += plan['amount'];
        }
      }
      return sum;
    } catch (error) {
      print('Ошибка при получении суммы категории: $error');
      throw error;
    }
  }

  Future<int> updatePlansCategoryName(String oldCategoryName, String newCategoryName) async {
    Database db = await database;
    return await db.update('plans', {'category': newCategoryName}, where: 'category = ?', whereArgs: [oldCategoryName]);
  }

  Future<Map<String, dynamic>> getPlanById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> plans = await db.query('plans', where: 'id = ?', whereArgs: [id], limit: 1);
    return plans.isNotEmpty ? plans.first : {};
  }



}
