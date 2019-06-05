import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rodovia_escolar/services/authentication.dart';





class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  //GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  /*Variáveis globais */
  String nome;
  String email;
  String rg;
  String celular;
  String instituicao;
  String curso;
  String periodo;
  String cidade;
  String password;


  /*Função Salvar() dados do formulário*/
  Future<void> salvarAlunos() async{
    FormState _form = _formkey.currentState;
    if(_form.validate()){
      _form.save();

      Auth auth = Auth();
      String uID = await auth.signUp(this.email, this.password);

      var dados = Map<String, dynamic>();
      dados['nome'] = this.nome;
      dados['e-mail'] = this.email;
      dados['rg'] = this.rg;
      dados['celular'] = this.celular;
      dados['instituição'] = this.instituicao;
      dados['curso'] = this.curso;
      dados['período'] = this.periodo;
      dados['cidade'] = this.cidade;
      dados['uID'] = uID;


      await Firestore.instance.collection('alunos').add(dados);
      Navigator.of(context).pop();
    }
  }


  final _nameFocus = FocusNode();

  //bool _userEdited = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[700],
        title: Text("Cadastrar-se"),
        centerTitle: true,
      ),
      body:Form(
        autovalidate: false,
        key: _formkey,
        child:SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: "Nome",
              ),

              validator: (text) {
                if(text.length == 0)
                  return "Campo obrigatório";
              },
              onSaved: (text){
                this.nome = text;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "E-mail"),
              validator: (text) {
                if(text.length == 0)
                  return "Campo obrigatório";
              },
              onSaved: (text){
                this.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "RG"),
              validator: (text) {
                if(text.length == 0)
                  return "Campo obrigatório";
              },
              onSaved: (text){
                this.rg = text;
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Celular"),
              validator: (text) {
                if(text.length == 0)
                  return "Campo obrigatório";
              },
              onSaved: (text){
                this.celular = text;
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Cidade"),
              validator: (text) {
                if(text.length == 0)
                  return "Campo obrigatório";
              },
              onSaved: (text){
                this.cidade = text;
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Senha"),
              validator: (text) {
                if(text.length == 0)
                  return "Campo obrigatório";
              },
              onSaved: (text){
                this.password = text;
              },
              keyboardType: TextInputType.text,
            ),
            Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 60.0,
                    width: 500.0,
                    child: RaisedButton(
                        onPressed: salvarAlunos,
                        child: Text(
                          'Criar Conta',
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
      )
    );
  }
}
