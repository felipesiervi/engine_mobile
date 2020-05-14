
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<MenuItem> menu;
  
  @override
  void initState() {
    super.initState();
    menu = [
      MenuItem('Precificação', '/views/compras/nota_lista'),
      MenuItem('Compras', '/views/compras/pedido_lista'),
    ];
  }

  void tapItem(int id) {
    Navigator.pushNamed(context, menu[id].rota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: 
      
      ListView.builder(
        itemCount: 2,
        
        itemBuilder: (BuildContext ctx, int index) {
          final item = menu[index];
          return ListTile(
            onTap: () => tapItem(index),
            title: RichText(
                text: TextSpan(
              text: item.nome,
              style: TextStyle(color: Colors.black, fontSize: 20),
            )),
            key: Key(item.nome),
          );
        },
      ),
    );
  }
}

class MenuItem {
  String nome;
  String rota;

  MenuItem(this.nome, this.rota);
}