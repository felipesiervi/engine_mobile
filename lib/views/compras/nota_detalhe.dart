import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

// void main() => runApp(EngineMobile());

class NotaDetalhe extends StatefulWidget {
  final String id;

  NotaDetalhe(this.id);

  @override
  _NotaDetalhe createState() => _NotaDetalhe(this.id);
}

class _NotaDetalhe extends State<NotaDetalhe> {
  List<NotaItem> itens = new List<NotaItem>();
  var cValorRateio = TextEditingController();
  static String id;

  _NotaDetalhe(id) {
    if (id != null) _NotaDetalhe.id = id;
    call(_NotaDetalhe.id);
  }

  Future call(id) async {
    await get('compras/get_nota_itens?id=' + id, load);
  }

  void load(decoded) {
    List<NotaItem> list = new List<NotaItem>();
    decoded.forEach((x) => list.add(NotaItem.fromJson(x)));
    setState(() {
      itens = list;
    });
  }

  void tapItem(int index) {
    Navigator.pushNamed(context, '/views/compras/nota_item_detalhe',
        arguments: [itens, index]);
  }

  void calcularRateio() {
    if (cValorRateio.text.trim() != "") {
      double rateio = double.parse(cValorRateio.text);
      double totalNota = itens
          .map((x) =>
              (x.vlsubst + x.vlipi + x.vlunitario) *
              x.qtitem)
          .fold(0, (p, c) => p + c);

      double pctRateio = rateio / totalNota;
      print(rateio);
      print(pctRateio);
      print(totalNota);
      print("----");
      for (var x in itens) {
        x.vlrateio = pctRateio * x.vlcusto;
        print(x.vlrateio);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Aplicar",
                style: TextStyle(fontSize: 22),
              ),
              onPressed: () {
                calcularRateio();
              },
              textColor: Colors.white,
            )
          ],
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
          itemCount: itens.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = itens[index];
            return ListTile(
              onTap: () => tapItem(index),
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
