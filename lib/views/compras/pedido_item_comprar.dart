import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

class PedidoItemComprar extends StatefulWidget {
  final NotaItem item;

  PedidoItemComprar(this.item);

  @override
  _PedidoItemComprar createState() => _PedidoItemComprar(item);
}

class _PedidoItemComprar extends State<PedidoItemComprar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NotaItem item;

  TextEditingController cCusto = TextEditingController();
  TextEditingController cQtde = TextEditingController();
  double custo = 0;
  int qtde = 0;

  _PedidoItemComprar(this.item) {
    cCusto.text = item.vlcusto.toStringAsFixed(2);
    custo = double.parse(cCusto.text);
    qtde = 0;
    cQtde.text = qtde.toString();
  }

  void ajustaCusto(double vl) {
    custo = max(custo + vl, 0);

    setState(() {
      cCusto.text = custo.toStringAsFixed(2);
    });
  }

  void ajustaQtde(int vl) {
    qtde = max(qtde + vl, 0);

    setState(() {
      cQtde.text = qtde.toString();
    });
  }

  Future call() async {
    item.qtdcompra = qtde;
    item.vlcompra = custo;
    await post('compras/post_pedido_atualizar_item', item, goback);
  }

  void goback(txt) {
    Navigator.pop(context, true);
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
          ListTile(
            title: TextFormField(
                textAlign: TextAlign.center,
                controller: cCusto,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              decoration: InputDecoration(labelText: 'Valor Custo'),
              ),
          ),
          ListTile(
            title: Row(
              children: <Widget>[ 
                Expanded(flex: 2, child: FlatButton(child: Text('-1,00'), onPressed: () => ajustaCusto(-1))),
                Expanded(flex: 2, child: FlatButton(child: Text('-0,10'), onPressed: () => ajustaCusto(-0.1))),
                Expanded(flex: 2, child: FlatButton(child: Text('-0,01'), onPressed: () => ajustaCusto(-0.01))),
                Expanded(flex: 2, child: FlatButton(child: Text('+0,01'), onPressed: () => ajustaCusto(0.01))),
                Expanded(flex: 2, child: FlatButton(child: Text('+0,10'), onPressed: () => ajustaCusto(0.1))),
                Expanded(flex: 2, child: FlatButton(child: Text('+1,00'), onPressed: () => ajustaCusto(1))),
            ],
            )
          ),
          // Preço final
          ListTile(
            title: TextFormField(
              textAlign: TextAlign.center,
              controller: cQtde,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              decoration: InputDecoration(labelText: 'Quantidade'),
            ),
          ),
                    ListTile(
            title: Row(
              children: <Widget>[ 
                Expanded(flex: 2, child: FlatButton(child: Text('-10'), onPressed: () => ajustaQtde(-10))),
                Expanded(flex: 2, child: FlatButton(child: Text('-1'), onPressed: () => ajustaQtde(-1))),
                Expanded(flex: 2, child: FlatButton(child: Text('+1'), onPressed: () => ajustaQtde(1))),
                Expanded(flex: 2, child: FlatButton(child: Text('+10'), onPressed: () => ajustaQtde(10))),
            ],
            )
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
              onPressed: call,
              color: Colors.green,
            )),
          ),
        ],
      ),
    );
  }
}
