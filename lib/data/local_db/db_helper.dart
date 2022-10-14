import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:submission3_restaurant_app/data/model/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'favourite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'favourite_db.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
               id TEXT PRIMARY KEY,
               name TEXT, 
               pictureId TEXT,
               city TEXT,
               rating REAL,
               address TEXT
             )''',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final Database db = await database;
    await db.insert(_tableName, restaurant.toMap());
  }

  Future<List<Restaurant>> getRestaurants() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Restaurant.fromMap(res)).toList();
  }

  Future<dynamic> getRestaurantById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.map((res) => Restaurant.fromMap(res)).first;
    } else {
      return ('Failed to find Restaurant');
    }
  }

  // Future<void> updateNote(Note note) async {
  //   final db = await database;
  //
  //   await db.update(
  //     _tableName,
  //     note.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [note.id],
  //   );
  // }

  Future<void> deleteRestaurant(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
