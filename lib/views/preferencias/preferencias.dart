import 'package:flutter/material.dart';
import '../../util.dart';

class Preferencias extends StatefulWidget {
  @override
  _Preferencias createState() => _Preferencias();
}

class _Preferencias extends State<Preferencias> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var cIpBancoDados = TextEditingController();
  var cUsuario = TextEditingController();
  var cSenha = TextEditingController();
  var cServidorAPI = TextEditingController();
  var cNomeBanco = TextEditingController();

  void gravar() {
    var obj = {
      'IpBancoDados': cIpBancoDados.text.trim(),
      'Usuario': cUsuario.text.trim(),
      'Senha': cSenha.text.trim(),
      'ServidorAPI': cServidorAPI.text.trim(),
      'NomeBanco': cNomeBanco.text.trim(),
    };

    atualizaPreferencia('ServidorAPI', cServidorAPI.text);

    post('preferencias/atualizar', obj, exibeMensagem);
  }

  void exibeMensagem(txt) {
    alert(_scaffoldKey, txt['message']);
  }

  void carregar() {
    cServidorAPI.text = params['ServidorAPI'];
    get('preferencias', load);
  }

  void recarregar() {
    print("Atualizando...");
    atualizaPreferencia('ServidorAPI', cServidorAPI.text);
    get('preferencias', load);
  }

  void load(decoded) {
    cIpBancoDados.text = decoded['IpBancoDados'];
    cUsuario.text = decoded['Usuario'];
    cSenha.text = decoded['Senha'];
    cNomeBanco.text = decoded['NomeBanco'];
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      carregar();
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Preferências")),
      body: ListView(
        children: <Widget>[
          // Título
          ListTile(
              title: TextFormField(
            controller: cServidorAPI,
            // onEditingComplete: calcularRateio,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 24,
            ),
            decoration: InputDecoration(
                labelText: "Servidor API", labelStyle: TextStyle()),
          ),
          trailing: FlatButton(
            child: Icon(Icons.refresh),
            onPressed: recarregar,
          ),
          ),
          ListTile(
              title: TextFormField(
            controller: cIpBancoDados,
            // onEditingComplete: calcularRateio,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 24,
            ),
            decoration: InputDecoration(
                labelText: "Servidor Banco de Dados", labelStyle: TextStyle()),
          )),
          ListTile(
              title: TextFormField(
            controller: cUsuario,
            // onEditingComplete: calcularRateio,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 24,
            ),
            decoration:
                InputDecoration(labelText: "Usuário", labelStyle: TextStyle()),
          )),
          ListTile(
              title: TextFormField(
            controller: cSenha,
            // onEditingComplete: calcularRateio,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 24,
            ),
            decoration:
                InputDecoration(labelText: "Senha", labelStyle: TextStyle()),
          )),
          ListTile(
              title: TextFormField(
            controller: cNomeBanco,
            // onEditingComplete: calcularRateio,
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 24,
            ),
            decoration: InputDecoration(
                labelText: "Nome do Banco", labelStyle: TextStyle()),
          )),
          ListTile(
              title: Center(
            child: FlatButton(
              child: Text(
                "Gravar",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: gravar,
              color: Colors.green,
            ),
          )),
        ],
      ),
    );
  }
}
