import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAluno extends StatefulWidget {

  final String documentID;

  CreateAluno({this.documentID});

  @override
  _CreateAlunoState createState() => _CreateAlunoState();
}

class _CreateAlunoState extends State<CreateAluno> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  /*Variáveis globais */
  String id;
  String nomeAluno;
  String celular;
  String periodo;
  String local;

  Future<void> preencheForm() async {

    await Firestore.instance.collection('turma').document(widget.documentID).get().then((doc) {
        id = doc.documentID;

    });
  }

  /*Função Salvar() dados do formulário*/
  Future<void> salvarAluno() async {
    FormState _form = _formkey.currentState;
    if (_form.validate()) {
      _form.save();

    
      var dados = Map<String, dynamic>();
      dados['nomeAluno'] = this.nomeAluno;
      dados['periodo'] = this.periodo;
      dados['celular'] = this.celular;
      dados['local'] = this.local;
      dados['uID'] = this.id;

      await Firestore.instance
          .collection('turma')
          .document(widget.documentID)
          .collection('list_alunos')
          .add(dados);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Criar Turma',
            style: TextStyle(color: Colors.white, fontSize: 19.0),
          ),
          backgroundColor: Colors.blueAccent[700],
        ),
        backgroundColor: Colors.white,
        body: Form(
          autovalidate: false,
          key: _formkey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 27.0, right: 27.0, top: 110.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /*CAMPOS DO FORMULÁRIO */
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nome do Aluno',
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  //validator: (value) => value.isEmpty ? 'Campo em branco' :null,
                  validator: (texto) {
                    if (texto.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (texto) {
                    this.nomeAluno = texto;
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
                    if (texto.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (texto) {
                    this.periodo = texto;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Local',
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  //validator: (value) => value.isEmpty ? 'Campo em branco' :null,
                  validator: (texto) {
                    if (texto.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (texto) {
                    this.local = texto;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Celular',
                    labelStyle: TextStyle(color: Colors.black87),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  //validator: (value) => value.isEmpty ? 'Campo em branco' :null,
                  validator: (texto) {
                    if (texto.length == 0) return "Campo obrigatório";
                  },
                  onSaved: (texto) {
                    this.celular = texto;
                  },
                ),
                /*FORMATAÇÃO DO BUTTON */
                Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: Container(
                    height: 60.0,
                    child: RaisedButton(
                        onPressed: salvarAluno,
                        child: Text(
                          'Salvar Aluno',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        color: Colors.blueAccent[700],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.8))),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

    @override
  void initState() {
    preencheForm();
  }
}
