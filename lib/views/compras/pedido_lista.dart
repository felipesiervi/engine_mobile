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

  void tapItem(Fornecedor fornec) {
    Navigator.pushNamed(context, '/views/compras/pedido_detalhe', arguments: fornec);
  }

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
            onTap: () => tapItem(item),
            title: RichText(
                text: TextSpan(
              text: item.nmpessoa.replaceAll('-', ' ') + "\n",
              style: TextStyle(color: Colors.black, fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                    text: "data: ",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                TextSpan(
                    text: item.strdata,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),

              ],
            )),
            key: Key(item.iddocumento),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: FlatButton(
                child: Icon(Icons.add), onPressed: (){ Navigator.pushNamed(context, '/views/compras/pedido_fornecedor_lista').then((value) => call()); }),
                onPressed: () {},),
                
    );
  }
}
