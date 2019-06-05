import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rodovia_escolar/services/authentication.dart';

class EditarTurma extends StatefulWidget{

  final String documentID;

  EditarTurma({this.documentID});

  @override
  _EditarTurmaState createState() => _EditarTurmaState();
}

class _EditarTurmaState extends State<EditarTurma>{

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController nomeTurmaCtrl = TextEditingController();
  TextEditingController periodoCtrl = TextEditingController();
  TextEditingController cidadeCtrl = TextEditingController();

  /*Variáveis globais */
  String id;
  String nomeTurma;
  String periodo;
  String cidade;

  /*Receber um documento e atualiza*/
  Future<void> preencheForm() async {

    Auth auth = Auth();
    FirebaseUser currentUser = await auth.getCurrentUser();

    await Firestore.instance.collection('turma').document(widget.documentID).get().then((doc) {
        id = doc.documentID;
        nomeTurma = doc.data["nomeTurma"];
        periodo = doc.data["periodo"];
        cidade = doc.data["cidade"];
    });

    nomeTurmaCtrl.text = nomeTurma;
    periodoCtrl.text = periodo;
    cidadeCtrl.text = cidade;
  }

  void salvarTurma(){
    FormState _form = _formkey.currentState;
    if(_form.validate()){
      _form.save();

      var dados = Map<String, dynamic>();
      dados['nomeTurma'] = this.nomeTurma;
      dados['periodo'] = this.periodo;
      dados['cidade'] = this.cidade;

      Firestore.instance.collection('turma').document(widget.documentID).setData(dados, merge: true);
      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    this.id = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Turma', style: TextStyle(color: Colors.white, fontSize: 19.0),),
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
              controller: nomeTurmaCtrl,
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
              controller: periodoCtrl,
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
              controller: cidadeCtrl,
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


  @override
  void initState() {
    preencheForm();
  }
}