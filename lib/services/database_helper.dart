import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'financeiro.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE vendas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total REAL NOT NULL,
            cliente TEXT NOT NULL,
            contato TEXT,
            data TEXT NOT NULL,
            encerrada INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE parcelas_vendas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            venda_id INTEGER NOT NULL,
            valor REAL NOT NULL,
            data TEXT NOT NULL,
            FOREIGN KEY (venda_id) REFERENCES vendas(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE compras (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total REAL NOT NULL,
            fornecedor TEXT NOT NULL,
            contato TEXT,
            data TEXT NOT NULL,
            encerrada INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE parcelas_compras (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            compra_id INTEGER NOT NULL,
            valor REAL NOT NULL,
            data TEXT NOT NULL,
            FOREIGN KEY (compra_id) REFERENCES compras(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE vendas ADD COLUMN encerrada INTEGER NOT NULL DEFAULT 0',
          );
          await db.execute(
            'ALTER TABLE compras ADD COLUMN encerrada INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }

  Future<int> insertVenda(Map<String, dynamic> venda) async {
    final db = await database;
    return await db.insert('vendas', venda);
  }

  Future<int> insertCompra(Map<String, dynamic> compra) async {
    final db = await database;
    return await db.insert('compras', compra);
  }

  Future<void> insertParcela(Map<String, dynamic> parcela) async {
    final db = await database;
    await db.insert('parcelas_vendas', parcela);
  }

  Future<void> insertParcelaCompra(Map<String, dynamic> parcela) async {
    final db = await database;
    await db.insert('parcelas_compras', parcela);
  }

  Future<void> updateVenda(int vendaId, Map<String, dynamic> venda) async {
    final db = await database;
    await db.update('vendas', venda, where: 'id = ?', whereArgs: [vendaId]);
  }

  Future<void> updateCompra(int compraId, Map<String, dynamic> compra) async {
    final db = await database;
    await db.update('compras', compra, where: 'id = ?', whereArgs: [compraId]);
  }

  Future<void> deleteVenda(int vendaId) async {
    final db = await database;
    await db.delete(
      'parcelas_vendas',
      where: 'venda_id = ?',
      whereArgs: [vendaId],
    );
    await db.delete('vendas', where: 'id = ?', whereArgs: [vendaId]);
  }

  Future<void> deleteCompra(int compraId) async {
    final db = await database;
    await db.delete(
      'parcelas_compras',
      where: 'compra_id = ?',
      whereArgs: [compraId],
    );
    await db.delete('compras', where: 'id = ?', whereArgs: [compraId]);
  }

  Future<void> encerrarVenda(int vendaId) async {
    final db = await database;
    await db.update(
      'vendas',
      {'encerrada': 1},
      where: 'id = ?',
      whereArgs: [vendaId],
    );
  }

  Future<void> encerrarCompra(int compraId) async {
    final db = await database;
    await db.update(
      'compras',
      {'encerrada': 1},
      where: 'id = ?',
      whereArgs: [compraId],
    );
  }

  Future<Map<String, dynamic>?> getLastParcelaVenda(int vendaId) async {
    final db = await database;
    final result = await db.query(
      'parcelas_vendas',
      where: 'venda_id = ?',
      whereArgs: [vendaId],
      orderBy: 'data DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getLastParcelaCompra(int compraId) async {
    final db = await database;
    final result = await db.query(
      'parcelas_compras',
      where: 'compra_id = ?',
      whereArgs: [compraId],
      orderBy: 'data DESC',
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> getVendas() async {
    final db = await database;
    final vendas = await db.rawQuery('''
      SELECT v.*, SUM(p.valor) as parcela_total
      FROM vendas v
      LEFT JOIN parcelas_vendas p ON v.id = p.venda_id
      GROUP BY v.id
    ''');
    return vendas;
  }

  Future<List<Map<String, dynamic>>> getCompras() async {
    final db = await database;
    final compras = await db.rawQuery('''
      SELECT c.*, SUM(p.valor) as parcela_total
      FROM compras c
      LEFT JOIN parcelas_compras p ON c.id = p.compra_id
      GROUP BY c.id
    ''');
    return compras;
  }
}
