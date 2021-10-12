// Flutter imports:
import 'package:assassin_client/controllers/agent_view_controller.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/game_view_controller.dart';
import 'package:assassin_client/models/game_status_model.dart';
import 'package:assassin_client/pages/game_joining/game_lobby.dart';
import 'package:assassin_client/pages/homepage/join_game.dart';
import 'package:assassin_client/pages/homepage/game_settings.dart';
import 'package:assassin_client/pages/homepage/game_top.dart';
import 'package:assassin_client/pages/homepage/target.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/periodic_task_scope.dart';
import 'package:assassin_client/widgets/template_page.dart';

class HomepagePage extends ConsumerWidget {
  const HomepagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final game = watch(gameState);

    return PeriodicTaskScope(
      provider: agentUpdater,
      child: game.fold(
        () => _buildLoading(),
        (error, [fallback]) {
          switch (error.runtimeType) {
            case StatusFailure:
              return _buildNotInLobby();
            default:
              return _buildError(error);
          }
        },
        (game) {
          if (game.gameStatus == GameStatus.WAITING) {
            return _buildLobby(game);
          } else {
            return _buildGame(game);
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const TemplatePage(
      title: 'ASSASSIN',
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(Failure error) {
    return TemplatePage(title: error.message);
  }

  Widget _buildNotInLobby() {
    final pages = {
      const JoinGamePage(): FontAwesomeIcons.gamepad,
      const GameSettingsPage(): Icons.settings,
    };

    return HomePage(lobbyName: 'ASSASSIN', pages: pages);
  }

  Widget _buildLobby(GameEntity game) {
    final pages = {
      const GameLobbyPage(): FontAwesomeIcons.gamepad,
      const GameSettingsPage(): Icons.settings,
    };

    return HomePage(
      lobbyName: game.gameName.toUpperCase(),
      pages: pages,
    );
  }

  Widget _buildGame(GameEntity game) {
    final pages = {
      const GameRecapPage(): FontAwesomeIcons.users,
      const TargetRoute(): FontAwesomeIcons.skullCrossbones,
      const GameSettingsPage(): Icons.settings,
    };

    return HomePage(
      lobbyName: game.gameName.toUpperCase(),
      pages: pages,
    );
  }
}

class HomePage extends ConsumerWidget {
  final String lobbyName;
  final Map<Widget, IconData> pages;

  HomePage({
    Key? key,
    required this.lobbyName,
    required this.pages,
  }) : super(key: key);

  final controllerProvider = ChangeNotifierProvider((ref) => PageController());
  static const duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(controllerProvider);

    return PeriodicTaskScope(
      provider: gameUpdater,
      child: TemplatePage(
        title: lobbyName,
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: duration,
          backgroundColor: Colors.transparent,
          color: assassinWhite,
          items: pages.values.map((i) => FaIcon(i)).toList(),
          onTap: (index) {
            controller.animateToPage(
              index,
              duration: duration,
              curve: Curves.ease,
            );
          },
        ),
        child: Container(
          height: 0, // needed only to give the pageview a vertical size
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            itemBuilder: (context, index) {
              return pages.keys.elementAt(index);
            },
          ),
        ),
      ),
    );
  }
}
