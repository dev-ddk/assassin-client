// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/template_page.dart';

class JoinGameRoute extends StatelessWidget {
  const JoinGameRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 100;

    return TemplatePage(
      title: 'JOIN GAME',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: width,
            height: width,
            child: AssassinConfirmButton(
              text: 'JOIN\nLOBBY',
              onPressed: () {
                Navigator.pushNamed(context, '/homepage/joingame/join-lobby');
              },
            ),
          ),
          SizedBox(
            width: width,
            height: width,
            child: AssassinConfirmButton(
              text: 'CREATE LOBBY',
              onPressed: () {
                Navigator.pushNamed(
                    context, '/homepage/joingame/configure-lobby');
              },
            ),
          ),
        ],
      ),
    );
  }
}
