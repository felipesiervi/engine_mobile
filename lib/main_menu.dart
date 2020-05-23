
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
      MenuItem('Precificação Notas', Icon(Icons.attach_money, size: 50, color: Colors.blue,),'/views/compras/nota_lista'),
      MenuItem('Precificação em Lote', Icon(Icons.attach_money, size: 50, color: Colors.blue,),'/views/compras/precificar_lote_lista'),
      MenuItem('Compras', Icon(Icons.shopping_cart, size: 50, color: Colors.blue,),'/views/compras/pedido_lista'),
    ];
  }

  void tapItem(int id) {
    Navigator.pushNamed(context, menu[id].rota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: 
      
      GridView.builder(
        itemCount: menu.length,
        itemBuilder: (BuildContext ctx, int index) {
          final item = menu[index];
          return ListTile(
            onTap: () => tapItem(index),
            title: item.icone,
            subtitle: RichText(
              textAlign: TextAlign.center,
                text: TextSpan(
                  text: item.nome,
                  style: TextStyle(color: Colors.black, fontSize: 20),
            )),
            key: Key(item.nome),
          );
        }, gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.0,
        ),
      ),
    );
  }
}

class MenuItem {
  String nome;
  Icon icone;
  String rota;

  MenuItem(this.nome, this.icone, this.rota);
}