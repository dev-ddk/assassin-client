// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/models/lobby_model.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/template_page.dart';

class GameLobbyRoute extends StatelessWidget {
  GameLobbyRoute({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isOwner = true; //TODO: Add owner check

    return TemplatePage(
      title: 'GAME LOBBY',
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildTopText(context),
            SizedBox(height: 20),
            _buildTapText(context),
            _buildLobbyCode(context, 'C4F3B4B3'),
            SizedBox(height: 20),
            if (isOwner)
              AssassinConfirmButton(
                width: size.width / 2,
                height: size.width / 4,
                text: 'Start Game!',
                onPressed: () {},
              ),
            if (isOwner) SizedBox(height: 20),
            _buildPlayerInLobbyText(context),
            SizedBox(height: 20),
            Consumer(
              // Rebuild only the Text when counterProvider updates
              builder: (context, ref, child) {
                // Listens to the value exposed by counterProvider
                final lobbyFuture = ref(lobbyUpdaterProvider).lobby;
                //Handle one of the three cases
                //1. There is a failure in the retrieveral of lobby data (i.e. no internet)
                //2. Lobby data is received correctly
                //3. The (first) request is still awaiting a response
                return FutureBuilder<Either<Failure, LobbyModel>>(
                  future: lobbyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
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
              },
            ),
          ],
        ),
      ),
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
    //TODO
    return Text('Failed to retrieve the lobby');
  }

  Widget _buildLoadingScreen(context) {
    //TODO
    return Text('Loading...');
  }

  Widget _buildPlayerInLobbyText(context) {
    return Text(
      'Players in the Lobby',
      style: Theme.of(context)
          .textTheme
          .headline6!
          .copyWith(color: assassinWhite, fontSize: 20),
    );
  }

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

  Widget _buildTapText(context) {
    return Text(
      'Tap to copy to clipboard',
      textAlign: TextAlign.center,
      style:
          Theme.of(context).textTheme.subtitle1!.copyWith(color: assassinWhite),
    );
  }

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
