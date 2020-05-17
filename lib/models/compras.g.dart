// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compras.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedidoDetalheHistDTO _$PedidoDetalheHistDTOFromJson(Map<String, dynamic> json) {
  return PedidoDetalheHistDTO(
    json['nomePessoa'] as String,
    json['nomeProduto'] as String,
    json['id'] as String,
    (json['valorCusto'] as num)?.toDouble(),
    json['emissao'] as String,
  );
}

Map<String, dynamic> _$PedidoDetalheHistDTOToJson(
        PedidoDetalheHistDTO instance) =>
    <String, dynamic>{
      'nomePessoa': instance.nomePessoa,
      'nomeProduto': instance.nomeProduto,
      'id': instance.id,
      'valorCusto': instance.valorCusto,
      'emissao': instance.emissao,
    };
