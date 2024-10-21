import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart.dart';
import '../models/weather.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'weather_database.db');
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city TEXT,
        temperature REAL,
        feels_like REAL,
        condition TEXT,
        humidity REAL,
        wind_speed REAL,
        timestamp TEXT
      )
    ''');
  }

  Future<void> _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop the existing table and recreate it
      await db.execute('DROP TABLE IF EXISTS weather');
      await _createDb(db, newVersion);
    }
  }

  Future<void> insertWeather(Weather weather) async {
    final db = await database;
    await db.insert(
      'weather',
      weather.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Weather>> getLatestWeatherData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'weather',
      orderBy: 'timestamp DESC',
      groupBy: 'city',
    );

    return List.generate(maps.length, (i) {
      return Weather.fromMap(maps[i]);
    });
  }

  Future<List<Weather>> getWeatherData(String city, DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      'weather',
      where: 'city = ? AND timestamp BETWEEN ? AND ?',
      whereArgs: [
        city,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
    );

    return List.generate(maps.length, (i) {
      return Weather.fromMap(maps[i]);
    });
  }

  Future<void> insertWeatherBatch(List<Weather> weatherList) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var weather in weatherList) {
        await txn.insert(
          'weather',
          weather.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
