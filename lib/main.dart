import 'package:engine_mobile/routes.dart';
import 'package:engine_mobile/util.dart';
import 'package:flutter/material.dart';

void main() => runApp(EngineMobile());

class EngineMobile extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Home(),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.gerenateRoute,
    );
  }
}
