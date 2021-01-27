import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal () {
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async{

    var bancoDados = await db;
    int resultado = await bancoDados.insert( nomeTabela, anotacao.toMap() );
    return resultado;
  }

  recuperarAnotacoes() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await bancoDados.rawQuery( sql );
    return anotacoes;

  }

  get db async {

    if( _db != null) {
      return _db;
    }
    else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE $nomeTabela ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "titulo VARCHAR, "
        "descricao TEXT, "
        "data DATETIME)";
    await db.execute(sql);

  }

    inicializarDB() async {

      final caminhoBacoDados = await getDatabasesPath();
      final localBancosDado = join(caminhoBacoDados, "banco_minhas_anotacoes.db");

      var db = await openDatabase(localBancosDado, version: 1, onCreate: _onCreate);
      return db;

    }

}