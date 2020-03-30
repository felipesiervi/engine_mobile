import 'package:engine_mobile/views/compras/nota_detalhe.dart';
import 'package:engine_mobile/views/compras/nota_item_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:engine_mobile/main.dart';

class RouteGenerator {
  static Route<dynamic> gerenateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/views/compras/nota_detalhe':
        return MaterialPageRoute(builder: (_) => NotaDetalhe(args));
      case '/views/compras/nota_item_detalhe':
        return MaterialPageRoute(builder: (_) => NotaItemDetalhe(args));
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
