import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Model representing an analysis result record
class ResultRecord {
  final int? id;
  final String leafId;
  final String imagePath;
  final String finalGrade;
  final String diseaseDetected;
  final double confidenceScore;
  final double greenColorPct;
  final double yellowBrowningPct;
  final double physicalDamagePct;
  final String damageType;
  final String gradingReason;
  final String timestamp;

  ResultRecord({
    this.id,
    required this.leafId,
    required this.imagePath,
    required this.finalGrade,
    required this.diseaseDetected,
    required this.confidenceScore,
    required this.greenColorPct,
    required this.yellowBrowningPct,
    required this.physicalDamagePct,
    required this.damageType,
    required this.gradingReason,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'leafId': leafId,
      'imagePath': imagePath,
      'finalGrade': finalGrade,
      'diseaseDetected': diseaseDetected,
      'confidenceScore': confidenceScore,
      'greenColorPct': greenColorPct,
      'yellowBrowningPct': yellowBrowningPct,
      'physicalDamagePct': physicalDamagePct,
      'damageType': damageType,
      'gradingReason': gradingReason,
      'timestamp': timestamp,
    };
  }

  factory ResultRecord.fromMap(Map<String, dynamic> map) {
    return ResultRecord(
      id: map['id'] as int?,
      leafId: map['leafId'] as String? ?? '',
      imagePath: map['imagePath'] as String? ?? '',
      finalGrade: map['finalGrade'] as String? ?? '',
      diseaseDetected: map['diseaseDetected'] as String? ?? '',
      confidenceScore: (map['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      greenColorPct: (map['greenColorPct'] as num?)?.toDouble() ?? 0.0,
      yellowBrowningPct: (map['yellowBrowningPct'] as num?)?.toDouble() ?? 0.0,
      physicalDamagePct: (map['physicalDamagePct'] as num?)?.toDouble() ?? 0.0,
      damageType: map['damageType'] as String? ?? '',
      gradingReason: map['gradingReason'] as String? ?? '',
      timestamp: map['timestamp'] as String? ?? '',
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aloe_check.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Users table for authentication
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // 2. Inspection results table
    await db.execute('''
      CREATE TABLE analysis_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        leafId TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        finalGrade TEXT NOT NULL,
        diseaseDetected TEXT NOT NULL,
        confidenceScore REAL NOT NULL,
        greenColorPct REAL NOT NULL,
        yellowBrowningPct REAL NOT NULL,
        physicalDamagePct REAL NOT NULL,
        damageType TEXT NOT NULL,
        gradingReason TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // --- USER AUTHENTICATION METHODS ---

  Future<int> registerUser(Map<String, dynamic> userData) async {
    final db = await instance.database;
    return await db.insert('users', userData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    final db = await instance.database;
    int count = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
    return count > 0;
  }

  Future<bool> changePassword(
      String email, String oldPassword, String newPassword) async {
    final db = await instance.database;
    int count = await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ? AND password = ?',
      whereArgs: [email, oldPassword],
    );
    return count > 0;
  }

  // --- ANALYSIS RESULT METHODS ---

  Future<int> insertResult(ResultRecord record) async {
    final db = await instance.database;
    return await db.insert('analysis_results', record.toMap());
  }

  Future<List<ResultRecord>> getAllResults() async {
    final db = await instance.database;
    final result = await db.query('analysis_results', orderBy: 'id DESC');
    return result.map((json) => ResultRecord.fromMap(json)).toList();
  }

  Future<List<ResultRecord>> searchResults(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'analysis_results',
      where: 'leafId LIKE ? OR finalGrade LIKE ? OR diseaseDetected LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'id DESC',
    );
    return result.map((json) => ResultRecord.fromMap(json)).toList();
  }

  Future<int> deleteResult(int id) async {
    final db = await instance.database;
    return await db.delete(
      'analysis_results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}