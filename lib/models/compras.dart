class Fornecedor {
  String nmpessoa;
  String iddocumento;
  DateTime dtemissao;
  double vltotal;

  Fornecedor({this.nmpessoa, this.vltotal, this.iddocumento, this.dtemissao});

  Fornecedor.fromJson(Map<String, dynamic> json) {
    nmpessoa = json['nmpessoa'] ?? "";
    vltotal = json['vltotal'] as double ?? 0;
    iddocumento = json['iddocumento'] ?? "";
    dtemissao =
        DateTime.fromMillisecondsSinceEpoch(json['dtemissao'] as int ?? 0);
  }

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
  double allucrodesejada;
  double vlprecoprazo;
  double vlprecovista;
  double vlfreterateado;
  double vlrateio;
  double vlcusto;

  NotaItem(
      {this.iddocumentoitem,
      this.dsdetalhe,
      this.iddetalhe,
      this.qtitem,
      this.vlsubst,
      this.vlipi,
      this.allucrodesejada,
      this.vlprecoprazo,
      this.vlprecovista,
      this.vlfreterateado,
      this.vlrateio,
      this.vlcusto,
      this.vlunitario});

  NotaItem.fromJson(Map<String, dynamic> json) {
    iddocumentoitem = json['iddocumentoitem'];
    dsdetalhe = json['dsdetalhe'];
    iddetalhe = json['iddetalhe'];
    qtitem = json['qtitem'] as int;
    vlsubst = json['vlsubst'] as double;
    vlunitario = json['vlunitario'] as double;
    vlipi = json['vlipi'] as double;
    allucrodesejada = json['allucrodesejada'] as double;
    vlprecoprazo = json['vlprecoprazo'] as double;
    vlprecovista = json['vlprecovista'] as double;
    vlfreterateado = json['vlfreterateado'] as double;
    vlrateio = json['vlrateio'] as double;
    vlcusto = vlsubst + vlipi + vlunitario;
  }
}
