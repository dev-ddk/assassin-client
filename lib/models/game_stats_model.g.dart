// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStatsModel _$GameStatsModelFromJson(Map<String, dynamic> json) =>
    GameStatsModel(
      UserStatsModel.fromJson(json['winner'] as Map<String, dynamic>),
      (json['ranking'] as List<dynamic>)
          .map((e) => UserStatsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GameStatsModelToJson(GameStatsModel instance) =>
    <String, dynamic>{
      'winner': instance.winner.toJson(),
      'ranking': instance.ranking.map((e) => e.toJson()).toList(),
    };

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      json['username'] as String,
      json['codename'] as String,
      json['propic'] as String,
      json['kills'] as int,
      json['deaths'] as int,
      json['score'] as int,
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'codename': instance.codename,
      'propic': instance.propic,
      'kills': instance.kills,
      'deaths': instance.deaths,
      'score': instance.score,
    };
