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
  _recuperarBancoDados() async {
    //Recuperar o caminho para ambas plantaformas
    final caminhoBancoDados = await getDatabasesPath();
    //Nome do banco e caminho do banco (exe: caminhoBancoDados/banco.db)
    final localBancoDados = join(caminhoBancoDados, "banco.db");
    //Iniciar a conexao com o banco de dados
    var retorno = await openDatabase(localBancoDados, version: 1,
        //db consigo fazer alteracoes para quando atualizar.
        onCreate: (db, dbVersaoRecente) {
      //Exemplo de uma sql habitual de criar tabela
      String sql =
          "CREATE TABLE usuario (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
      //Executar a sql criada.
      db.execute(sql);
    });

    print("Aberto: " + retorno.isOpen.toString());
  }

  @override
  Widget build(BuildContext context) {
    _recuperarBancoDados();
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLFlite Config"),
      ),
    );
  }
}
