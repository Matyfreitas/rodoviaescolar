import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

// enum OrderOptions {orderaz, orderza}

class ListarAlunos extends StatefulWidget {
  final String documentID;

  ListarAlunos({this.documentID});

  @override
  State<StatefulWidget> createState() {
    return ListarAlunosState();
  }
}

class ListarAlunosState extends State<ListarAlunos> {
  String userId;

  /* void _orderList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        alunos'].sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  } */

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
          'Meus Alunos',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('turma')
            .document(widget.documentID)
            .collection('list_alunos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data.documents[index];
              final DocumentSnapshot aluno = snapshot.data.documents[index];
              return GestureDetector(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("images/person.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                document['nomeAluno'] ?? "",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                document['local'] ?? "",
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
                                        "Ligar",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20.0),
                                      ),
                                      onPressed: () {
                                        launch("tel:${document['celular']}");
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: FlatButton(
                                      child: Text(
                                        "Excluir",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20.0),
                                      ),
                                      onPressed: () {
                                        Firestore.instance
                                            .collection('turma')
                                            .document(widget.documentID)
                                            .collection('list_alunos')
                                            .document(aluno.documentID)
                                            .delete();
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
              );
            },
          );
        },
      ),
      );   
  }
}
