// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'game_stats_model.g.dart';

@JsonSerializable(explicitToJson: true)
class GameStatsModel {
  UserStatsModel winner;
  List<UserStatsModel> ranking;

  GameStatsModel(this.winner, this.ranking);

  factory GameStatsModel.fromJson(Map<String, dynamic> json) =>
      _$GameStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameStatsModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserStatsModel {
  String username;
  String codename;
  String propic;
  int kills;
  int deaths;
  int score;

  UserStatsModel(
    this.username,
    this.codename,
    this.propic,
    this.kills,
    this.deaths,
    this.score,
  );

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);
}
