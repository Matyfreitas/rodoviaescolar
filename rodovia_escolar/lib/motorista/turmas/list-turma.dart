import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rodovia_escolar/motorista/turmas/create_aluno.dart';
import 'package:rodovia_escolar/motorista/turmas/edit-turma.dart';
import 'package:rodovia_escolar/motorista/turmas/lista_alunos.dart';
import 'package:rodovia_escolar/services/authentication.dart';

class ListarTurmas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListarTurmaState();
  }
}

class ListarTurmaState extends State<ListarTurmas> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<FirebaseUser> _getUser() async {
    Auth auth = Auth();
    FirebaseUser currentUser = await auth.getCurrentUser();
    return currentUser;
  }

  Future<void> usuario() async {
    FormState _form = _formkey.currentState;
    if (_form.validate()) {
      _form.save();
    }
  }

  Map<String, dynamic> _lastRemoved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Home',
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.blueAccent[700],
        title: const Text(
          'Minhas Turmas',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: FutureBuilder<FirebaseUser>(
        future: _getUser(),
        builder: (context, snapshot) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection('turma')
                .where('uID', isEqualTo: snapshot.data.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );

              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];
                  return Dismissible(
                      key: Key(snapshot.data.documents[index].toString()),
                      background: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment(-0.9, 0.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.blue,
                        child: Align(
                          alignment: Alignment(0.9, 0.0),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          setState(() {
                            _lastRemoved = Map<String, dynamic>();
                            _lastRemoved['nomeTurma'] = document['nomeTurma'];
                            _lastRemoved['periodo'] = document['periodo'];
                            _lastRemoved['cidade'] = document['cidade'];
                            _lastRemoved['uID'] = document['uID'];
                            Firestore.instance
                                .collection('turma')
                                .document(document.documentID)
                                .delete();

                            final snack = SnackBar(
                              content: Text(
                                  "Turma \"${_lastRemoved["nomeTurma"]}\" removida!"),
                              action: SnackBarAction(
                                  label: "Desfazer",
                                  onPressed: () {
                                    setState(() {
                                      Firestore.instance
                                          .collection('turma')
                                          .add(_lastRemoved);
                                    });
                                  }),
                              duration: Duration(seconds: 7),
                            );

                            Scaffold.of(context).showSnackBar(snack);
                          });
                        }
                        if (direction == DismissDirection.endToStart) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditarTurma(
                                    documentID: document.documentID)),
                          );
                        }
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(document['nomeTurma']),
                          subtitle: Text(document['periodo']),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return BottomSheet(
                                    onClosing: () {},
                                    builder: (context) {
                                      return Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: FlatButton(
                                                child: Text(
                                                  "Listar",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20.0),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListarAlunos(
                                                                documentID: document
                                                                    .documentID)),
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: FlatButton(
                                                child: Text(
                                                  "Adicionar",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20.0),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CreateAluno(
                                                                documentID: document
                                                                    .documentID)),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                });
                          },
                          isThreeLine: true,
                        ),
                      ));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent[700],
        onPressed: () {
          Navigator.of(context).pushNamed('/createTurmas');
        },
      ),
    );
  }
}
