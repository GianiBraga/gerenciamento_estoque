import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> initDB() async {
    final docsDir =
        await getApplicationDocumentsDirectory(); // :contentReference[oaicite:4]{index=4}
    final path = join(docsDir.path, 'estoque.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produtos(
            id TEXT PRIMARY KEY,
            nome TEXT NOT NULL,
            descricao TEXT,
            codigo TEXT,
            quantidade INTEGER DEFAULT 0,
            imagem_url TEXT,
            usuario_id TEXT,
            created_at TEXT,
            valor REAL,
            segmento TEXT,
            validade TEXT,
            unidade TEXT,
            estoque_minimo INTEGER DEFAULT 0,
            isSynced INTEGER DEFAULT 0
          )
        ''');
      },
    );
    return _db!;
  }
}
