// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/pages/game_joining/join_game.dart';
import 'package:assassin_client/pages/homepage/game_settings.dart';
import 'package:assassin_client/pages/homepage/game_top.dart';
import 'package:assassin_client/pages/homepage/target.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/template_page.dart';

class HomePageRoute extends ConsumerWidget {
  const HomePageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final lobbyUpdater = watch(lobbyUpdaterProvider);

    return FutureBuilder<Either<Failure, LobbyModel>>(
      future: lobbyUpdater.lobby,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const TemplatePage(
            title: 'ASSASSIN',
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final lobby = snapshot.data!;

        return lobby.fold(
          (error) {
            switch (error.runtimeType) {
              case CacheFailure:
                return const JoinGameRoute();
              default:
                return TemplatePage(
                  title: error.runtimeType.toString(),
                );
            }
          },
          (lobby) => TemplatePage(
            title: lobby.name.toUpperCase(),
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  Map<Widget, IconData> pages = {
    const TargetRoute(): FontAwesomeIcons.skullCrossbones,
    GameRoute(): FontAwesomeIcons.users,
    GameSettingsRoute(): Icons.settings,
  };

  final controllerProvider = ChangeNotifierProvider((ref) => PageController());
  static const duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(controllerProvider);
    final lobbyUpdater = watch(lobbyUpdaterProvider);

    return FutureBuilder<Either<Failure, LobbyModel>>(
      future: lobbyUpdater.lobby,
      builder: (context, snapshot) {
        var lobbyName = '... LOADING ...';

        if (snapshot.connectionState == ConnectionState.done) {
          snapshot.data!.fold(
              (failure) => lobbyName = 'failed to retrieve lobby',
              (lobby) => lobbyName = lobby.name.toUpperCase());
        }

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
      },
    );
  }
}
