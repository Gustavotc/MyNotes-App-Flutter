import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal () {
  }

  get db async {

    if( _db != null) {
      return _db;
    }
    else {

    }
  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE aotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);

  }

    inicializarDB() async {

      final caminhoBacoDados = await getDatabasesPath();
      final localBancosDado = join(caminhoBacoDados, "banco_minhas_anotacoes.db");

      var db = await openDatabase(localBancosDado, version: 1, onCreate: _onCreate);
      return db;

    }

}