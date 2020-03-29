import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/compras.dart';

// void main() => runApp(EngineMobile());

class NotaDetalhe extends StatefulWidget {
  List<NotaItem> itens = new List<NotaItem>();
  final String id;

  NotaDetalhe(this.id) {
    itens = [];
  }

  @override
  _NotaDetalhe createState() => _NotaDetalhe(this.id);
}

class _NotaDetalhe extends State<NotaDetalhe> {
  var newTaskCtrl = TextEditingController();
  static String id;

  _NotaDetalhe(id) {
    if (id != null) _NotaDetalhe.id = id;
    load(_NotaDetalhe.id);
  }

  Future load(id) async {
    http.Response response;
    try {
      print(id);

      response = await http
          .get('http://localhost:5000/compras/get_nota_itens?id=' + id);
      Iterable decoded = jsonDecode(response.body);
      print(decoded);
      setState(() {
        widget.itens = decoded.map((x) => NotaItem.fromJson(x)).toList();
        print(widget.itens[0].dsdetalhe);
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Detalhes")),
        body: ListView.builder(
          itemCount: widget.itens.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = widget.itens[index];
            return ListTile(
              // onTap: () => tap_item(item.iddocumento),
              title: RichText(
                  text: TextSpan(
                text: item.dsdetalhe + "\n",
                style: TextStyle(color: Colors.black, fontSize: 22),
                children: <TextSpan>[
                  TextSpan(
                      text: "Emissão: ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  // TextSpan(
                  //     text: item.dtemissao.day.toString().padLeft(2, '0') +
                  //         "/" +
                  //         item.dtemissao.month.toString().padLeft(2, '0'),
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold)),
                  // TextSpan(
                  //     text: "  Valor: ",
                  //     style: TextStyle(color: Colors.black, fontSize: 16)),
                  // TextSpan(
                  //     text: item.vltotal.toStringAsFixed(2),
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.bold)),
                ],
              )),
              key: Key(item.iddocumentoitem),
              // leading: Text(),
              // onChanged: (value) {
              //   setState(() {
              //     item.done = value;
              //   });
              // },
            );
          },
        ));
  }
}
