import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Metodo para recuperar os dados
  _recuperarDados() async {
    final caminhoBancoDados =
        await getDatabasesPath(); //Recuperar o caminho para ambas plantaformas
    final localBancoDados = join(caminhoBancoDados, "banco.db"); //Nome do banco
    //Iniciar a conexao com o banco de dados
    openDatabase(localBancoDados, version: 1, onCreate: (db, dbVersaoRecente) {
      //db consigo fazer alteracoes para quando atualizar.
      //Exemplo de uma sql habitual de criar tabela
      String sql =
          "CREATE TABLE usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
      //Executar a sql criada.
      db.execute(sql);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLFlite Config"),
      ),
    );
  }
}
