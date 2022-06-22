import 'package:agenda_contatos_2022/pages/contato_page.dart';
import 'package:agenda_contatos_2022/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agenda de Contatos 2022',
      theme: ThemeData(
        textSelectionTheme:  TextSelectionThemeData(
          cursorColor: Colors.blueGrey.shade900,//cor do cursor
          selectionColor: Colors.blueGrey.shade300,//cor da selecao do texto
          selectionHandleColor: Colors.blueGrey.shade900,//cor do botao de arrastar o cursor
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade800,
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.blueGrey.shade800//cor do efeito de brilho de overscroll
        )
      ),
      home: HomePage(),
    );
  }
}
