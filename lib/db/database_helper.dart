import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/endemik.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = 'my_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'endemik';

  static const _columnId = 'id';
  static const _columnNama = 'nama';
  static const _columnNamaLatin = 'nama_latin';
  static const _columnDeskripsi = 'deskripsi';
  static const _columnAsal = 'asal';
  static const _columnFoto = 'foto';
  static const _columnStatus = 'status';
  static const _columnIsFavorit = 'is_favorit';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId TEXT PRIMARY KEY,
        $_columnNama TEXT,
        $_columnNamaLatin TEXT,
        $_columnDeskripsi TEXT,
        $_columnAsal TEXT,
        $_columnFoto TEXT,
        $_columnStatus TEXT,
        $_columnIsFavorit TEXT
      )
    ''');

    // INSERT ALL BURUNG ENDÉMIK
    final dataList = [
      {
        _columnId: '1',
        _columnNama: 'Cendrawasih',
        _columnNamaLatin: 'Paradisaea apoda',
        _columnDeskripsi: 'Burung cantik dari Papua dengan bulu berwarna-warni.',
        _columnAsal: 'Papua',
        _columnFoto: 'assets/images/cendrawasih.png',
        _columnStatus: 'Dilindungi',
      },
      {
        _columnId: '2',
        _columnNama: 'Jalak Bali',
        _columnNamaLatin: 'Leucopsar rothschildi',
        _columnDeskripsi: 'Burung khas Bali dengan bulu putih dan jambul indah.',
        _columnAsal: 'Bali',
        _columnFoto: 'assets/images/jalak_bali.png',
        _columnStatus: 'Kritis',
      },
      {
        _columnId: '3',
        _columnNama: 'Walik Solomon',
        _columnNamaLatin: 'Chrysoenas chloris',
        _columnDeskripsi: 'Berwarna cerah, burung ini ditemukan di Kepulauan Solomon.',
        _columnAsal: 'Papua',
        _columnFoto: 'assets/images/walik_solomon.jpg',
        _columnStatus: 'Rentan',
      },
      {
        _columnId: '4',
        _columnNama: 'Rangkong Papan',
        _columnNamaLatin: 'Buceros vigil',
        _columnDeskripsi: 'Ciri khasnya paruh besar dan suara nyaring dari hutan Sumatera.',
        _columnAsal: 'Sumatera',
        _columnFoto: 'assets/images/rangkong_papan.jpg',
        _columnStatus: 'Terancam',
      },
      {
        _columnId: '5',
        _columnNama: 'Taktarau Iblis',
        _columnNamaLatin: 'Eurostopodus diabolicus',
        _columnDeskripsi: 'Burung malam unik asal Sulawesi dengan penampakan misterius.',
        _columnAsal: 'Sulawesi',
        _columnFoto: 'assets/images/taktarau_iblis.jpg',
        _columnStatus: 'Kritis',
      },
      {
        _columnId: '6',
        _columnNama: 'Delimukan Sulawesi',
        _columnNamaLatin: 'Gallicolumba tristigmata',
        _columnDeskripsi: 'Spesies merpati tanah dari Sulawesi yang pemalu.',
        _columnAsal: 'Sulawesi',
        _columnFoto: 'assets/images/Delimukan_Sulawesi.jpg',
        _columnStatus: 'Dilindungi',
      },
      {
        _columnId: '7',
        _columnNama: 'Anis Buru',
        _columnNamaLatin: 'Zoothera dumasi',
        _columnDeskripsi: 'Burung penyanyi khas dari Pulau Buru.',
        _columnAsal: 'Maluku',
        _columnFoto: 'assets/images/anis_buru.jpg',
        _columnStatus: 'Kritis',
      },
      {
        _columnId: '8',
        _columnNama: 'Anis Geomalia',
        _columnNamaLatin: 'Zoothera heinrichi',
        _columnDeskripsi: 'Burung endemik yang hidup di pegunungan Sulawesi.',
        _columnAsal: 'Sulawesi',
        _columnFoto: 'assets/images/anis_geomalia.jpg',
        _columnStatus: 'Rentan',
      },
      {
        _columnId: '9',
        _columnNama: 'Sri Lanka Green Pigeon',
        _columnNamaLatin: 'Treron pompadora',
        _columnDeskripsi: 'Sebenarnya bukan endemik Indonesia, tapi sering ditemukan di hutan tropis.',
        _columnAsal: 'Sri Lanka / Sumatera',
        _columnFoto: 'assets/images/sri_lanka.jpg',
        _columnStatus: 'Umum',
      },
    ];

    for (var data in dataList) {
      await db.insert(_tableName, {
        ...data,
        _columnIsFavorit: 'false',
      });
    }
  }

  Future<int> insert(Endemik object) async {
    final db = await database;
    return await db.insert(_tableName, object.toMap());
  }

  Future<List<Endemik>> getAll() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return maps.map((map) => Endemik.fromMap(map)).toList();
  }

  Future<int> setFavorit(String id, String isFavorit) async {
    final db = await database;
    return await db.update(
      _tableName,
      { _columnIsFavorit: isFavorit },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Endemik>> getFavoritAll() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: '$_columnIsFavorit = ?',
      whereArgs: ['true'],
    );
    return maps.map((map) => Endemik.fromMap(map)).toList();
  }

  Future<Endemik?> getById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Endemik.fromMap(maps.first);
  }

  Future<int> updateEndemik(Endemik object) async {
    final db = await database;
    return await db.update(
      _tableName,
      object.toMap(),
      where: '$_columnId = ?',
      whereArgs: [object.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFavoritAll() async {
    final db = await database;
    return await db.update(
      _tableName,
      { _columnIsFavorit: 'false' },
    );
  }

  Future<int> count() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
