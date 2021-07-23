// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'agent_model.g.dart';

@JsonSerializable()
class AgentModel {
  String? target;
  @JsonKey(name: 'target_propic')
  Uri? targetPropic;
  bool alive;
  int kills;

  AgentModel(
      {this.target,
      this.targetPropic,
      required this.alive,
      required this.kills});

  factory AgentModel.fromJson(Map<String, dynamic> json) =>
      _$AgentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgentModelToJson(this);
}
