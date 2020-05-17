import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

// void main() => runApp(EngineMobile());

class PedidoItemHist extends StatefulWidget {
  final NotaItem item;

  PedidoItemHist(this.item);

  @override
  _PedidoDetalheHist createState() => _PedidoDetalheHist(this.item);
}

class _PedidoDetalheHist extends State<PedidoItemHist> {
  static NotaItem item;
  List<DataRow> historico = List<DataRow>();

  _PedidoDetalheHist(item) {
    _PedidoDetalheHist.item = item;
    call(_PedidoDetalheHist.item);
  }

  Future call(NotaItem item) async {
    await get('compras/get_pedido_item_hist?id=' + item.iddetalhe, load);
  }

  void load(decoded) {
    List<PedidoDetalheHistDTO> list = List<PedidoDetalheHistDTO>();
    List<DataRow> listDataRow = List<DataRow>();
    decoded.forEach((x) => list.add(PedidoDetalheHistDTO.fromJson(x)));
    
    list.forEach((row) {
      listDataRow.add(DataRow(cells: <DataCell>[
        DataCell(Text(row.nomePessoa)),
        DataCell(Text(row.emissao)),
        DataCell(Text(row.valorCusto.toStringAsFixed(2))),
      ]));
    });

    if(list.length > 0)
      item.vlcusto = list[0].valorCusto;
    
    setState(() {
      historico = listDataRow;
    });
  }

    Future removeItem() async {
    await post('compras/post_pedido_remover_item', item, goback);
    await post('compras/post_produto_inativar', item, (){});
  }

  void goback(txt) {
    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: Text(
          item.dsdetalhe,
          style: TextStyle(fontSize: 20),
        ),
        actions:  <Widget>[
          DropdownButton<String>(
            items: <String>['Inativar produto'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (op) {
              removeItem();
            },
            icon: Icon(Icons.menu,color: Colors.white),
          )
        ],
      ),
      body: DataTable(
    columns: const <DataColumn>[
      DataColumn(
        label: Text(
          'Fornecedor',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Data',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Custo',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ],
    rows: historico
    ),
     floatingActionButton: FloatingActionButton(
        child: FlatButton(
                child: Icon(Icons.add_shopping_cart), onPressed: (){ 
                  Navigator.pushNamed(context, '/views/compras/pedido_item_comprar', arguments: item).then((value) => goback(null));
                }),
                onPressed: () {},),
  
  );
  }
}
