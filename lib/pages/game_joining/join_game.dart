// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';

class JoinGameRoute extends StatelessWidget {
  const JoinGameRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 100;

    return TemplatePage(
      title: 'ASSASSIN',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildJoinLobbyButton(width, context),
          _buildCreateLobbyButton(width, context),
        ],
      ),
    );
  }

  Widget _buildJoinLobbyButton(double width, BuildContext context) {
    return SizedBox(
      width: width,
      height: width / 2,
      child: AssassinConfirmButton(
        heroTag: 'JOIN LOBBY',
        text: 'JOIN\nLOBBY',
        onPressed: () =>
            Navigator.pushNamed(context, '/homepage/join-game/join-lobby'),
      ),
    );
  }

  Widget _buildCreateLobbyButton(double width, BuildContext context) {
    return SizedBox(
      width: width,
      height: width / 2,
      child: AssassinConfirmButton(
        text: 'CREATE\nLOBBY',
        heroTag: 'CONFIGURE LOBBY',
        onPressed: () =>
            Navigator.pushNamed(context, '/homepage/join-game/configure-lobby'),
      ),
    );
  }
}
