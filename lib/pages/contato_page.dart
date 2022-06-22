import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/contato_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContatoPage extends StatefulWidget {
  ContatoPage({this.contato});

  Contato? contato;

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeControler = TextEditingController();
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _telefoneControler = TextEditingController();
  final _nomeFoco = FocusNode();
  final _emailFoco = FocusNode();
  final _telefoneFoco = FocusNode();

  Contato? _contatoEditavel;
  bool _usuarioFoiEditado = false;

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {
      //se for um contato novo
      _contatoEditavel = Contato();
    } else {
      //se foi passado um contato
      _contatoEditavel = Contato.fromMap(widget.contato!.toMap());
      _nomeControler.text = _contatoEditavel!.nome!;
      _emailControler.text = _contatoEditavel!.email!;
      _telefoneControler.text = _contatoEditavel!.telefone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //chama uma funcao quando clica para retornar
      onWillPop: () => _requisitarPop(usuarioFoiEditado: _usuarioFoiEditado),
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text(_contatoEditavel!.nome ?? 'Novo Contato'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                //p/a coluna ocupar a altura maxima da tela
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //p/a coluna ocupar toda a largura da tela
                children: [
                  GestureDetector(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: _contatoEditavel!.imagem != null
                              ? FileImage(File(_contatoEditavel!.imagem!))
                              : AssetImage('assets/images/perfil.jpg')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () {
                      return _buildShowModalBottomSheet(context);
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    onChanged: (text) {
                      _usuarioFoiEditado = true;
                      _contatoEditavel!.nome = text;
                    },
                    controller: _nomeControler,
                    focusNode: _nomeFoco,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo Vazio!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 20,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blueGrey.shade800,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (text) {
                      _usuarioFoiEditado = true;
                      _contatoEditavel!.email = text;
                    },
                    controller: _emailControler,
                    focusNode: _emailFoco,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo Vazio!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 20,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blueGrey.shade800,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    onChanged: (text) {
                      _usuarioFoiEditado = true;
                      _contatoEditavel!.telefone = text;
                    },
                    controller: _telefoneControler,
                    focusNode: _telefoneFoco,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Campo Vazio!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      labelStyle: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 20,
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.blueGrey.shade800,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_contatoEditavel!.nome != null) {
              if (_contatoEditavel!.email != null) {
                if (_contatoEditavel!.telefone != null) {
                  Navigator.pop(context, _contatoEditavel);
                } else {
                  FocusScope.of(context).requestFocus(_telefoneFoco);
                }
              } else {
                FocusScope.of(context).requestFocus(_emailFoco);
              }
            } else {
              FocusScope.of(context).requestFocus(_nomeFoco);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.blueGrey.shade800,
          tooltip: "Salvar",
        ),
      ),
    );
  }

  Future<bool> _requisitarPop({required bool usuarioFoiEditado}) {
    if (usuarioFoiEditado) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Descartar alterações?"),
          content: Text("Se sair as alterações serão perdidas"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Sim"),
            ),
          ],
        ),
      );
      return Future.value(false); //nao deixa dar o pop pra tela princiap
    } else {
      return Future.value(true); //deixa voltar pra tela principal
    }
    ;
  }

  _buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        //ModalBottomSheet é o menu que sobe de baixo para cima
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                //Um widget que exibe seus filhos em várias execuções horizontais ou verticais.
                children: [
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_library,
                      color: Colors.blueGrey.shade800,
                    ),
                    title: new Text('Galeria'),
                    onTap: () {
                      pegarImageGaleria();
                      Navigator.of(context).pop(); //fecha o ModalBottomSheet
                    },
                  ),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Colors.blueGrey.shade800,
                    ),
                    title: new Text('Camera'),
                    onTap: () {
                      pegarImageCamera();
                      Navigator.of(context).pop(); //fecha o ModalBottomSheet
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void pegarImageCamera() async {
    ImagePicker().pickImage(source: ImageSource.camera).then(
      (value) {
        if (value == null) {
          return;
        } else {
          setState(() {
            _contatoEditavel!.imagem = value.path;
            _usuarioFoiEditado = true;
          });
        }
      },
    );
  }

  Future<void> pegarImageGaleria() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then(
      (value) {
        if (value == null) {
          return;
        } else {
          setState(() {
            _contatoEditavel!.imagem = value.path;
            _usuarioFoiEditado = true;
          });
        }
      },
    );
  }
}
