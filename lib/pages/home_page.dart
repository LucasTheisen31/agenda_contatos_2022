import 'package:agenda_contatos_2022/helpers/contato_helper.dart';
import 'package:agenda_contatos_2022/pages/contato_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoHelper helper = ContatoHelper();
  List<Contato> listaContatos = [];

  @override
  void initState() {
    super.initState();
    _atualizarListaContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Agenda de Contatos"),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              PopupMenuItem<OrderOptions>(
                child: Text("Ordenar A-Z"),
                value: OrderOptions.orderaz,
              ),
              PopupMenuItem<OrderOptions>(
                child: Text("Ordenar Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _ordenarLIsta,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey.shade400,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey.shade800),
              currentAccountPicture: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/perfil.jpg'),
                backgroundColor: Colors.transparent,
              ),
              accountName: Text("Lucas Theisen"),
              accountEmail: Text('lucasevandro11@hotmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: null,
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Sobre'),
              onTap: _exibirSobre,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(15),
        physics: BouncingScrollPhysics(),
        itemCount: listaContatos.length,
        itemBuilder: (context, index) {
          return cardContato(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirContatoPage();
        },
        backgroundColor: Colors.blueGrey.shade800,
        child: Icon(Icons.add),
        tooltip: "Novo Contato",
      ),
    );
  }

  Widget cardContato(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _exibirOpcoes(context, index);
      },
      child: Card(
        color: Colors.blueGrey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: listaContatos[index]!.imagem != null
                          ? FileImage(File(listaContatos[index]!.imagem!))
                          : AssetImage('assets/images/perfil.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listaContatos[index].nome ?? '',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      listaContatos[index].email ?? '',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      listaContatos[index].telefone ?? '',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _atualizarListaContatos() async {
    await helper.listarTodosContatos().then((list) {
      setState(() {
        listaContatos = list;
      });
    });
  }

  _exibirContatoPage({Contato? contato}) async {
    final contatoRecuperado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContatoPage(
          contato: contato,
        ),
      ),
    );
    if (contatoRecuperado != null) {
      //para saber se foi alterado ou foi salvo um contato novo
      if (contato != null) {
        //sinal que um contato foi passado e foi editado
        await helper.atualizarContato(contatoRecuperado);
        _atualizarListaContatos();
      } else {
        //é um contato novo
        await helper.salvarContato(contatoRecuperado);
        _atualizarListaContatos();
      }
    }
  }

  _exibirSobre() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Versao 1.0'),
        content: Container(
          height: 100,
          width: 100,
          child: Image.asset(
            'assets/images/flappy-dash.gif',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            //fecha o AlertDialog,
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blueGrey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  void _exibirOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.blueGrey.shade800,
                    ),
                    title: Text("Ligar"),
                    onTap: () {
                      launch("tel:${listaContatos[index].telefone}");
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.edit,
                      color: Colors.blueGrey.shade800,
                    ),
                    title: Text("Editar"),
                    onTap: () {
                      Navigator.pop(context);
                      _exibirContatoPage(contato: listaContatos[index]);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.blueGrey.shade800,
                    ),
                    title: Text("Deletar"),
                    onTap: () {
                      Navigator.pop(context);
                      helper.deletarContato(listaContatos[index].id!);
                      setState(() {
                        listaContatos.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _ordenarLIsta(OrderOptions value) {
    switch(value){
      case OrderOptions.orderaz:
        listaContatos.sort((a, b) {
          return a.nome!.toLowerCase().compareTo(b.nome!.toLowerCase());
        },);
        break;
      case OrderOptions.orderza:
        listaContatos.sort((a, b) {
          return b.nome!.toLowerCase().compareTo(a.nome!.toLowerCase());
        },);
        break;
    }
    setState(() {
    });
  }
}
