class Fornecedor {
  String nmpessoa;
  String iddocumento;
  DateTime dtemissao;
  double vltotal;

  Fornecedor({this.nmpessoa, this.vltotal, this.iddocumento, this.dtemissao});

  Fornecedor.fromJson(Map json)
      : nmpessoa = json['nmpessoa'],
        vltotal = json['vltotal'] as double,
        iddocumento = json['iddocumento'],
        dtemissao =
            DateTime.fromMillisecondsSinceEpoch(json['dtemissao'] as int);

  Map toJson() {
    return {'nmpessoa': nmpessoa, 'vltotal': vltotal};
  }
}

class NotaItem {
  String iddocumentoitem;
  String dsdetalhe;
  String iddetalhe;
  int qtitem;
  double vlsubst;
  double vlunitario;
  double vlipi;

  NotaItem(
      {this.iddocumentoitem,
      this.dsdetalhe,
      this.iddetalhe,
      this.qtitem,
      this.vlsubst,
      this.vlipi,
      this.vlunitario});

  NotaItem.fromJson(Map<String, dynamic> json) {
    iddocumentoitem = json['iddocumentoitem'];
    dsdetalhe = json['dsdetalhe'];
    iddetalhe = json['iddetalhe'];
    qtitem = json['qtitem'] as int;
    vlsubst = json['vlsubst'] as double;
    vlunitario = json['vlunitario'] as double;
    vlipi = json['vlipi'] as double;
  }
}
