import 'package:flutter/material.dart';
import '../../models/compras.dart';
import '../../util.dart';

// void main() => runApp(EngineMobile());

class PedidoDetalheHist extends StatefulWidget {
  final NotaItem item;

  PedidoDetalheHist(this.item);

  @override
  _PedidoDetalheHist createState() => _PedidoDetalheHist(this.item);
}

class _PedidoDetalheHist extends State<PedidoDetalheHist> {
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
    List<DataRow> list = List<DataRow>();
    
    decoded.forEach((x) {
      var row = PedidoDetalheHistDTO.fromJson(x);
      list.add(DataRow(cells: <DataCell>[
        DataCell(Text(row.nomePessoa)),
        DataCell(Text(row.emissao)),
        DataCell(Text(row.valorCusto.toStringAsFixed(2))),
      ]));
    });
    
    setState(() {
      historico = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.dsdetalhe,
          style: TextStyle(fontSize: 22),
        ),
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
    )
  );
  }
}
