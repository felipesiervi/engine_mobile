import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

class NotaLista extends StatefulWidget {
  @override
  _NotaListaState createState() => _NotaListaState();
}

class _NotaListaState extends State<NotaLista> {
  List<Fornecedor> fornecedores = new List<Fornecedor>();
  @override
  void initState() {
    super.initState();
    getPreferencias(call);
  }

  Future call() async {
    await get('compras/get_notas', load);
  }

  void load(decoded) {
    //print("dcpode:" + decoded);
    List<Fornecedor> list = new List<Fornecedor>();
    decoded.forEach((x) => list.add(Fornecedor.fromJson(x)));
    setState(() {
      fornecedores = list;
    });
  }

  void tapItem(String id) {
    Navigator.pushNamed(context, '/views/compras/nota_detalhe', arguments: id);
  }

  @override

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notas de Entrada",
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
          FlatButton(
            child: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/views/preferencias/preferencias');
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
                    text: "Emissão: ",
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
    );
  }
}
