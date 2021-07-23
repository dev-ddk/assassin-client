// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    email: json['email'] as String,
    username: json['username'] as String,
    propic: Uri.parse(json['propic'] as String),
    active: json['active'] as bool,
    currLobbyCode: json['currLobbyCode'] as String?,
    totalKills: json['totalKills'] as int,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'propic': instance.propic.toString(),
      'active': instance.active,
      'currLobbyCode': instance.currLobbyCode,
      'totalKills': instance.totalKills,
    };
