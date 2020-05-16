import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

// void main() => runApp(EngineMobile());

class PedidoDetalhe extends StatefulWidget {
  final Fornecedor fornecedor;

  PedidoDetalhe(this.fornecedor);

  @override
  _PedidoDetalhe createState() => _PedidoDetalhe(this.fornecedor);
}

class _PedidoDetalhe extends State<PedidoDetalhe> {
  List<NotaItem> itens = new List<NotaItem>();
  var cValorRateio = TextEditingController();
  static Fornecedor fornecedor;
  static DismissDirection directionVar;

  _PedidoDetalhe(fornecedor) {
    _PedidoDetalhe.fornecedor = fornecedor;
    call(_PedidoDetalhe.fornecedor);
  }

  Future call(fornec) async {
    await get('compras/get_pedido_itens?arquivo=' + fornec.arquivo, load);
  }
  Future refresh(fornec) async {
    await get('compras/get_pedido_itens?arquivo=' + _PedidoDetalhe.fornecedor.arquivo, load);
  }

  void load(decoded) {
    List<NotaItem> list = new List<NotaItem>();
    decoded.forEach((x) => list.add(NotaItem.fromJson(x)));
    setState(() {
      itens = list;
    });
  }

  Future removeItem(NotaItem item) async {
    item.arquivo = fornecedor.arquivo;
    await post('compras/post_pedido_remover_item', item, refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: itens.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = itens[index];
            return Dismissible(
              // onDismissed: () => tapItem(index),
              child: RichText(
                  text: TextSpan(
                text: item.dsdetalhe + "\n",
                style: TextStyle(color: Colors.black, fontSize: 22),
                children: <TextSpan>[
                  TextSpan(
                      text: "Qtde Atual: " + item.qtestoque.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: " / Último Ajuste: " +
                          (item.ultajuste ?? ""),
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                ],
              )),
              key: Key(item.iddetalhe),
              background: Container(color: Colors.green),
              secondaryBackground: Container(color: Colors.red),
              onDismissed: (direction) {
                if(direction == DismissDirection.endToStart)
                  removeItem(item);
              },
            );
          },
        ));
  }
}
