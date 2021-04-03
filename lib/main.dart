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
    Map<String, dynamic> dadosUsuario = {
      "nome": "Alberto Vatal",
      "idade": 25,
    };
    //Comando Para Inserir
    int id = await bd.insert(tabela, dadosUsuario);
    print("Salvo: $id");
  }

//Metodo para lista os dados cadastrados
  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    //Filtra todos dados
    String sql = "SELECT * FROM " + tabela;
    //Fazendo a listagem por meio de tabelas
    List usuarios = await bd.rawQuery(sql);
    //Percorrer a lista
    for (var usuario in usuarios) {
      print(
        "Item id: " +
            usuario['id'].toString() +
            " Nome: " +
            usuario['nome'] +
            " Idade: " +
            usuario['idade'].toString(),
      );
    }
    // print("Usuarios Salvos: " + usuarios.toString());
  }

  //Metodo para recuperar um usuario pelo ID para apagar, atualizar
  _recuperarUsuario(int id) async {
    //Iniciar o banco
    Database bd = await _recuperarBancoDados();
    List usuarios = await bd.query(
      tabela,
      columns: ["id", "nome", "idade"],
      where: "id = ?",
      whereArgs: [id],
    );
    for (var usuario in usuarios) {
      print(
        "Item id: " +
            usuario['id'].toString() +
            " Nome: " +
            usuario['nome'] +
            " Idade: " +
            usuario['idade'].toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //Execucao dos metodos
    //_salvarDados();
    // _listarUsuarios();
    _recuperarUsuario(6);
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLFlite Config"),
      ),
    );
  }
}
