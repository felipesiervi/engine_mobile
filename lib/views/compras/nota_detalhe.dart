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
  var cValorRateio = TextEditingController();
  static String id;

  _NotaDetalhe(id) {
    if (id != null) _NotaDetalhe.id = id;
    load(_NotaDetalhe.id);
  }

  Future load(id) async {
    http.Response response;
    try {
      response = await http
          .get('http://localhost:5000/compras/get_nota_itens?id=' + id);
      Iterable decoded = jsonDecode(response.body);
      setState(() {
        widget.itens = decoded.map((x) => NotaItem.fromJson(x)).toList();
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  void tap_item(NotaItem item) {
    Navigator.pushNamed(context, '/views/compras/nota_item_detalhe',
        arguments: item);
  }

  void calcularRateio() {
    if (cValorRateio.text.trim() != "") {
      double rateio = double.parse(cValorRateio.text);
      double totalNota = widget.itens
          .map((x) =>
              (x.vlsubst + x.vlipi + x.vlunitario + x.vlfreterateado) *
              x.qtitem)
          .fold(0, (p, c) => p + c);

      double pctRateio = rateio / totalNota;
      print(rateio);
      print(pctRateio);
      print(totalNota);
      print("----");
      for (var x in widget.itens) {
        x.vlrateio = pctRateio * x.vlcusto;
        print(x.vlrateio);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: cValorRateio,
            onEditingComplete: calcularRateio,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            decoration: InputDecoration(
                labelText: "Valor para Ratear",
                labelStyle: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        body: ListView.builder(
          itemCount: widget.itens.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = widget.itens[index];
            return ListTile(
              onTap: () => tap_item(item),
              title: RichText(
                  text: TextSpan(
                text: item.dsdetalhe + "\n",
                style: TextStyle(color: Colors.black, fontSize: 22),
                children: <TextSpan>[
                  TextSpan(
                      text: "Qtde: " + item.qtitem.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: " / Valor Nota: " +
                          item.vlunitario.toStringAsFixed(2),
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ],
              )),
              key: Key(item.iddocumentoitem),
            );
          },
        ));
  }
}
