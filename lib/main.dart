import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/item.dart';

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
        home: Home()
        // home: GridView.count(
        //     crossAxisCount: 4,
        //     childAspectRatio: 1.0,
        //     padding: const EdgeInsets.all(4.0),
        //     mainAxisSpacing: 4.0,
        //     crossAxisSpacing: 4.0,
        //     children: fetchApi().map((Pessoa pessoa) {
        //       return GridTile(child: Text(pessoa.nmpessoa));
        //     }).toList()
        // home: AppBar(title: Text("Sample AppBar"),
        // actions: <Widget>[
        //     Icon(Icons.comment),
        //     Icon(Icons.settings),
        //   ],
        //   ),)

        );
  }
}

class Home extends StatefulWidget {
  var pessoas = new List<Pessoa>();

  Home() {
    pessoas = [];
  }
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var newTaskCtrl = TextEditingController();

  // void add() {
  //   if (newTaskCtrl.text.isEmpty) return;
  //   setState(() {
  //     widget.items.add(
  //       Item(
  //         title: newTaskCtrl.text,
  //         done: false,
  //       ),
  //     );
  //     newTaskCtrl.text = "";
  //   });
  // }

  Future load() async {
    var pessoas = fetchApi();
  }

  Future fetchApi() async {
    http.Response response;
    try {
      response = await http.get('http://localhost:5000/compras/get_compras');
      Iterable decoded = jsonDecode(response.body);
      setState(() {
        widget.pessoas = decoded.map((x) => Pessoa.fromJson(x)).toList();
      });
    } catch (ex) {
      print(ex.toString());
    }
  }

  // void remove(int index) {
  //   setState(() {
  //     widget.items.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // load();
    fetchApi();
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
        itemCount: widget.pessoas.length,
        itemBuilder: (BuildContext ctx, int index) {
          final item = widget.pessoas[index];
          return ListTile(
            title: Text(item.nmpessoa + ' (' + item.vltotal.toString() + ')'),
            key: Key(item.nmpessoa),
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

class Pessoa {
  String nmpessoa;
  double vltotal;

  Pessoa({this.nmpessoa, this.vltotal});

  Pessoa.fromJson(Map json)
      : nmpessoa = json['nmpessoa'],
        vltotal = json['vltotal'] as double;

  Map toJson() {
    return {'nmpessoa': nmpessoa, 'vltotal': vltotal};
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
