import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  _exibirTelaCadastro(){

    showDialog(
        context: null,
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

                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ],
          );
      }
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
          backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
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
