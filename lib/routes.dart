import 'package:engine_mobile/views/compras/nota_detalhe.dart';
import 'package:engine_mobile/views/compras/nota_item_detalhe.dart';
import 'package:engine_mobile/views/compras/nota_lista.dart';
import 'package:engine_mobile/views/preferencias/preferencias.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> gerenateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => NotaLista());
      case '/views/compras/nota_detalhe':
        return MaterialPageRoute(builder: (_) => NotaDetalhe(args));
      case '/views/compras/nota_item_detalhe':
        return MaterialPageRoute(builder: (_) => NotaItemDetalhe(args));
      case '/views/preferencias/preferencias':
        return MaterialPageRoute(builder: (_) => Preferencias());
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
