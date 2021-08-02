// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/lobby_change_notifier.dart';
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/pages/game_joining/game_lobby.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/failures.dart';

class GameRoute extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //TODO: build this with future builder and provide a time scope
    final lobbyUpdater = watch(lobbyUpdaterProvider);
    final size = MediaQuery.of(context).size;

    final textStyle =
        Theme.of(context).textTheme.headline5!.copyWith(color: assassinWhite);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'The assassin game will end in:',
          style: textStyle,
        ),
        AssassinTimer(
          duration: Duration(days: 1, hours: 2, minutes: 3, seconds: 4),
        ),
        Container(
          alignment: Alignment.center,
          height: size.width,
          child: _buildLobbyPlayers(lobbyUpdater),
        )
      ],
    );
  }

  FutureBuilder<Either<Failure, LobbyModel>> _buildLobbyPlayers(
      LobbyUpdater lobbyUpdater) {
    //Handle one of the three cases
    //1. There is a failure in the retrieveral of lobby data (i.e. no internet)
    //2. Lobby data is received correctly
    //3. The (first) request is still awaiting a response
    return FutureBuilder<Either<Failure, LobbyModel>>(
      future: lobbyUpdater.lobby,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lobbyResult = snapshot.data!;
          return lobbyResult.fold(
              //Case 1
              (failure) => _buildErrorMessage(context),
              //Case 2
              (lobby) => _buildPlayerList(context, lobby));
        } else {
          //Case 3
          return _buildLoadingScreen(context);
        }
      },
    );
  }

  Widget _buildLoadingScreen(context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        backgroundColor: assassinRed,
        color: assassinWhite,
      ),
    );
  }

  Widget _buildErrorMessage(context) {
    return Text('Failed to retrieve information');
  }

  Widget _buildPlayerList(context, LobbyModel lobby) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lobby.players.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: AssassinPlayerCard(
            username: lobby.players[i].username,
            variant: i % 2 == 1,
          ),
        );
      },
    );
  }
}

class AssassinTimer extends StatelessWidget {
  const AssassinTimer({
    Key? key,
    required this.duration,
  }) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.headline5!.copyWith(color: assassinWhite);

    final timeStyleBig = textStyle.copyWith(fontSize: 60);
    final timeStyleSmall = textStyle.copyWith(fontSize: 12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              duration.inDays.toString().padLeft(2, '0'),
              style: timeStyleBig,
            ),
            Text('days', style: timeStyleSmall),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (duration.inHours % 24).toString().padLeft(2, '0'),
              style: timeStyleBig,
            ),
            Text('hours', style: timeStyleSmall),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (duration.inMinutes % 60).toString().padLeft(2, '0'),
              style: timeStyleBig,
            ),
            Text('minutes', style: timeStyleSmall),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              (duration.inSeconds % 60).toString().padLeft(2, '0'),
              style: timeStyleBig,
            ),
            Text('seconds', style: timeStyleSmall),
          ],
        )
      ],
    );
  }
}
