import 'package:flutter/material.dart';
import 'package:rodovia_escolar/motorista/turmas/create_aluno.dart';
import 'package:rodovia_escolar/pages/criar_conta.dart';

import 'motorista/turmas/create_turma.dart';
import 'motorista/turmas/edit-turma.dart';
import 'motorista/turmas/list-turma.dart';
import 'pages/root_page.dart';
import 'services/authentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rodovia Escolar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => RootPage(auth: Auth()),
          '/criarConta': (context) => ContactPage(),
          '/listTurmas': (context) => ListarTurmas(),
          '/editTurmas' : (context) => EditarTurma(),
          '/createTurmas' : (context) => CadastrarTurma(), 
          '/createAluno' : (context) => CreateAluno(), 
        },
        /*home: new RootPage(auth: new Auth()));*/
    );
  }
}
