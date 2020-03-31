import 'package:flutter/material.dart';
import '../../util.dart';

class Preferencias extends StatefulWidget {
  @override
  _Preferencias createState() => _Preferencias();
}

class _Preferencias extends State<Preferencias> {
  var cIpBancoDados = TextEditingController();
  var cUsuario = TextEditingController();
  var cSenha = TextEditingController();
  var cServidorAPI = TextEditingController();
  var cNomeBanco = TextEditingController();

  void gravar() {
    var obj = {
      'IpBancoDados': cIpBancoDados.text,
      'Usuario': cUsuario.text,
      'Senha': cSenha.text,
      'ServidorAPI': cServidorAPI.text,
      'NomeBanco': cNomeBanco.text,
    };

    atualizaPreferencia('ServidorAPI', cServidorAPI.text);

    post('preferencias/atualizar', obj);
  }

  void carregar() {
    cServidorAPI.text = params['ServidorAPI'];
    // var obj = get('preferencias');
    // print(obj);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      carregar();
    });

    return Scaffold(
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
          )),
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
