// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/agent_view_controller.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/widgets/polaroid.dart';
import 'package:assassin_client/widgets/user_input.dart';

final String killString = """
Dear Agent,
unfortunately you've been recently killed.

Wait until you are re-deployed.

We trust that you will not fail us again.

      ~ The Assassin Master
                  """;

class TargetRoute extends ConsumerWidget {
  const TargetRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final agent = watch(agentState);

    return Center(
      child: Container(
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            agent.fold(
              () => Text('Loading...'),
              (left, [cache]) => Text('Errore'),
              _buildPolaroid,
            ),
            AssassinConfirmButton(
              text: 'REPORT KILL!',
              textColor: assassinRed,
              onPressed: agent.foldRightOrNull((agent) {
                if (agent.hasActiveTarget) {
                  return () {
                    unawaited(watch(agentViewCntrl).kill());
                  };
                } else {
                  return null;
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolaroid(AgentEntity agent) {
    if (agent.hasActiveTarget) {
      return Polaroid.target(
        targetLabel: agent.target,
        targetPicture: Image(
          image: AssetImage('assets/enricone.jpg'),
          fit: BoxFit.fitWidth,
        ),
        animateDuration: Duration(milliseconds: 400),
      );
    } else {
      return Polaroid.description(
        description: killString,
        animateDuration: Duration(milliseconds: 400),
      );
    }
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
