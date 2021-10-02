// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:assassin_client/widgets/player_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _buildAgentCard(user, agent),
              SizedBox(height: 20),
              _buildShowHideButton(),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                AssassinConfirmButton(
                  text: 'REPORT BUG',
                  heroTag: 'REPORT BUG',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/homepage/report_bug'),
                ),
                SizedBox(height: 20),
                AssassinConfirmButton(
                  text: 'LOGOUT',
                  onPressed: () => showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showLogoutDialog(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16.0);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: assassinWhite,
        content: Text('Are you sure you want to logout?', style: style),
        actions: [
          TextButton(
            child: Text('Cancel', style: style),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Logout', style: style.copyWith(color: assassinRed)),
            onPressed: () {
              FirebaseAuth.instance.signOut();

              Navigator.popUntil(context, (route) => false);
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShowHideButton() {
    return Consumer(
      builder: (context, watch, _) {
        final rotationState = watch(rotationProvider).state;
        return AssassinConfirmButton(
          text: rotationState ? 'SHOW ID CARD' : 'HIDE ID CARD',
          onPressed: () => context.read(rotationProvider).state ^= true,
        );
      },
    );
  }

  Widget _buildAgentCard(
    CachedState<Failure, UserEntity> user,
    CachedState<Failure, AgentEntity> agent,
  ) {
    if (agent.isRight && user.isRight) {
      return AgentCard(
        username: user.state.right!.username,
        agent: agent.state.right!,
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
    required this.agent,
    Key? key,
  }) : super(key: key);

  final Duration duration;
  final String username;
  final AgentEntity agent;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rotationState = watch(rotationProvider).state;

    final labelStyle =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14.0);

    final valueStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(fontFamily: 'Special Elite', fontSize: 24.0, height: 1.2);

    final stepCurve = StepCurve();

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
            curve: stepCurve,
            duration: duration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLogos(),
                Padding(
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
                      Text(
                        toBeginningOfSentenceCase(agent.agentName)!,
                        style: valueStyle,
                      ),
                      SizedBox(height: 28),
                      _buildKillCounters(labelStyle, valueStyle)
                    ],
                  ),
                )
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: rotationState ? 0.0 : 1.0,
            duration: duration,
            curve: stepCurve,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              height: 200,
              transform: Matrix4.identity()..rotateY(pi),
              transformAlignment: Alignment.center,
              child: Image.asset(
                'assets/assassin_logo.png',
                color: Colors.white60,
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildKillCounters(TextStyle labelStyle, TextStyle valueStyle) {
    return Row(
      children: [
        Text('Game Kills: ', style: labelStyle),
        SizedBox(width: 4),
        Text(
          agent.kills.toString(),
          style: valueStyle.copyWith(color: assassinRed),
        ),
        SizedBox(width: 15),
        Text('Total Kills', style: labelStyle),
        SizedBox(width: 4),
        Text(
          agent.kills.toString(),
          style: valueStyle.copyWith(color: assassinRed),
        )
      ],
    );
  }

  Widget _buildLogos() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      width: 100,
      child: Column(
        children: [
          SizedBox(height: 10),
          //TODO: add image
          AssassinAvatar(username: username, imageUrl: null),
          SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: SvgPicture.asset('assets/assassin_logo.svg'),
          ),
        ],
      ),
    );
  }
}
