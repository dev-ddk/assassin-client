// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentModel _$AgentModelFromJson(Map<String, dynamic> json) {
  return AgentModel(
    codename: json['codename'] as String,
    target: json['target'] as String?,
    targetPropic: json['target_propic'] == null
        ? null
        : Uri.parse(json['target_propic'] as String),
    alive: json['alive'] as bool,
    kills: json['kills'] as int,
  );
}

Map<String, dynamic> _$AgentModelToJson(AgentModel instance) =>
    <String, dynamic>{
      'codename': instance.codename,
      'target': instance.target,
      'target_propic': instance.targetPropic?.toString(),
      'alive': instance.alive,
      'kills': instance.kills,
    };
