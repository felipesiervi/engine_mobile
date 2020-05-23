import 'package:engine_mobile/views/compras/nota_detalhe.dart';
import 'package:engine_mobile/views/compras/nota_item_detalhe.dart';
import 'package:engine_mobile/views/compras/nota_lista.dart';
import 'package:engine_mobile/views/compras/pedido_detalhe.dart';
import 'package:engine_mobile/views/compras/pedido_item_comprar.dart';
import 'package:engine_mobile/views/compras/pedido_item_historico.dart';
import 'package:engine_mobile/views/compras/pedido_fornecedor_lista.dart';
import 'package:engine_mobile/views/compras/pedido_lista.dart';
import 'package:engine_mobile/views/compras/precificar_lote_lista.dart';
import 'package:engine_mobile/views/preferencias/preferencias.dart';
import 'package:flutter/material.dart';

import 'main_menu.dart';
import 'models/compras.dart';

class RouteGenerator {
  static Route<dynamic> gerenateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainMenu());
      case '/views/compras/nota_lista':
        return MaterialPageRoute(builder: (_) => NotaLista());
      case '/views/compras/nota_detalhe':
        return MaterialPageRoute(builder: (_) => NotaDetalhe(args));
      case '/views/compras/nota_item_detalhe':
        return MaterialPageRoute(builder: (_) => NotaItemDetalhe(
          (args as List<dynamic>)[0] as List<NotaItem>, 
          (args as List<dynamic>)[1] as int));
      case '/views/preferencias/preferencias':
        return MaterialPageRoute(builder: (_) => Preferencias());
      case '/views/compras/pedido_lista':
        return MaterialPageRoute(builder: (_) => PedidoLista());
      case '/views/compras/pedido_fornecedor_lista':
        return MaterialPageRoute(builder: (_) => PedidoFornecedorLista());
      case '/views/compras/pedido_detalhe':
        return MaterialPageRoute(builder: (_) => PedidoDetalhe(args as Fornecedor));
      case '/views/compras/pedido_item_historico':
        return MaterialPageRoute(builder: (_) => PedidoItemHist(args as NotaItem));
      case '/views/compras/pedido_item_comprar':
        return MaterialPageRoute(builder: (_) => PedidoItemComprar(args as NotaItem));
      case '/views/compras/precificar_lote_lista':
        return MaterialPageRoute(builder: (_) => PrecificarLoteLista());
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Center(
        child: Text("Error"),
      ),
    );
  });
}
