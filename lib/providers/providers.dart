// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/controllers/agent_view_controller.dart';
import 'package:assassin_client/controllers/game_view_controller.dart';
import 'package:assassin_client/controllers/user_view_controller.dart';
import 'package:assassin_client/datasources/agent_datasources.dart';
import 'package:assassin_client/datasources/codenames_datasources.dart';
import 'package:assassin_client/datasources/end_game_datasources.dart';
import 'package:assassin_client/datasources/game_stats_datasources.dart';
import 'package:assassin_client/datasources/game_status_datasources.dart';
import 'package:assassin_client/datasources/lobby_datasources.dart';
import 'package:assassin_client/datasources/user_datasource.dart';

final agentDataSource = Provider((ref) => AgentRemoteStorage());

final codenamesDataSource = Provider((ref) => CodenamesRemoteStorage());

final endGameDataSource = Provider((ref) => EndTimeRemoteStorage());

final gameStatusDataSource = Provider((ref) => GameStatusRemoteStorage());

final gameStatsDataSource = Provider((ref) => GameStatsRemoteStorage());

final lobbyDataSource = Provider((ref) => LobbyRemoteStorage());

final userDataSource = Provider((ref) => UserRemoteStorage());

final userViewCntrl =
    Provider((ref) => UserViewController(ref.watch, ref.watch(userDataSource)));

final gameViewCntrl = Provider((ref) => GameViewController(
      ref.watch,
      ref.watch(lobbyDataSource),
      ref.watch(gameStatusDataSource),
      ref.watch(endGameDataSource),
    ));

final agentViewCntrl = Provider(
  (ref) => AgentViewController(
    ref.watch,
    ref.watch(agentDataSource),
    ref.watch(codenamesDataSource),
  ),
);
