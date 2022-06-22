import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//nome das colunas e da tabela do banco de dados, colocados em Strings para nao ficar reescrevendo toda vez
final String tabelaContato = 'tabelaContato';
final String idColuna = 'idColuna';
final String nomeColuna = 'nomeColuna';
final String emailColuna = 'emailColuna';
final String telefoneColuna = 'telefoneColuna';
final String imagemColuna = 'imagemColuna';

class ContatoHelper {
  //padrao singleton ou seja somente tera uma instancia do objeto para o sistema
  static final ContatoHelper _instancia = ContatoHelper.internal();
  ContatoHelper.internal(); //construtor nomeado
  factory ContatoHelper() => _instancia; //retorna a instancia da classe
  Database? _db; //banco de dados

  Future<Database> get getDb async {
    //getter banco de dados
    if (_db != null) {
      //se o banco de dados ja estiver instanciado
      return _db!;
    } else {
      _db = await iniciaDb(); //metodo que inicia o banco
      return _db!;
    }
  }

  Future<Database> iniciaDb() async {
    final databasePatch = await getDatabasesPath(); //obter o diretório de bancos de dados
    final path = join(databasePatch, 'contatos.db'); //junta o diretório de bancos de dados com o banco de dados

    //metodo para abrir o banco de dados, oncreate é a funcao executada na primeira vez que abre o banco
    //ou seja quando cria o banco pela primeira vez,
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
          await db.execute( //comando para criar as tabelas e colunas do banco
              'CREATE TABLE $tabelaContato($idColuna INTEGER PRIMARY KEY, $nomeColuna TEXT, $emailColuna TEXT, '
                  '$telefoneColuna TEXT, $imagemColuna TEXT)');
        });
  }

  Future<Contato> salvarContato(Contato contato) async {
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    contato.id = await dbContatos.insert(tabelaContato, contato.toMap());
    return contato;
  }

  Future<Contato?> buscarContato(int id) async {
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    List<Map> mapas = await dbContatos.query(tabelaContato,
        columns: [
          idColuna,
          nomeColuna,
          emailColuna,
          telefoneColuna,
          imagemColuna
        ],
        where: '$idColuna = ?',
        whereArgs: [id]);
    if (mapas.length > 0) {
      //se obteve algum resultado
      return Contato.fromMap(mapas
          .first); //retorna o 1 resultado convertendo de Mapa para um Contato
    }
    return null;
  }

  Future<int> deletarContato(int id) async {
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    return await dbContatos
        .delete(tabelaContato, where: '$idColuna = ?', whereArgs: [id]);
  }

  Future<int> atualizarContato(Contato contato) async {
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    return await dbContatos.update(tabelaContato, contato.toMap(),
        where: '$idColuna = ?', whereArgs: [contato.id]);
  }

  Future<List<Contato>> listarTodosContatos() async {
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    List<Map> listaMapas = await dbContatos.rawQuery(
        'SELECT * FROM $tabelaContato');
    List<Contato> listaContatos = [];
    for (Map m in listaMapas) {
      listaContatos.add(Contato.fromMap(m));//// Transforma de mapa para dados normais
    }
    return listaContatos;
  }

  Future<int?>getNumeroContatos() async{
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    return Sqflite.firstIntValue(
        await dbContatos.rawQuery('SELECT COUNT(*) FROM $tabelaContato'));
  }

  Future close() async{
    Database dbContatos = await getDb; //recupera a instancia do banco de dados
    return dbContatos.close();
  }

}

class Contato {
   int? id;
   String? nome;
   String? email;
   String? telefone;
   String? imagem;//local onde a imagem é salva no dispositivo

  Contato();

  //contrutor p/instanciar um contato atraves de um Map que é recebido do banco de dados
  Contato.fromMap(Map map) {
    id = map[idColuna];
    nome = map[nomeColuna];
    email = map[emailColuna];
    telefone = map[telefoneColuna];
    imagem = map[imagemColuna];
  }

  //construtor para transformar um contato para forma de Map para poder armazenar no banco de dados
   Map<String, dynamic> toMap() {
    Map<String, dynamic> contatoMapa = {//preenchendo o mapa
      nomeColuna: nome,
      emailColuna: email,
      telefoneColuna: telefone,
      imagemColuna: imagem,
    };
    if (idColuna != null) {
      contatoMapa[idColuna] = id;
    }
    return contatoMapa; //retorna o contato em formato de Mapa para armazenar no banco
  }

  @override
  String toString() {
    //quando printar um objeto do tipo contato ele vai chamar o metodo toString retornando os dados do contato
    return ("Contato (ID: $id, Nome: $nome, Email: $email, Telefone: $telefone, Imagen: $imagem");
  }
}
