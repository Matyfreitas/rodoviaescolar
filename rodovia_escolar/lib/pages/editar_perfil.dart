import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rodovia_escolar/services/authentication.dart';



class EditarPage extends StatefulWidget {
  @override
  _EditarPageState createState() => _EditarPageState();
}

class _EditarPageState extends State<EditarPage> {



  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController rgController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController instituicaoController = TextEditingController();
  TextEditingController cursoController = TextEditingController();
  TextEditingController periodoController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  /*Variáveis globais */
  String id;
  String nome;
  String email;
  String rg;
  String celular;
  String instituicao;
  String curso;
  String periodo;
  String cidade;

  Future<void> preencheForm() async {

    Auth auth = Auth();
    FirebaseUser currentUser = await auth.getCurrentUser();

    await Firestore.instance.collection('alunos').where('uID', isEqualTo: currentUser.uid).getDocuments().then((doc){
      if(doc.documents.isNotEmpty) {
        id = doc.documents[0].documentID;
        nome = doc.documents[0].data["nome"];
        email = doc.documents[0].data["e-mail"];
        rg = doc.documents[0].data["rg"];
        celular = doc.documents[0].data["celular"];
        instituicao = doc.documents[0].data["instituição"];
        curso = doc.documents[0].data["curso"];
        periodo = doc.documents[0].data["período"];
        cidade = doc.documents[0].data["cidade"];
      }
    });


      nomeController.text = nome;
      emailController.text = email;
      rgController.text = rg;
      celularController.text = celular;
      instituicaoController.text = instituicao;
      cursoController.text = curso;
      periodoController.text = periodo;
      cidadeController.text = cidade;

  }


  /*Função Salvar() dados do formulário*/
  Future<void> editarAlunos() async{
    FormState _form = _formkey.currentState;
    if (_form.validate()) {
      _form.save();

      Auth auth = Auth();
      FirebaseUser currentUser = await auth.getCurrentUser();

      var dados = Map<String, dynamic>();
      dados['nome'] = this.nome;
      dados['e-mail'] = this.email;
      dados['rg'] = this.rg;
      dados['celular'] = this.celular;
      dados['instituição'] = this.instituicao;
      dados['curso'] = this.curso;
      dados['período'] = this.periodo;
      dados['cidade'] = this.cidade;
      dados['uID'] = currentUser.uid;



      Firestore.instance
          .collection("alunos")
          .document(this.id)
          .setData(dados, merge: true);
    }
  }

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  @override
  Widget build(BuildContext context) {
            // this.id = ModalRoute.of(context).settings.arguments;

            return Scaffold(
            appBar: AppBar(
            backgroundColor: Colors.blueAccent[700],
            title: Text("Editar"),
            centerTitle: true,
          ),
          body: Form(
            autovalidate: false,
            key: _formkey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
              children: <Widget>[
                /* GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/person.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  onTap: () {},
                ), */
                TextFormField(
                  controller: nomeController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        tooltip: 'Apagar informação',
                        onPressed: () {
                          nomeController.text = "";
                        }),),
                  validator: (text) {
                    if (text.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (text) {
                    this.nome = text;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "E-mail",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        tooltip: 'Apagar informação',
                        onPressed: () {
                          emailController.text = "";
                        }),),
                  validator: (text) {
                    if (text.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (text) {
                    this.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: rgController,
                  decoration: InputDecoration(labelText: "RG",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        tooltip: 'Apagar informação',
                        onPressed: () {
                          rgController.text = "";
                        }),),
                  validator: (text) {
                    if (text.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (text) {
                    this.rg = text;
                  },
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: celularController,
                  decoration: InputDecoration(labelText: "Celular",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        tooltip: 'Apagar informação',
                        onPressed: () {
                          celularController.text = "";
                        }),),
                  validator: (text) {
                    if (text.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (text) {
                    this.celular = text;
                  },
                  keyboardType: TextInputType.text,
                ),
                TextFormField(
                  controller: cidadeController,
                  decoration: InputDecoration(labelText: "Cidade",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.cancel),
                        tooltip: 'Apagar informação',
                        onPressed: () {
                          cidadeController.text = "";
                        }),),
                  validator: (text) {
                    if (text.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (text) {
                    this.cidade = text;
                  },
                  keyboardType: TextInputType.text,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 60.0,
                    width: 500.0,
                    child: RaisedButton(
                        onPressed: editarAlunos,
                        child: Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        color: Colors.blueAccent[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.8)))

                  )
            )
              ],
            ),
          ),
      ),
    );
  }

  @override
  void initState() {
    preencheForm();
  }
}
