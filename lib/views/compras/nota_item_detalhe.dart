import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

class NotaItemDetalhe extends StatefulWidget {
  final List<NotaItem> listaItem;
  final int itemAtual;

  NotaItemDetalhe(this.listaItem, this.itemAtual);

  @override
  _NotaItemDetalhe createState() => _NotaItemDetalhe(listaItem, itemAtual);
}

class _NotaItemDetalhe extends State<NotaItemDetalhe> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<NotaItem> listaItem;
  int itemAtual;
  NotaItem item;
  var cPrecoAvista = TextEditingController();
  var cPrecoPrazo = TextEditingController();
  var cMargem = TextEditingController();
  var cPrecoSugerido = TextEditingController();
  double precoAvista;
  double precoPrazo;
  double precoCusto;
  double adiciona = 0;

  _NotaItemDetalhe(this.listaItem, this.itemAtual) {
    // item.vlsubst = item.vlsubst;
    // item.vlipi = item.vlipi;
    calculatela();
  }

  void calculatela(){
    item = listaItem[itemAtual];
    precoAvista = item.vlprecovista;
    precoPrazo = item.vlprecoprazo;
    cPrecoSugerido.text = ((item.vlcusto + item.vlrateio) * (1+item.allucrodesejada / 100)).toStringAsFixed(2);
    
    if (precoAvista > 20)
      adiciona = 0.5;
    else if (precoAvista > 1)
      adiciona = 0.1;
    else
      adiciona = 0.05;



  }

  @override
  void initState() {

    super.initState();

    call(item);
    
  }

  void proximoItem() {
    itemAtual += 1;
    if(itemAtual >= listaItem.length){
      itemAtual = listaItem.length - 1;
      exibeMensagem({'message': 'Este é o último item da nota.'});
    }

    calculatela();
    call(item);
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

  void ajustaMargemMais() {
    double margem = double.parse(cMargem.text) + 1;

    setState(() {
      cMargem.text = margem.toStringAsFixed(2);
      cPrecoSugerido.text = ((1+margem/100) * (item.vlcusto + item.vlrateio)).toStringAsFixed(2);
    });
  }

  void ajustaMargemMenos() {
    double margem = double.parse(cMargem.text) - 1;

    setState(() {
      cMargem.text = margem.toStringAsFixed(2);
      cPrecoSugerido.text = ((1+margem/100) * (item.vlcusto + item.vlrateio)).toStringAsFixed(2);
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

  Future call(NotaItem item) async {
    if(listaItem[itemAtual].idmontagem == "")
      await get('compras/get_nota_item?id=' + item.iddocumentoitem, load);
    else
      loadoff(item);
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
  void loadoff(NotaItem i) {
    setState(() {
      cPrecoAvista.text = i.vlprecovista.toStringAsFixed(2);
      cPrecoPrazo.text = i.vlprecoprazo.toStringAsFixed(2);
      cMargem.text = i.allucrodesejada.toStringAsFixed(2);
    });
  }

  Future<void> postPreco() async {
    var body = json.encode({
      "id": item.iddetalhe,
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
              text: item.dsdetalhe,
              style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          // Custo
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Custo: " + item.vlunitario.toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 20),
            ))),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "ST: " +
                  item.vlsubst.toStringAsFixed(2) +
                  " / IPI: " +
                  item.vlipi.toStringAsFixed(2) +
                  " / Rateio: " +
                  item.vlrateio.toStringAsFixed(2),
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
            leading: FlatButton(
                child: Icon(Icons.remove), onPressed: ajustaMargemMenos),
            trailing: FlatButton(
                child: Icon(Icons.add), onPressed: ajustaMargemMais),
          ),
          // Preço final
          ListTile(
            title : Center(child:RichText(
              text: TextSpan(text: "Custo final: " + (item.vlcusto + item.vlrateio)
                      .toStringAsFixed(2),
                      style: TextStyle(color: Colors.black, fontSize: 22),
            ))),
          ),
          ListTile(
            title: Center(
                child: RichText(
                    text: TextSpan(
              text: "Preço sugerido: " +
                  cPrecoSugerido.text,
              style: TextStyle(color: Colors.black, fontSize: 22),
              
            )))
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
      floatingActionButton: FloatingActionButton(
        child: FlatButton(
                child: Icon(Icons.skip_next), onPressed: proximoItem),
                onPressed: () {},
                ),
    );
  }
}
