// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/lobby_change_notifier.dart';
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';

class GameLobbyRoute extends ConsumerWidget {
  const GameLobbyRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final lobbyUpdater = watch(lobbyUpdaterProvider);
    final size = MediaQuery.of(context).size;

    return FutureBuilder<Either<Failure, LobbyModel>>(
      future: lobbyUpdater.lobby,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final lobby = snapshot.data!;

        return lobby.fold(
          (error) => TemplatePage(
            title: 'ERROR',
            child: Text(error.toString()),
          ),
          (lobby) => TemplatePage(
            title: 'GAME LOBBY',
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  _buildTopText(context),
                  SizedBox(height: 20),
                  _buildTapText(context),
                  _buildLobbyCode(context, 'OWO'),
                  SizedBox(height: 20),
                  _buildStartGameButton(size, lobbyUpdater),
                  _buildPlayerInLobbyText(context),
                  SizedBox(height: 20),
                  _buildLobbyPlayers(lobbyUpdater),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
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

  // ignore: unused_element
  Widget _buildStartGameButton(Size size, LobbyUpdater lobby) {
    return FutureBuilder<Either<Failure, bool>>(
      future: lobby.admin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final adminResult = snapshot.data!;

          return adminResult.fold(
            //Case 1
            (failure) => _buildErrorMessage(context),
            //Case 2
            (isLobbyAdmin) {
              if (isLobbyAdmin) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: AssassinConfirmButton(
                    width: size.width / 2,
                    height: size.width / 4,
                    text: 'Start Game!',
                    onPressed: () {},
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildPlayerList(context, LobbyModel lobby) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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

  Widget _buildErrorMessage(context) {
    return Text('Failed to retrieve information');
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

  // ignore: unused_element
  Widget _buildPlayerInLobbyText(context) {
    return Text(
      'Players in the Lobby',
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(color: assassinWhite, fontSize: 20),
    );
  }

  // ignore: unused_element
  Widget _buildLobbyCode(context, code) {
    return GestureDetector(
      onTap: () => Clipboard.setData(ClipboardData(text: code)),
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            code,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = assassinDarkBlue,
                  fontSize: 60,
                ),
          ),
          // Solid text as fill.
          Text(
            code,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: assassinBlue, fontSize: 60),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildTapText(context) {
    return Text(
      'Tap to copy to clipboard',
      textAlign: TextAlign.center,
      style:
          Theme.of(context).textTheme.subtitle1!.copyWith(color: assassinWhite),
    );
  }

  // ignore: unused_element
  Widget _buildTopText(context) {
    return Text(
      'Send this code to your friends!',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(color: assassinWhite, fontSize: 20),
    );
  }
}

class AssassinPlayerCard extends StatelessWidget {
  const AssassinPlayerCard({
    Key? key,
    required this.username,
    this.variant = false,
  }) : super(key: key);

  final String username;
  final bool variant;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var children = [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: variant ? assassinDarkBlue2 : assassinDarkBlue,
            width: 2,
          ),
        ),
        child: ClipOval(child: Image.asset('assets/test_propic.png')),
      ),
      Text(
        username,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: assassinDarkBlue, fontSize: 20),
      ),
    ];

    if (variant) {
      children = children.reversed.toList();
    }

    return Container(
      width: size.width / 1.1,
      height: 100,
      decoration: BoxDecoration(
        color: variant ? assassinLightBlue : assassinBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: variant ? assassinDarkBlue2 : assassinDarkBlue,
          width: 4,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
