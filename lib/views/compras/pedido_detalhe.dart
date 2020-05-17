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
    await post('compras/post_pedido_remover_item', item, refresh);
  }

  void onTap(NotaItem item){
    Navigator.pushNamed(context, '/views/compras/pedido_item_historico', arguments: item).then((value) => refresh(null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: itens.length,
          itemBuilder: (BuildContext ctx, int index) {
            final item = itens[index];
            return Dismissible(
              child: Container(
                color: item.qtdcompra > 0 ? Colors.green.withOpacity(0.3) : Colors.white,
                child: ListTile(
                  onTap: () => onTap(item),
                  title: RichText(
                    text: TextSpan(
                      text: item.dsdetalhe + "\n",
                      style: TextStyle(color: Colors.black, fontSize: 22),
                      children: <TextSpan>[
                        TextSpan(
                            text: "Estoque: " + item.qtestoque.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        TextSpan(
                            text: " / Ajuste: " +
                                (item.ultajuste ?? ""),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        TextSpan(
                            text: " / Comprar: " +
                                (item.demanda.toStringAsFixed(0) ?? ""),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        TextSpan(
                            text: "\nPedido: " +
                                (item.qtdcompra.toString() ?? ""),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        TextSpan(
                            text: " / Valor: " +
                                (item.vlcompra.toStringAsFixed(2) ?? ""),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                      ],
              )))),
              direction: DismissDirection.endToStart,
              key: Key(item.iddetalhe),
              background: Container(color: Colors.green),
              secondaryBackground: Container(color: Colors.red),
              onDismissed: (direction) {
                if(direction == DismissDirection.endToStart)
                  removeItem(item);
              },
              
            );
          },
        ),
        bottomNavigationBar: 
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              text: 'Total do pedido: ' + itens.fold(0, (sum, element) => sum + (element.qtdcompra * element.vlcompra)).toStringAsFixed(2),
              style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
            )
          )
    );
  }
}
