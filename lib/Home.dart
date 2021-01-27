import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro( {Anotacao anotacao}){

    String textoSalvarAtualizar = "";
    if(anotacao == null){ //Salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    } else { //Atualizar
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
      builder: (context) {
          return AlertDialog(
            title: Text("$textoSalvarAtualizar Anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título..."
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite descrição..."
                  ),
                ),
              ],
            ),
            actions: <Widget> [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: (){
                  //Salvar
                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                  Navigator.pop(context);
                },
                child: Text(textoSalvarAtualizar),
              ),
            ],
          );
      }
    );
    
  }

  _salvarAtualizarAnotacao( {Anotacao anotacaoSelecionada} ) async {

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if(anotacaoSelecionada == null) { //salvar
      Anotacao anotacao = new Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
    } else { //atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao( anotacaoSelecionada );
    }


    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _recuperarAnotacoes() async {

    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = List<Anotacao>();

    for( var item in anotacoesRecuperadas ){

      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add( anotacao );
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = null;

    print("lista " + anotacoesRecuperadas.toString());
  }

  _formatarData(String data){

    initializeDateFormatting("pt_br");

    //var formatador = DateFormat("d/M/y");
    var formatador = DateFormat.yMd("pt_BR");

    DateTime dataConvertida = DateTime.parse( data );
    String dataFormatada = formatador.format( dataConvertida );

    return dataFormatada;

  }

  _removerAnotacao(int id) async{

    await _db..removerAnotacao( id );

    _recuperarAnotacoes();
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
          backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                itemCount: _anotacoes.length,
                  itemBuilder: (context, index){

                  final anotacao = _anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text( anotacao.titulo ),
                        subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}" ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget> [
                            GestureDetector(
                              onTap: (){
                                _exibirTelaCadastro(anotacao: anotacao);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _removerAnotacao( anotacao.id );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  )
              )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
