// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/widgets/polaroid.dart';
import 'package:assassin_client/widgets/user_input.dart';

final testEnricoLetta = Polaroid(
  targetLabel: 'ENRICO LETTA',
  targetPicture: Image(
    image: AssetImage('assets/enricone.jpg'),
    fit: BoxFit.fitWidth,
  ),
  animateDuration: Duration(milliseconds: 400),
);

final testNoTarget = Polaroid(
  description: """
Dear Agent,
unfortunately you've been recently killed.

Wait until you are re-deployed.

We trust that you will not fail us again.

                  ~ The Assassin Master
                  """,
  animateDuration: Duration(milliseconds: 400),
);

class TargetRoute extends StatelessWidget {
  const TargetRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //TODO make named constructors
            testEnricoLetta,
            AssassinConfirmButton(
              text: 'REPORT KILL!',
              textColor: assassinRed,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Container _buildPlaceholder() {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Transform.rotate(
        angle: -pi / 4,
        child: const Text('Target Profile Picture'),
      ),
    );
  }
}
