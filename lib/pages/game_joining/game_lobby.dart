// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/game_view_controller.dart';
import 'package:assassin_client/controllers/user_view_controller.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';

class GameLobbyRoute extends ConsumerWidget {
  const GameLobbyRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final lobby = watch(gameState);
    final user = watch(userState);
    final size = MediaQuery.of(context).size;
    final gameController = watch(gameViewCntrl);

    return lobby.fold<Widget>(
      () => CircularProgressIndicator(),
      (error, [_]) => TemplatePage(
        title: 'ERROR',
        child: Text(error.toString()),
      ),
      (game) => TemplatePage(
        title: 'GAME LOBBY',
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              _buildTopText(context),
              SizedBox(height: 20),
              _buildTapText(context),
              _buildLobbyCode(context, game.gameCode),
              SizedBox(height: 20),
              _buildStartGameButton(
                size,
                game,
                user.cache?.username,
                gameController,
              ),
              _buildPlayerInLobbyText(context),
              SizedBox(height: 20),
              _buildPlayerList(context, game),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButton(
      Size size, GameEntity game, String? userName, gameController) {
    if (userName != null && userName == game.admin) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: AssassinConfirmButton(
          width: size.width / 2,
          height: size.width / 4,
          text: 'Start Game!',
          onPressed: () => gameController.startGame(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPlayerList(context, GameEntity lobby) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: lobby.users.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: AssassinPlayerCard(
            username: lobby.users[i].username,
            variant: i % 2 == 1,
          ),
        );
      },
    );
  }

/*
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
*/
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

    final borderRadius = BorderRadius.circular(24);

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

    return Material(
      elevation: 4,
      borderRadius: borderRadius,
      color: variant ? assassinLightBlue : assassinBlue,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {},
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
