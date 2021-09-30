// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/controllers/agent_view_controller.dart';
import 'package:assassin_client/controllers/user_view_controller.dart';
import 'package:assassin_client/entities/entities.dart';
import 'package:assassin_client/utils/cached_state.dart';
import 'package:assassin_client/utils/failures.dart';
import 'package:assassin_client/utils/step_curve.dart';
import 'package:assassin_client/widgets/user_input.dart';

final rotationProvider = StateProvider<bool>((ref) => true);

class GameSettingsRoute extends ConsumerWidget {
  const GameSettingsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final agent = watch(agentState);
    final user = watch(userState);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          _buildAgentCard(user, agent),
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
                  heroTag: 'REPORT BUG',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/homepage/report_bug'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard(
    CachedState<Failure, UserEntity> user,
    CachedState<Failure, AgentEntity> agent,
  ) {
    if (agent.isRight && user.isRight) {
      final username = user.state.right?.username;
      final agentName = agent.state.right?.agentName;
      final kills = agent.state.right?.kills;
      final totalKills = agent.state.right?.kills; //TODO: statitics

      return AgentCard(
        username: username!,
        codename: toBeginningOfSentenceCase(agentName!)!,
        kills: kills!,
        totalKills: totalKills!,
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

class AgentCard extends ConsumerWidget {
  AgentCard({
    this.duration = const Duration(milliseconds: 400),
    required this.username,
    required this.codename,
    required this.kills,
    required this.totalKills,
    Key? key,
  }) : super(key: key);

  final Duration duration;
  final String username;
  final String codename;
  final int kills;
  final int totalKills;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rotationState = watch(rotationProvider).state;

    final labelStyle =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0);

    final valueStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontFamily: 'Special Elite', fontSize: 18.0);

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
              borderRadius: BorderRadius.circular(10),
              color: assassinGray,
            ),
          ),
          AnimatedOpacity(
            opacity: rotationState ? 1.0 : 0.0,
            curve: StepCurve(),
            duration: duration,
            child: Row(
              children: [
                _buildLogo(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username', style: labelStyle),
                        SizedBox(height: 3),
                        Text(username, style: valueStyle),
                        SizedBox(height: 6),
                        Text('Codename', style: labelStyle),
                        SizedBox(height: 3),
                        Text(codename, style: valueStyle),
                        SizedBox(height: 28),
                        _buildKillCounters(labelStyle, valueStyle)
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

  Widget _buildKillCounters(TextStyle labelStyle, TextStyle valueStyle) {
    return Row(
      children: [
        Text('Game Kills: ', style: labelStyle),
        SizedBox(width: 4),
        Text(kills.toString(), style: valueStyle.copyWith(color: assassinRed)),
        SizedBox(width: 15),
        Text('Total Kills', style: labelStyle),
        SizedBox(width: 4),
        Text(
          totalKills.toString(),
          style: valueStyle.copyWith(color: assassinRed),
        )
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
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
    );
  }
}
