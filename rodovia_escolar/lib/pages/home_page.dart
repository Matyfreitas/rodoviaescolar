import 'package:flutter/material.dart';
import 'package:rodovia_escolar/pages/editar_perfil.dart';
import 'package:rodovia_escolar/services/authentication.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verifique seu Email"),
          content: new Text("Valide sua conta no link enviado ao seu email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Reenviar link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Mais Tarde"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verifique seu Email"),
          content: new Text("Valide sua conta no link enviado ao seu email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Mais Tarde"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Rodovia Escolar'),
          backgroundColor: Colors.blueAccent[700],
          actions: <Widget>[
            /* PARA SAIR DO APLICATIVO */
            new FlatButton(
                child: new Text('Sair',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
        /*
         * OPÇÕES DE ENTRADA --- CARDS
         */
        body: ListView(
          children: <Widget>[
            Card(child: ListTile(
              leading: Icon(Icons.directions_bus, size: 70.0, color: Colors.black87),
              title: Text('Navegar como Motorista'),
              subtitle: Text('Organize melhor seus passageiros'),
              isThreeLine: true,
              onTap: () {Navigator.of(context).pushNamed('/listTurmas');},
            ),),
            Card(child: ListTile(
              leading: Icon(Icons.person_pin_circle, size: 70.0, color: Colors.black87),
              title: Text('Editar Perfil'),
              subtitle: Text('Altere os dados do seu perfil'),
              isThreeLine: true,
              onTap: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditarPage()),
              );
              },
            ),),
          ],
        ) 
    );
  }
}
