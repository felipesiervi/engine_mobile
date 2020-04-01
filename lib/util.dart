import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> params = {};

Future getPreferencias(func) async {
  var prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> ret = {};
  ret['ServidorAPI'] = prefs.getString('ServidorAPI');
  params = ret;
  func();
}

Future atualizaPreferencia(chave, valor) async {
  var prefs = await SharedPreferences.getInstance();
  params[chave] = valor;
  await prefs.setString(chave, valor);
}

Future get(url, func) async {
  http.Response response;
  try {
    print(params['ServidorAPI']);
    response = await http.get('http://' + params['ServidorAPI'] + '/' + url);
    var decoded = jsonDecode(response.body);
    func(decoded);
  } catch (ex) {
    print(ex.toString());
  }
}

Future post(url, obj) async {
  print(params);
  try {
    url = 'http://' + params['ServidorAPI'] + '/' + url;
    var body = json.encode(obj);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    print(url);
    final response = await http.post(url, body: body, headers: headers);
    final responseJson = json.decode(response.body);
    print(5);
    print(responseJson);
  } catch (ex) {
    print(ex.toString());
  }
}
