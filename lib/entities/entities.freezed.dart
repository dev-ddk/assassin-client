// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$UserEntityTearOff {
  const _$UserEntityTearOff();

  _UserEntity call(
      {required String email,
      required String username,
      Uri? propic,
      String? currGameCode,
      required int totalKills}) {
    return _UserEntity(
      email: email,
      username: username,
      propic: propic,
      currGameCode: currGameCode,
      totalKills: totalKills,
    );
  }
}

/// @nodoc
const $UserEntity = _$UserEntityTearOff();

/// @nodoc
mixin _$UserEntity {
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  Uri? get propic => throw _privateConstructorUsedError;
  String? get currGameCode => throw _privateConstructorUsedError;
  int get totalKills => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserEntityCopyWith<UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserEntityCopyWith<$Res> {
  factory $UserEntityCopyWith(
          UserEntity value, $Res Function(UserEntity) then) =
      _$UserEntityCopyWithImpl<$Res>;
  $Res call(
      {String email,
      String username,
      Uri? propic,
      String? currGameCode,
      int totalKills});
}

/// @nodoc
class _$UserEntityCopyWithImpl<$Res> implements $UserEntityCopyWith<$Res> {
  _$UserEntityCopyWithImpl(this._value, this._then);

  final UserEntity _value;
  // ignore: unused_field
  final $Res Function(UserEntity) _then;

  @override
  $Res call({
    Object? email = freezed,
    Object? username = freezed,
    Object? propic = freezed,
    Object? currGameCode = freezed,
    Object? totalKills = freezed,
  }) {
    return _then(_value.copyWith(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      propic: propic == freezed
          ? _value.propic
          : propic // ignore: cast_nullable_to_non_nullable
              as Uri?,
      currGameCode: currGameCode == freezed
          ? _value.currGameCode
          : currGameCode // ignore: cast_nullable_to_non_nullable
              as String?,
      totalKills: totalKills == freezed
          ? _value.totalKills
          : totalKills // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$UserEntityCopyWith<$Res> implements $UserEntityCopyWith<$Res> {
  factory _$UserEntityCopyWith(
          _UserEntity value, $Res Function(_UserEntity) then) =
      __$UserEntityCopyWithImpl<$Res>;
  @override
  $Res call(
      {String email,
      String username,
      Uri? propic,
      String? currGameCode,
      int totalKills});
}

/// @nodoc
class __$UserEntityCopyWithImpl<$Res> extends _$UserEntityCopyWithImpl<$Res>
    implements _$UserEntityCopyWith<$Res> {
  __$UserEntityCopyWithImpl(
      _UserEntity _value, $Res Function(_UserEntity) _then)
      : super(_value, (v) => _then(v as _UserEntity));

  @override
  _UserEntity get _value => super._value as _UserEntity;

  @override
  $Res call({
    Object? email = freezed,
    Object? username = freezed,
    Object? propic = freezed,
    Object? currGameCode = freezed,
    Object? totalKills = freezed,
  }) {
    return _then(_UserEntity(
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      propic: propic == freezed
          ? _value.propic
          : propic // ignore: cast_nullable_to_non_nullable
              as Uri?,
      currGameCode: currGameCode == freezed
          ? _value.currGameCode
          : currGameCode // ignore: cast_nullable_to_non_nullable
              as String?,
      totalKills: totalKills == freezed
          ? _value.totalKills
          : totalKills // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_UserEntity extends _UserEntity {
  _$_UserEntity(
      {required this.email,
      required this.username,
      this.propic,
      this.currGameCode,
      required this.totalKills})
      : super._();

  @override
  final String email;
  @override
  final String username;
  @override
  final Uri? propic;
  @override
  final String? currGameCode;
  @override
  final int totalKills;

  @override
  String toString() {
    return 'UserEntity(email: $email, username: $username, propic: $propic, currGameCode: $currGameCode, totalKills: $totalKills)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserEntity &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.propic, propic) ||
                const DeepCollectionEquality().equals(other.propic, propic)) &&
            (identical(other.currGameCode, currGameCode) ||
                const DeepCollectionEquality()
                    .equals(other.currGameCode, currGameCode)) &&
            (identical(other.totalKills, totalKills) ||
                const DeepCollectionEquality()
                    .equals(other.totalKills, totalKills)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(propic) ^
      const DeepCollectionEquality().hash(currGameCode) ^
      const DeepCollectionEquality().hash(totalKills);

  @JsonKey(ignore: true)
  @override
  _$UserEntityCopyWith<_UserEntity> get copyWith =>
      __$UserEntityCopyWithImpl<_UserEntity>(this, _$identity);
}

abstract class _UserEntity extends UserEntity {
  factory _UserEntity(
      {required String email,
      required String username,
      Uri? propic,
      String? currGameCode,
      required int totalKills}) = _$_UserEntity;
  _UserEntity._() : super._();

  @override
  String get email => throw _privateConstructorUsedError;
  @override
  String get username => throw _privateConstructorUsedError;
  @override
  Uri? get propic => throw _privateConstructorUsedError;
  @override
  String? get currGameCode => throw _privateConstructorUsedError;
  @override
  int get totalKills => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserEntityCopyWith<_UserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$OtherUserEntityTearOff {
  const _$OtherUserEntityTearOff();

  _OtherUserEntity call({required String username, Uri? propic}) {
    return _OtherUserEntity(
      username: username,
      propic: propic,
    );
  }
}

/// @nodoc
const $OtherUserEntity = _$OtherUserEntityTearOff();

/// @nodoc
mixin _$OtherUserEntity {
  String get username => throw _privateConstructorUsedError;
  Uri? get propic => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OtherUserEntityCopyWith<OtherUserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtherUserEntityCopyWith<$Res> {
  factory $OtherUserEntityCopyWith(
          OtherUserEntity value, $Res Function(OtherUserEntity) then) =
      _$OtherUserEntityCopyWithImpl<$Res>;
  $Res call({String username, Uri? propic});
}

/// @nodoc
class _$OtherUserEntityCopyWithImpl<$Res>
    implements $OtherUserEntityCopyWith<$Res> {
  _$OtherUserEntityCopyWithImpl(this._value, this._then);

  final OtherUserEntity _value;
  // ignore: unused_field
  final $Res Function(OtherUserEntity) _then;

  @override
  $Res call({
    Object? username = freezed,
    Object? propic = freezed,
  }) {
    return _then(_value.copyWith(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      propic: propic == freezed
          ? _value.propic
          : propic // ignore: cast_nullable_to_non_nullable
              as Uri?,
    ));
  }
}

/// @nodoc
abstract class _$OtherUserEntityCopyWith<$Res>
    implements $OtherUserEntityCopyWith<$Res> {
  factory _$OtherUserEntityCopyWith(
          _OtherUserEntity value, $Res Function(_OtherUserEntity) then) =
      __$OtherUserEntityCopyWithImpl<$Res>;
  @override
  $Res call({String username, Uri? propic});
}

/// @nodoc
class __$OtherUserEntityCopyWithImpl<$Res>
    extends _$OtherUserEntityCopyWithImpl<$Res>
    implements _$OtherUserEntityCopyWith<$Res> {
  __$OtherUserEntityCopyWithImpl(
      _OtherUserEntity _value, $Res Function(_OtherUserEntity) _then)
      : super(_value, (v) => _then(v as _OtherUserEntity));

  @override
  _OtherUserEntity get _value => super._value as _OtherUserEntity;

  @override
  $Res call({
    Object? username = freezed,
    Object? propic = freezed,
  }) {
    return _then(_OtherUserEntity(
      username: username == freezed
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      propic: propic == freezed
          ? _value.propic
          : propic // ignore: cast_nullable_to_non_nullable
              as Uri?,
    ));
  }
}

/// @nodoc

class _$_OtherUserEntity implements _OtherUserEntity {
  _$_OtherUserEntity({required this.username, this.propic});

  @override
  final String username;
  @override
  final Uri? propic;

  @override
  String toString() {
    return 'OtherUserEntity(username: $username, propic: $propic)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OtherUserEntity &&
            (identical(other.username, username) ||
                const DeepCollectionEquality()
                    .equals(other.username, username)) &&
            (identical(other.propic, propic) ||
                const DeepCollectionEquality().equals(other.propic, propic)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(username) ^
      const DeepCollectionEquality().hash(propic);

  @JsonKey(ignore: true)
  @override
  _$OtherUserEntityCopyWith<_OtherUserEntity> get copyWith =>
      __$OtherUserEntityCopyWithImpl<_OtherUserEntity>(this, _$identity);
}

abstract class _OtherUserEntity implements OtherUserEntity {
  factory _OtherUserEntity({required String username, Uri? propic}) =
      _$_OtherUserEntity;

  @override
  String get username => throw _privateConstructorUsedError;
  @override
  Uri? get propic => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$OtherUserEntityCopyWith<_OtherUserEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$GameEntityTearOff {
  const _$GameEntityTearOff();

  _GameEntity call(
      {required String gameName,
      required String gameCode,
      DateTime? startTime,
      List<OtherUserEntity> users = const <OtherUserEntity>[],
      GameStatus gameStatus = GameStatus.WAITING,
      required String admin}) {
    return _GameEntity(
      gameName: gameName,
      gameCode: gameCode,
      startTime: startTime,
      users: users,
      gameStatus: gameStatus,
      admin: admin,
    );
  }
}

/// @nodoc
const $GameEntity = _$GameEntityTearOff();

/// @nodoc
mixin _$GameEntity {
  String get gameName => throw _privateConstructorUsedError;
  String get gameCode => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  List<OtherUserEntity> get users => throw _privateConstructorUsedError;
  GameStatus get gameStatus => throw _privateConstructorUsedError;
  String get admin => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameEntityCopyWith<GameEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameEntityCopyWith<$Res> {
  factory $GameEntityCopyWith(
          GameEntity value, $Res Function(GameEntity) then) =
      _$GameEntityCopyWithImpl<$Res>;
  $Res call(
      {String gameName,
      String gameCode,
      DateTime? startTime,
      List<OtherUserEntity> users,
      GameStatus gameStatus,
      String admin});
}

/// @nodoc
class _$GameEntityCopyWithImpl<$Res> implements $GameEntityCopyWith<$Res> {
  _$GameEntityCopyWithImpl(this._value, this._then);

  final GameEntity _value;
  // ignore: unused_field
  final $Res Function(GameEntity) _then;

  @override
  $Res call({
    Object? gameName = freezed,
    Object? gameCode = freezed,
    Object? startTime = freezed,
    Object? users = freezed,
    Object? gameStatus = freezed,
    Object? admin = freezed,
  }) {
    return _then(_value.copyWith(
      gameName: gameName == freezed
          ? _value.gameName
          : gameName // ignore: cast_nullable_to_non_nullable
              as String,
      gameCode: gameCode == freezed
          ? _value.gameCode
          : gameCode // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: startTime == freezed
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      users: users == freezed
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<OtherUserEntity>,
      gameStatus: gameStatus == freezed
          ? _value.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      admin: admin == freezed
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$GameEntityCopyWith<$Res> implements $GameEntityCopyWith<$Res> {
  factory _$GameEntityCopyWith(
          _GameEntity value, $Res Function(_GameEntity) then) =
      __$GameEntityCopyWithImpl<$Res>;
  @override
  $Res call(
      {String gameName,
      String gameCode,
      DateTime? startTime,
      List<OtherUserEntity> users,
      GameStatus gameStatus,
      String admin});
}

/// @nodoc
class __$GameEntityCopyWithImpl<$Res> extends _$GameEntityCopyWithImpl<$Res>
    implements _$GameEntityCopyWith<$Res> {
  __$GameEntityCopyWithImpl(
      _GameEntity _value, $Res Function(_GameEntity) _then)
      : super(_value, (v) => _then(v as _GameEntity));

  @override
  _GameEntity get _value => super._value as _GameEntity;

  @override
  $Res call({
    Object? gameName = freezed,
    Object? gameCode = freezed,
    Object? startTime = freezed,
    Object? users = freezed,
    Object? gameStatus = freezed,
    Object? admin = freezed,
  }) {
    return _then(_GameEntity(
      gameName: gameName == freezed
          ? _value.gameName
          : gameName // ignore: cast_nullable_to_non_nullable
              as String,
      gameCode: gameCode == freezed
          ? _value.gameCode
          : gameCode // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: startTime == freezed
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      users: users == freezed
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<OtherUserEntity>,
      gameStatus: gameStatus == freezed
          ? _value.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      admin: admin == freezed
          ? _value.admin
          : admin // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GameEntity implements _GameEntity {
  _$_GameEntity(
      {required this.gameName,
      required this.gameCode,
      this.startTime,
      this.users = const <OtherUserEntity>[],
      this.gameStatus = GameStatus.WAITING,
      required this.admin});

  @override
  final String gameName;
  @override
  final String gameCode;
  @override
  final DateTime? startTime;
  @JsonKey(defaultValue: const <OtherUserEntity>[])
  @override
  final List<OtherUserEntity> users;
  @JsonKey(defaultValue: GameStatus.WAITING)
  @override
  final GameStatus gameStatus;
  @override
  final String admin;

  @override
  String toString() {
    return 'GameEntity(gameName: $gameName, gameCode: $gameCode, startTime: $startTime, users: $users, gameStatus: $gameStatus, admin: $admin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GameEntity &&
            (identical(other.gameName, gameName) ||
                const DeepCollectionEquality()
                    .equals(other.gameName, gameName)) &&
            (identical(other.gameCode, gameCode) ||
                const DeepCollectionEquality()
                    .equals(other.gameCode, gameCode)) &&
            (identical(other.startTime, startTime) ||
                const DeepCollectionEquality()
                    .equals(other.startTime, startTime)) &&
            (identical(other.users, users) ||
                const DeepCollectionEquality().equals(other.users, users)) &&
            (identical(other.gameStatus, gameStatus) ||
                const DeepCollectionEquality()
                    .equals(other.gameStatus, gameStatus)) &&
            (identical(other.admin, admin) ||
                const DeepCollectionEquality().equals(other.admin, admin)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(gameName) ^
      const DeepCollectionEquality().hash(gameCode) ^
      const DeepCollectionEquality().hash(startTime) ^
      const DeepCollectionEquality().hash(users) ^
      const DeepCollectionEquality().hash(gameStatus) ^
      const DeepCollectionEquality().hash(admin);

  @JsonKey(ignore: true)
  @override
  _$GameEntityCopyWith<_GameEntity> get copyWith =>
      __$GameEntityCopyWithImpl<_GameEntity>(this, _$identity);
}

abstract class _GameEntity implements GameEntity {
  factory _GameEntity(
      {required String gameName,
      required String gameCode,
      DateTime? startTime,
      List<OtherUserEntity> users,
      GameStatus gameStatus,
      required String admin}) = _$_GameEntity;

  @override
  String get gameName => throw _privateConstructorUsedError;
  @override
  String get gameCode => throw _privateConstructorUsedError;
  @override
  DateTime? get startTime => throw _privateConstructorUsedError;
  @override
  List<OtherUserEntity> get users => throw _privateConstructorUsedError;
  @override
  GameStatus get gameStatus => throw _privateConstructorUsedError;
  @override
  String get admin => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$GameEntityCopyWith<_GameEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$AgentEntityTearOff {
  const _$AgentEntityTearOff();

  _AgentEntity call(
      {required String agentName,
      String? target,
      bool alive = true,
      int kills = 0}) {
    return _AgentEntity(
      agentName: agentName,
      target: target,
      alive: alive,
      kills: kills,
    );
  }
}

/// @nodoc
const $AgentEntity = _$AgentEntityTearOff();

/// @nodoc
mixin _$AgentEntity {
  String get agentName => throw _privateConstructorUsedError;
  String? get target => throw _privateConstructorUsedError;
  bool get alive => throw _privateConstructorUsedError;
  int get kills => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AgentEntityCopyWith<AgentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgentEntityCopyWith<$Res> {
  factory $AgentEntityCopyWith(
          AgentEntity value, $Res Function(AgentEntity) then) =
      _$AgentEntityCopyWithImpl<$Res>;
  $Res call({String agentName, String? target, bool alive, int kills});
}

/// @nodoc
class _$AgentEntityCopyWithImpl<$Res> implements $AgentEntityCopyWith<$Res> {
  _$AgentEntityCopyWithImpl(this._value, this._then);

  final AgentEntity _value;
  // ignore: unused_field
  final $Res Function(AgentEntity) _then;

  @override
  $Res call({
    Object? agentName = freezed,
    Object? target = freezed,
    Object? alive = freezed,
    Object? kills = freezed,
  }) {
    return _then(_value.copyWith(
      agentName: agentName == freezed
          ? _value.agentName
          : agentName // ignore: cast_nullable_to_non_nullable
              as String,
      target: target == freezed
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as String?,
      alive: alive == freezed
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
      kills: kills == freezed
          ? _value.kills
          : kills // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$AgentEntityCopyWith<$Res>
    implements $AgentEntityCopyWith<$Res> {
  factory _$AgentEntityCopyWith(
          _AgentEntity value, $Res Function(_AgentEntity) then) =
      __$AgentEntityCopyWithImpl<$Res>;
  @override
  $Res call({String agentName, String? target, bool alive, int kills});
}

/// @nodoc
class __$AgentEntityCopyWithImpl<$Res> extends _$AgentEntityCopyWithImpl<$Res>
    implements _$AgentEntityCopyWith<$Res> {
  __$AgentEntityCopyWithImpl(
      _AgentEntity _value, $Res Function(_AgentEntity) _then)
      : super(_value, (v) => _then(v as _AgentEntity));

  @override
  _AgentEntity get _value => super._value as _AgentEntity;

  @override
  $Res call({
    Object? agentName = freezed,
    Object? target = freezed,
    Object? alive = freezed,
    Object? kills = freezed,
  }) {
    return _then(_AgentEntity(
      agentName: agentName == freezed
          ? _value.agentName
          : agentName // ignore: cast_nullable_to_non_nullable
              as String,
      target: target == freezed
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as String?,
      alive: alive == freezed
          ? _value.alive
          : alive // ignore: cast_nullable_to_non_nullable
              as bool,
      kills: kills == freezed
          ? _value.kills
          : kills // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_AgentEntity extends _AgentEntity {
  _$_AgentEntity(
      {required this.agentName, this.target, this.alive = true, this.kills = 0})
      : super._();

  @override
  final String agentName;
  @override
  final String? target;
  @JsonKey(defaultValue: true)
  @override
  final bool alive;
  @JsonKey(defaultValue: 0)
  @override
  final int kills;

  @override
  String toString() {
    return 'AgentEntity(agentName: $agentName, target: $target, alive: $alive, kills: $kills)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AgentEntity &&
            (identical(other.agentName, agentName) ||
                const DeepCollectionEquality()
                    .equals(other.agentName, agentName)) &&
            (identical(other.target, target) ||
                const DeepCollectionEquality().equals(other.target, target)) &&
            (identical(other.alive, alive) ||
                const DeepCollectionEquality().equals(other.alive, alive)) &&
            (identical(other.kills, kills) ||
                const DeepCollectionEquality().equals(other.kills, kills)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(agentName) ^
      const DeepCollectionEquality().hash(target) ^
      const DeepCollectionEquality().hash(alive) ^
      const DeepCollectionEquality().hash(kills);

  @JsonKey(ignore: true)
  @override
  _$AgentEntityCopyWith<_AgentEntity> get copyWith =>
      __$AgentEntityCopyWithImpl<_AgentEntity>(this, _$identity);
}

abstract class _AgentEntity extends AgentEntity {
  factory _AgentEntity(
      {required String agentName,
      String? target,
      bool alive,
      int kills}) = _$_AgentEntity;
  _AgentEntity._() : super._();

  @override
  String get agentName => throw _privateConstructorUsedError;
  @override
  String? get target => throw _privateConstructorUsedError;
  @override
  bool get alive => throw _privateConstructorUsedError;
  @override
  int get kills => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AgentEntityCopyWith<_AgentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
