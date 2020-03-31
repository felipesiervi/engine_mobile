import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> params = {};

Future getPreferencias() async {
  var prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> ret = {};
  ret['ServidorAPI'] = prefs.getString('ServidorAPI');
  params = ret;
}

Future atualizaPreferencia(chave, valor) async {
  var prefs = await SharedPreferences.getInstance();
  params[chave] = valor;
  await prefs.setString(chave, valor);
}

Future<Iterable> get(url) async {
  http.Response response;
  try {
    print(params['ServidorAPI']);
    response = await http.get('http://' + params['ServidorAPI'] + '/' + url);
    Iterable decoded = jsonDecode(response.body);
    return decoded;
  } catch (ex) {
    print(ex.toString());
  }
  print('null');
  return null;
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
