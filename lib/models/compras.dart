import 'package:json_annotation/json_annotation.dart';

part 'compras.g.dart';

class Fornecedor {
  String nmpessoa;
  String idpessoa;
  String iddocumento;
  DateTime dtemissao;
  String strdata;
  String arquivo;
  double vltotal;

  Fornecedor({this.nmpessoa, this.vltotal, this.iddocumento, this.dtemissao, this.arquivo});

  Fornecedor.fromJson(Map<String, dynamic> json) {
    idpessoa = json['idpessoa'] ?? "";
    arquivo = json['arquivo'] ?? "";
    nmpessoa = json['nmpessoa'] ?? "";
    strdata = json['strdata'] ?? "";
    vltotal = json['vltotal'] as double ?? 0;
    iddocumento = json['iddocumento'] ?? "";
    dtemissao =
        DateTime.fromMillisecondsSinceEpoch(json['dtemissao'] as int ?? 0);
  }

  Map toJson() {
    return {'nmpessoa': nmpessoa, 'vltotal': vltotal, 'idpessoa': idpessoa, 'strdata': strdata, 'arquivo': arquivo};
  }
}

@JsonSerializable()
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
  double demanda;
  double qtestoque;
  String ultajuste;
  String arquivo;
  double vlcompra;
  int qtdcompra;

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
      this.vlunitario,
      this.demanda,
      this.qtestoque,
      this.ultajuste});

  NotaItem.fromJson(Map<String, dynamic> json) {
    iddocumentoitem = json['iddocumentoitem'];
    dsdetalhe = json['dsdetalhe'];
    iddetalhe = json['iddetalhe'];
    qtitem = json['qtitem'] as int ?? 0;
    vlsubst = json['vlsubst'] as double ?? 0;
    vlunitario = json['vlunitario'] as double ?? 0;
    vlipi = json['vlipi'] as double ?? 0;
    allucrodesejada = json['allucrodesejada'] as double ?? 0;
    vlprecoprazo = json['vlprecoprazo'] as double ?? 0;
    vlprecovista = json['vlprecovista'] as double ?? 0;
    vlfreterateado = json['vlfreterateado'] as double ?? 0;
    vlrateio = json['vlrateio'] as double ?? 0;
    demanda = json['demanda'] as double ?? 0;
    ultajuste = json['ultajuste'];
    arquivo = json['arquivo'];
    qtestoque = json['qtestoque'] as double ?? 0;
    vlcompra = json['vlcompra']?.toDouble() ?? 0;
    qtdcompra = json['qtdcompra'] as int ?? 0;
    vlcusto = vlsubst + vlipi + vlunitario;
  }

    Map toJson() {
    return {'iddetalhe': iddetalhe, 'dsdetalhe': dsdetalhe, 'arquivo': arquivo, 'qtdcompra': qtdcompra, 'vlcompra': vlcompra};
  }
}

@JsonSerializable()
class PedidoDetalheHistDTO {
  String nomePessoa;
  String nomeProduto;
  String id;
  double valorCusto;
  String emissao;

  PedidoDetalheHistDTO(this.nomePessoa, this.nomeProduto, this.id, this.valorCusto, this.emissao);
  factory PedidoDetalheHistDTO.fromJson(Map<String, dynamic> json) => _$PedidoDetalheHistDTOFromJson(json);
  Map<String, dynamic> toJson() => _$PedidoDetalheHistDTOToJson(this);
}

