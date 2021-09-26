// Flutter imports:
import 'package:assassin_client/models/game_status_model.dart';
import 'package:assassin_client/pages/game_joining/game_lobby.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/game_view_controller.dart';
import 'package:assassin_client/pages/game_joining/join_game.dart';
import 'package:assassin_client/pages/homepage/game_settings.dart';
import 'package:assassin_client/pages/homepage/game_top.dart';
import 'package:assassin_client/pages/homepage/target.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/template_page.dart';

class HomePageRoute extends ConsumerWidget {
  const HomePageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final game = watch(gameState);

    return game.fold(
      () => const TemplatePage(
        title: 'ASSASSIN',
        child: Center(child: CircularProgressIndicator()),
      ),
      (error, [fallback]) {
        switch (error.runtimeType) {
          case StatusFailure:
            return const JoinGameRoute();
          default:
            return TemplatePage(title: error.message);
        }
      },
      (game) {
        if (game.gameStatus == GameStatus.WAITING) {
          return const GameLobbyRoute();
        }

        return HomePage(lobbyName: game.gameName.toUpperCase());
      },
    );
  }
}

class HomePage extends ConsumerWidget {
  final String lobbyName;

  HomePage({
    Key? key,
    required this.lobbyName,
  }) : super(key: key);

  final Map<Widget, IconData> pages = {
    const GameRoute(): FontAwesomeIcons.users,
    const TargetRoute(): FontAwesomeIcons.skullCrossbones,
    const GameSettingsRoute(): Icons.settings,
  };

  final controllerProvider = ChangeNotifierProvider((ref) => PageController());
  static const duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(controllerProvider);

    return TemplatePage(
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
    );
  }
}
