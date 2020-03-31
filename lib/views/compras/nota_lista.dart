import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/compras.dart';
import '../../util.dart';

class NotaLista extends StatefulWidget {
  var fornecedores = new List<Fornecedor>();

  NotaLista() {
    fornecedores = [];
  }
  @override
  _NotaListaState createState() => _NotaListaState();
}

class _NotaListaState extends State<NotaLista> {
  var newTaskCtrl = TextEditingController();

  _NotaListaState() {}
  Future load() async {
    print(1);
    Iterable decoded = await get('compras/get_notas');
    print(2);
    setState(() {
      widget.fornecedores = decoded.map((x) => Fornecedor.fromJson(x)).toList();
    });
  }

  void tap_item(String id) {
    Navigator.pushNamed(context, '/views/compras/nota_detalhe', arguments: id);
  }

//
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(),
        builder: (BuildContext context, load) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Notas de Entrada",
                style: TextStyle(fontSize: 22),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/views/preferencias/preferencias');
                  },
                  textColor: Colors.white,
                )
              ],
            ),
            body: ListView.builder(
              itemCount: widget.fornecedores.length,
              itemBuilder: (BuildContext ctx, int index) {
                final item = widget.fornecedores[index];
                return ListTile(
                  onTap: () => tap_item(item.iddocumento),
                  title: RichText(
                      text: TextSpan(
                    text: item.nmpessoa + "\n",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Emissão: ",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      TextSpan(
                          text: item.dtemissao.day.toString().padLeft(2, '0') +
                              "/" +
                              item.dtemissao.month.toString().padLeft(2, '0'),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "  Valor: ",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      TextSpan(
                          text: item.vltotal.toStringAsFixed(2),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  )),
                  key: Key(item.iddocumento),
                  // leading: Text(),
                  // onChanged: (value) {
                  //   setState(() {
                  //     item.done = value;
                  //   });
                  // },
                );
              },
            ),
          );
        });
  }
}
