import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rodovia_escolar/services/authentication.dart';


class CadastrarTurma extends StatefulWidget{
  @override
  _CadastrarTurmaState createState() => _CadastrarTurmaState();
}

class _CadastrarTurmaState extends State<CadastrarTurma>{
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  /*Variáveis globais */
  String nomeTurma;
  String periodo;
  String cidade;



  /*Função Salvar() dados do formulário*/
  Future<void> salvarTurma() async{
    FormState _form = _formkey.currentState;
    if(_form.validate()){
      _form.save();

      Auth auth = Auth();
      FirebaseUser currentUser = await auth.getCurrentUser();

      await Firestore.instance.collection('turma').where('uID', isEqualTo: currentUser.uid).getDocuments().then((doc){

        var dados = Map<String, dynamic>();
        dados['nomeTurma'] = this.nomeTurma;
        dados['periodo'] = this.periodo;
        dados['cidade'] = this.cidade;
        dados['uID'] = currentUser.uid;

        Firestore.instance.collection('turma').add(dados);
        Navigator.of(context).pop();
      }
      );}
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Criar Turma', style: TextStyle(color: Colors.white, fontSize: 19.0),),
          backgroundColor: Colors.blueAccent[700],
        ),
        backgroundColor: Colors.white,

        body:Form(
          autovalidate: false,
          key: _formkey,
          child:SingleChildScrollView(
            padding: EdgeInsets.only(left: 27.0, right: 27.0, top: 110.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /*CAMPOS DO FORMULÁRIO */
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nome da Turma',
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  //validator: (value) => value.isEmpty ? 'Campo em branco' :null,
                  validator: (texto) {
                    if(texto.length == 0)
                      return "Campo obrigatório";
                  },
                  onSaved: (texto){
                    this.nomeTurma = texto;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Período',
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  //validator: (value) => value.isEmpty ? 'Campo em branco' :null,
                  validator: (texto) {
                    if(texto.length == 0)
                      return "Campo obrigatório";
                  },
                  onSaved: (texto){
                    this.periodo = texto;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  //validator: (value) => value.isEmpty ? 'Campo em branco' :null,
                  validator: (texto) {
                    if(texto.length == 0)
                      return "Campo obrigatório";
                  },
                  onSaved: (texto){
                    this.cidade = texto;
                  },
                ),
                /*FORMATAÇÃO DO BUTTON */
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: Container(
                    height: 60.0,
                    child: RaisedButton(
                        onPressed: salvarTurma,
                        child: Text('Salvar', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        color: Colors.blueAccent[700],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.8))
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}