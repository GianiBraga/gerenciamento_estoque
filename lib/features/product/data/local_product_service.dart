import 'package:gerenciamento_estoque/core/utils/db_helper.dart';
import 'package:gerenciamento_estoque/features/product/model/product_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalProductService {
  Future<Database> get _db async => await DBHelper.initDB();

  Future<void> insert(ProductModel p) async {
    final db = await _db;
    await db.insert(
      'produtos',
      p.toMap()..['isSynced'] = 0,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductModel>> getPending() async {
    final db = await _db;
    final maps = await db.query(
      'produtos',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return maps.map((m) => ProductModel.fromMap(m)).toList();
  }

  Future<void> markSynced(String id) async {
    final db = await _db;
    await db.update(
      'produtos',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
