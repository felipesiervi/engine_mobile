import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/compras.dart';
import '../../util.dart';

class NotaItemDetalhe extends StatefulWidget {
  final NotaItem item;

  NotaItemDetalhe(this.item);

  @override
  _NotaItemDetalhe createState() => _NotaItemDetalhe(item);
}

class _NotaItemDetalhe extends State<NotaItemDetalhe> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final NotaItem item;
  var cPrecoAvista = TextEditingController();
  var cPrecoPrazo = TextEditingController();
  var cMargem = TextEditingController();
  double precoAvista;
  double precoPrazo;
  double adiciona = 0;

  _NotaItemDetalhe(this.item) {
    // item.vlsubst = item.vlsubst;
    // item.vlipi = item.vlipi;
    precoAvista = item.vlprecovista;
    precoPrazo = item.vlprecoprazo;

    if (precoAvista > 20)
      adiciona = 0.5;
    else if (precoAvista > 1)
      adiciona = 0.1;
    else
      adiciona = 0.05;
  }

  @override
  void initState() {
    call(item.iddocumentoitem);
    super.initState();
  }

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

  void ajustaPrecoPrazoMais() {
    precoPrazo += adiciona;

    setState(() {
      cPrecoPrazo.text = precoPrazo.toStringAsFixed(2);
    });
  }

  void ajustaPrecoPrazoMenos() {
    precoPrazo -= adiciona;

    setState(() {
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

  Future call(id) async {
    await get('compras/get_nota_item?id=' + id, load);
  }

  void load(decoded) {
    setState(() {
      cPrecoAvista.text =
          double.parse(decoded['vlprecovista'].toString()).toStringAsFixed(2);
      cPrecoPrazo.text =
          double.parse(decoded['vlprecoprazo'].toString()).toStringAsFixed(2);
      cMargem.text = double.parse(decoded['allucrodesejada'].toString())
          .toStringAsFixed(2);
    });
  }

  Future<void> postPreco() async {
    var body = json.encode({
      "id": widget.item.iddetalhe,
      "avista": double.parse(cPrecoAvista.text),
      "prazo": double.parse(cPrecoPrazo.text),
      "margem": double.parse(cMargem.text)
    });

    post('compras/post_preco', body, exibeMensagem);
  }

  void exibeMensagem(txt) {
    alert(_scaffoldKey, txt['message']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              style: TextStyle(color: Colors.black, fontSize: 20),
            ))),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "ST: " +
                  widget.item.vlsubst.toStringAsFixed(2) +
                  " / IPI: " +
                  widget.item.vlipi.toStringAsFixed(2) +
                  " / Rateio: " +
                  widget.item.vlrateio.toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 20),
            ))),
          ),
          // Markup
          ListTile(
            // title: TextFormField(
            //   // controller: cPrecoAvista,
            //   keyboardType: TextInputType.number,
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 24,
            //   ),
            // ),
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Margem cadastrada",
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          ListTile(
            title: TextFormField(
              textAlign: TextAlign.center,
              controller: cMargem,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            leading: Text(""),
            trailing: Text(""),
          ),
          // Preço final
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Custo final: " +
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
                          (1 + (widget.item.allucrodesejada ?? 0) / 100))
                      .toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          // Ajuste de preço
          ListTile(
            title: TextFormField(
              textAlign: TextAlign.center,
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
              textAlign: TextAlign.center,
              controller: cPrecoPrazo,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            leading: FlatButton(
                child: Icon(Icons.remove), onPressed: ajustaPrecoPrazoMenos),
            trailing: FlatButton(
                child: Icon(Icons.add), onPressed: ajustaPrecoPrazoMais),
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
              onPressed: () => postPreco(),
              color: Colors.green,
            )),
          ),
        ],
      ),
    );
  }
}
