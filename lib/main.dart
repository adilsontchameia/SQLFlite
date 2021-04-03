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
      "nome": "Adalgiza Barbosa",
      "idade": 15
    };
    //Comando Para Inserir
    int id = await bd.insert(tabela, dadosUsuario);
    print("Salvo: $id");
  }

//Metodo para lista os dados cadastrados
  _listarUsuarios() async {
    Database bd = await _recuperarBancoDados();
    //* significa tudo
    //FILTROS DE BUSCA
    //Filtro WHERE (onde)   String sql = "SELECT * FROM " + tabela + " WHERE idade = 19";
    //"SELECT * FROM " + tabela + " WHERE idade >= 19 and idade <= 25 ";
    // String sql = "SELECT * FROM " + tabela + " WHERE idade BETWEEN 19 AND 25 "; traz entre um intervalo
    //String sql = "SELECT * FROM " + tabela + " WHERE idade IN (19,25) "; traz com exatidao
    //FILTRO DE PESQUISA
    //String sql = "SELECT * FROM " + tabela + " WHERE nome = 'Adilson Chameia' "; Filtrar nome
    //String sql = "SELECT * FROM " + tabela + " WHERE nome LIKE 'Adilson%' "; pesquisa nome e apos vem qualquer coisa
    //String sql = "SELECT * FROM " + tabela + " WHERE nome LIKE '%Ad%' ";
    // String sql = "SELECT * FROM " + tabela + " WHERE nome LIKE '%" + filtro + "%' ";
    //ORDENACAO DE RESULTADOS
    //String sql = "SELECT * FROM " + tabela + " WHERE 1=1 ORDER BY nome "; //ASC, DESC
    //String sql = "SELECT * FROM " + tabela + " WHERE 1=1 ORDER BY UPPER(nome) DESC "; //colocar maiuscula na ordenacao e cosulta
    //String sql = "SELECT * FROM " + tabela + " WHERE 1=1 ORDER BY idade ASC ";
    //String sql = "SELECT * FROM " + tabela + " WHERE 1=1 ORDER BY idade ASC LIMIT 3 "; //limitar a pesquisa
    //FIM DE FILTROS
    //String sql = "SELECT * FROM " + tabela; Traz tudo
    //String filtro = "A";
    String sql =
        "SELECT * FROM " + tabela + " WHERE 1=1 ORDER BY idade ASC LIMIT 3 ";
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

  @override
  Widget build(BuildContext context) {
    //Execucao dos metodos
    //_salvarDados();
    _listarUsuarios();
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLFlite Config"),
      ),
    );
  }
}
