import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';
import 'package:intl/intl.dart';


class PedidoFornecedorLista extends StatefulWidget {
  @override
  _PedidoFornecedorListaState createState() => _PedidoFornecedorListaState();
}

class _PedidoFornecedorListaState extends State<PedidoFornecedorLista> {
  var cConsulta = TextEditingController();
  List<Fornecedor> fornecedores = new List<Fornecedor>();
  int esperar = 2;
  bool esperando = false;
  @override
  void initState() {
    super.initState();
    getPreferencias(call);
  }

  Future<void> consultaFornecedor(String txt) async {
    esperando = true;
    esperar = 2;
    while(esperar >= 0){
      await Future.delayed(Duration(seconds: 1));
      print('esperando');
      esperar -= 1;
    }

    if(esperando){
      esperando = false;
      call(nome:cConsulta.text);
      print('consulta');
    }
  }

  Future call({String nome=""}) async {
    await get('compras/get_fornecedores?nome='+nome, load);
  }

  void load(decoded) {
    List<Fornecedor> list = new List<Fornecedor>();
    decoded.forEach((x) => list.add(Fornecedor.fromJson(x)));
    setState(() {
      fornecedores = list;
    });
  }

  void tapItem(Fornecedor obj) {
    obj.strdata = DateFormat('yyyy_MM_dd_kk_mm').format(DateTime.now());
    post('compras/post_criar_pedido', obj, goback);
  }

  void goback(txt) {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextFormField(
            controller: cConsulta,
            // onEditingComplete: calcularRateio,
            onChanged: consultaFornecedor,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            decoration: InputDecoration(
                labelText: "Consultar",
                labelStyle: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
      body: ListView.builder(
        itemCount: fornecedores.length,
        itemBuilder: (BuildContext ctx, int index) {
          final item = fornecedores[index];
          return ListTile(
            onTap: () => tapItem(item),
            title: RichText(
                text: TextSpan(
              text: item.nmpessoa,
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
            key: Key(item.iddocumento),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: FlatButton(
                child: Icon(Icons.add), onPressed: (){})),
    );
  }
}
