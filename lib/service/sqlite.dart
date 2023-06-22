import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../model/ludia_item.dart';

const databaseName = 'ludia.db';
const databaseVersion = 1;
const tableItems = 'items';
const sqlCreateItems = 'CREATE TABLE $tableItems ('
    'id INTEGER PRIMARY KEY,'
    'title TEXT,'
    'imagePath TEXT)';
const sqlCreateTables = [sqlCreateItems];

class SqliteService {
  SqliteService._private();
  static final SqliteService _instance = SqliteService._private();
  factory SqliteService() {
    return _instance;
  }

  Database? _db;

  Future open() async {
    _db = await openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: (db, version) async {
        debugPrint('create tables');
        for (final sql in sqlCreateTables) {
          await db.execute(sql);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        debugPrint('upgrade database from $oldVersion to $newVersion');
      },
    );
  }

  Future close() async {
    await _db?.close();
  }

  Future<Database> getDatabase() async {
    if (_db == null) {
      await open();
    }
    return _db!;
  }

  //
  // Region
  //
  Future<List<LudiaItem>> getItems({Map<String, Object?>? query}) async {
    final db = await getDatabase();
    final records = await db.query(
      tableItems,
      distinct: query?['distinct'] as bool?,
      columns: query?['columns'] as List<String>?,
      where: query?['where'] as String?,
      whereArgs: query?['whereArgs'] as List<Object>?,
      groupBy: query?['groupBy'] as String?,
      having: query?['having'] as String?,
      orderBy: query?['orderBy'] as String?,
      limit: query?['limit'] as int?,
      offset: query?['offset'] as int?,
    );
    return records.map<LudiaItem>((e) => LudiaItem.fromDbMap(e)).toList();
  }

  Future addItem(LudiaItem item) async {
    await updateItem(item);
  }

  Future updateItem(LudiaItem item) async {
    final db = await getDatabase();
    if (item.id == null) {
      final id = await db.insert(
        tableItems,
        item.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      item.id = id;
    } else {
      await db.update(
        tableItems,
        item.toDbMap(),
        where: 'id = ?',
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future deleteItem(LudiaItem item) async {
    final db = await getDatabase();
    if (item.id != null) {
      db.delete(
        tableItems,
        where: 'id = ?',
        whereArgs: [item.id],
      );
    }
  }
}
