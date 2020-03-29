import 'dart:convert';
import 'package:engine_mobile/views/compras/nota_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/compras.dart';

void main() => runApp(EngineMobile());

class EngineMobile extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Home(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Home(),
        '/views/compras/nota_detalhe': (BuildContext context) =>
            NotaDetalhe(_HomeState.idNota)
      },
    );
  }
}

class Home extends StatefulWidget {
  var fornecedores = new List<Fornecedor>();

  Home() {
    fornecedores = [];
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var newTaskCtrl = TextEditingController();
  static String idNota;

  _HomeState() {
    load();
  }
  Future load() async {
    http.Response response;
    try {
      response = await http.get('http://localhost:5000/compras/get_notas');
      Iterable decoded = jsonDecode(response.body);
      setState(() {
        widget.fornecedores =
            decoded.map((x) => Fornecedor.fromJson(x)).toList();
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  void tap_item(String id) {
    _HomeState.idNota = id;
    Navigator.pushNamed(context, '/views/compras/nota_detalhe');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          decoration: InputDecoration(
              labelText: "Título",
              labelStyle: TextStyle(
                color: Colors.white,
              )),
        ),
        actions: <Widget>[
          Icon(Icons.menu),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.fornecedores.length,
        itemBuilder: (BuildContext ctx, int index) {
          final item = widget.fornecedores[index];
          return ListTile(
            onTap: () => tap_item(item.iddocumento),
            title: RichText(
                text: TextSpan(
              text: item.nmpessoa + "\n",
              style: TextStyle(color: Colors.black, fontSize: 22),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
