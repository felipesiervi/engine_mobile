class Item {
  String title;
  bool done;

  Item({this.title, this.done});

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  List<Item> fromJsonList(List<Map<String, dynamic>> json) {
    List<Item> items = [];
    for (var j in json) {
      var item = Item(title: j['title'], done: j['done']);
      items.add(item);
    }
    return items;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}
