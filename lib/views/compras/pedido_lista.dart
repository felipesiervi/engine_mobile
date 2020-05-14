import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

class PedidoLista extends StatefulWidget {
  @override
  _PedidoListaState createState() => _PedidoListaState();
}

class _PedidoListaState extends State<PedidoLista> {
  List<Fornecedor> fornecedores = new List<Fornecedor>();
  @override
  void initState() {
    super.initState();
    getPreferencias(call);
  }

  Future call() async {
    await get('compras/get_pedidos', load);
  }

  void load(decoded) {
    List<Fornecedor> list = new List<Fornecedor>();
    decoded.forEach((x) => list.add(Fornecedor.fromJson(x)));
    setState(() {
      fornecedores = list;
    });
  }

  void tapItem(String id) {
    Navigator.pushNamed(context, '/views/compras/nota_detalhe', arguments: id);
  }

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pedidos de Compra",
          style: TextStyle(fontSize: 22),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              call();
            },
            textColor: Colors.white,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: fornecedores.length,
        itemBuilder: (BuildContext ctx, int index) {
          final item = fornecedores[index];
          return ListTile(
            onTap: () => tapItem(item.iddocumento),
            title: RichText(
                text: TextSpan(
              text: item.nmpessoa + "\n",
              style: TextStyle(color: Colors.black, fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                    text: "data: ",
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
      floatingActionButton: FloatingActionButton(
        child: FlatButton(
                child: Icon(Icons.add), onPressed: (){ Navigator.pushNamed(context, '/views/compras/pedido_fornecedor_lista'); })),
    );
  }
}
