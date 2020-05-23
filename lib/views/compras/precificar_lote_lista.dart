import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';


class PrecificarLoteLista extends StatefulWidget {
  @override
  _PrecificarLoteListaState createState() => _PrecificarLoteListaState();
}

class _PrecificarLoteListaState extends State<PrecificarLoteLista> {
  var cConsulta = TextEditingController();
  List<NotaItem> itens = new List<NotaItem>();
  String _item = '';
  int esperar = 2;
  bool esperando = false;

  void initState() {
    super.initState();
    getPreferencias(null);
  }

  Future<void> consulta(String txt) async {
    esperando = true;
    esperar = 2;
    while(esperar >= 0){
      await Future.delayed(Duration(seconds: 1));
      esperar -= 1;
    }

    if(esperando){
      esperando = false;
      call(nome:cConsulta.text);
    }
  }

  Future call({String nome=""}) async {
    await get('compras/get_preco_lote?lista='+nome, load);
  }

  void load(decoded) {
    List<NotaItem> list = new List<NotaItem>();
    decoded.forEach((x) => list.add(NotaItem.fromJson(x)));
    setState(() {
      itens = list;
    });
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
            onChanged: consulta,
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
        itemCount: itens.length,
        itemBuilder: (BuildContext ctx, int index) {
          var item = itens[index];
          return RadioListTile(
            value: item.iddetalhe,
            groupValue: _item,
            onChanged: (String i) { 
              setState(() {
                _item = i;
              });
            },
            secondary: Checkbox(
              onChanged: (bool i) {
                setState(() {
                  item.qtestoque = i ? 1 : 0;
                });
              }, 
              value: item.qtestoque == 1,),
            title: RichText(
                text: TextSpan(
              text: item.dsdetalhe,
              style: TextStyle(color: Colors.black, fontSize: 20),
             children: <TextSpan>[
                        TextSpan(
                            text: "\nA Vista: " + item.vlprecovista.toStringAsFixed(2),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        TextSpan(
                            text: " / A Prazo: " + item.vlprecoprazo.toStringAsFixed(2),
                            style: TextStyle(color: Colors.black, fontSize: 16)),
                        ])),
          );
        },
      ),
    );
  }
}
