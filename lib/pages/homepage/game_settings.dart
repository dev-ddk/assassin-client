// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/utils/step_curve.dart';
import 'package:assassin_client/widgets/user_input.dart';

final rotationProvider = StateProvider<bool>((ref) => true);

class GameSettingsRoute extends StatelessWidget {
  const GameSettingsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          AgentCard(
            Duration(milliseconds: 400),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                //Show/Hide Button
                Consumer(builder: (context, watch, _) {
                  final rotationState = watch(rotationProvider).state;
                  return AssassinConfirmButton(
                    text: rotationState ? 'SHOW ID CARD' : 'HIDE ID CARD',
                    onPressed: () =>
                        context.read(rotationProvider).state ^= true,
                  );
                }),
                SizedBox(height: 20),
                AssassinConfirmButton(
                  text: 'REPORT BUG',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgentCard extends ConsumerWidget {
  AgentCard(
    this.duration, {
    Key? key,
  }) : super(key: key);

  final Duration duration;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rotationState = watch(rotationProvider).state;

    final labelStyle =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 7.0);

    final valueStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontFamily: 'Roboto Mono', fontSize: 12.0);

    return AnimatedContainer(
      duration: duration,
      transformAlignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(rotationState ? 0 : pi),
      child: GestureDetector(
        onTap: () => context.read(rotationProvider).state ^= true,
        child: Stack(children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: assassinGray),
          ),
          AnimatedOpacity(
            opacity: rotationState ? 1.0 : 0.0,
            curve: StepCurve(),
            duration: duration,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  width: 100,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 90,
                        decoration: BoxDecoration(color: assassinBlue),
                        child: Image(
                          image: AssetImage('assets/logo.jpg'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 10),
                      Image.asset('assets/assassin_logo.png'),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name', style: labelStyle),
                        SizedBox(height: 3),
                        Text('Matteo Renzi', style: valueStyle),
                        SizedBox(height: 6),
                        Text('Codename', style: labelStyle),
                        SizedBox(height: 3),
                        Text('Bischero Fiorentino', style: valueStyle),
                        SizedBox(height: 6),
                        Text('Identifier', style: labelStyle),
                        SizedBox(height: 3),
                        Text('M4JS124', style: valueStyle),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Game Kills: ',
                              style: labelStyle,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '5',
                              style: valueStyle.copyWith(color: assassinRed),
                            ),
                            SizedBox(width: 15),
                            Text('Total Kills', style: labelStyle),
                            SizedBox(width: 4),
                            Text(
                              '11',
                              style: valueStyle.copyWith(color: assassinRed),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
