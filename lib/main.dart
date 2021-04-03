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
  final tabela = "usuario";
  //Metodo para recuperar os dados
  _recuperarBancoDados() async {
    //Recuperar o caminho para ambas plantaformas
    final caminhoBancoDados = await getDatabasesPath();
    //Nome do banco e caminho do banco (exe: caminhoBancoDados/banco.db)
    final localBancoDados = join(caminhoBancoDados, "banco.db");
    //Iniciar a conexao com o banco de dados
    var bd = await openDatabase(localBancoDados, version: 1,
        //db consigo fazer alteracoes para quando atualizar.
        onCreate: (db, dbVersaoRecente) {
      //Exemplo de uma sql habitual de criar tabela
      String sql = "CREATE TABLE " +
          tabela +
          "(id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER) ";
      //Executar a sql criada.
      db.execute(sql);
    });
    return bd;
  }

  //print("Aberto: " + bd.isOpen.toString());
  //Metodo para salvar dados
  _salvarDados() async {
    Database bd = await _recuperarBancoDados();
    //Valores a inserir no do banco
    Map<String, dynamic> dadosUsuario = {"nome": "Anair Chameia", "idade": 17};
    //Comando Para Inserir
    int id = await bd.insert(tabela, dadosUsuario);
    print("Salvo: $id");
  }

  @override
  Widget build(BuildContext context) {
    _salvarDados();
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLFlite Config"),
      ),
    );
  }
}
