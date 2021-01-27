import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:minhas_anotacoes/model/Anotacao.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  _exibirTelaCadastro(){

    showDialog(
        context: context,
      builder: (context) {
          return AlertDialog(
            title: Text("Adicionar Anotação"),
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
                  _salvarAnotacao();
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ],
          );
      }
    );
    
  }

  _salvarAnotacao() async {

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    Anotacao anotacao = new Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    print("salvar: " + resultado.toString() );

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
                        subtitle: Text("${anotacao.data} - ${anotacao.descricao}" ),
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
