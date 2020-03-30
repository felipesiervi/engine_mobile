import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/compras.dart';

// void main() => runApp(EngineMobile());

class NotaItemDetalhe extends StatefulWidget {
  final NotaItem item;

  NotaItemDetalhe(this.item);

  @override
  _NotaItemDetalhe createState() => _NotaItemDetalhe(item);
}

class _NotaItemDetalhe extends State<NotaItemDetalhe> {
  final NotaItem item;
  var cPrecoAvista = TextEditingController();
  var cPrecoPrazo = TextEditingController();
  double precoAvista;
  double precoPrazo;
  double adiciona = 0;

  _NotaItemDetalhe(this.item) {
    item.vlsubst = item.vlsubst;
    item.vlipi = item.vlipi;
    precoAvista = item.vlprecovista;
    precoPrazo = item.vlprecoprazo;

    if (precoAvista > 20)
      adiciona = 0.5;
    else if (precoAvista > 1)
      adiciona = 0.1;
    else
      adiciona = 0.05;
  }

  // Future load(id) async {
  //   http.Response response;
  //   try {
  //     print(id);

  //     response = await http
  //         .get('http://localhost:5000/compras/get_nota_itens?id=' + id);
  //     Iterable decoded = jsonDecode(response.body);
  //     print(decoded);
  //     setState(() {
  //       widget.itens = decoded.map((x) => NotaItem.fromJson(x)).toList();
  //       print(widget.itens[0].dsdetalhe);
  //     });
  //   } catch (ex) {
  //     print(ex.toString());
  //   }
  // }
  void ajustaPrecoMais() {
    precoAvista = double.parse(cPrecoAvista.text) + adiciona;
    precoPrazo = calculaPrecoPrazo(precoAvista);

    setState(() {
      cPrecoAvista.text = precoAvista.toStringAsFixed(2);
      cPrecoPrazo.text = precoPrazo.toStringAsFixed(2);
    });
  }

  void ajustaPrecoMenos() {
    precoAvista = double.parse(cPrecoAvista.text) - adiciona;
    precoPrazo = calculaPrecoPrazo(precoAvista);

    setState(() {
      cPrecoAvista.text = precoAvista.toStringAsFixed(2);
      cPrecoPrazo.text = precoPrazo.toStringAsFixed(2);
    });
  }

  double calculaPrecoPrazo(double preco) {
    double prazo = preco * 1.05;
    if (preco > 20)
      prazo = (prazo * 2).round() / 2;
    else if (preco > 1)
      prazo = (prazo * 10).round() / 10;
    else if (preco > 0.5)
      prazo = preco + 0.05;
    else
      prazo = preco;

    return prazo;
  }

  Future<void> postPreco() async {
    var url = "http://localhost:5000/compras/post_preco";
    var body = json.encode({
      "id": widget.item.iddetalhe,
      "avista": cPrecoAvista.text,
      "prazo": cPrecoPrazo.text
    });

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);
    final responseJson = json.decode(response.body);
    print(responseJson);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      cPrecoAvista.text = precoAvista.toStringAsFixed(2);
      cPrecoPrazo.text = precoPrazo.toStringAsFixed(2);
    });

    return Scaffold(
      appBar: AppBar(title: Text("Detalhes")),
      body: ListView(
        children: <Widget>[
          // Título
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: widget.item.dsdetalhe,
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          // Custo
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Custo: " + widget.item.vlunitario.toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "ST: " + widget.item.vlsubst.toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "IPI: " + widget.item.vlipi.toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Rateio: " + widget.item.vlrateio.toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          // Markup
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Margem cadastrada: " +
                  widget.item.allucrodesejada.toString() +
                  "%",
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          // Preço final
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Preço final: " +
                  (widget.item.vlcusto + widget.item.vlrateio)
                      .toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Preço sugerido: " +
                  ((widget.item.vlcusto + widget.item.vlrateio) *
                          (1 + widget.item.allucrodesejada / 100))
                      .toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          // Ajuste de preço
          ListTile(
            title: TextFormField(
              controller: cPrecoAvista,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            leading: FlatButton(
                child: Icon(Icons.remove), onPressed: ajustaPrecoMenos),
            trailing:
                FlatButton(child: Icon(Icons.add), onPressed: ajustaPrecoMais),
          ),
          // Ajuste de preço
          ListTile(
            title: TextFormField(
              controller: cPrecoPrazo,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            leading: FlatButton(
                child: Icon(Icons.remove), onPressed: ajustaPrecoMenos),
            trailing:
                FlatButton(child: Icon(Icons.add), onPressed: ajustaPrecoMais),
          ),
          ListTile(
            title: Center(
                child: FlatButton(
              child: Text(
                " Gravar ",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              onPressed: postPreco,
              color: Colors.green,
            )),
          ),
        ],
      ),
    );
  }
}
