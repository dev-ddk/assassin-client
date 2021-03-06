// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/utils/step_curve.dart';

final rotationProvider = StateProvider<bool>((ref) => false);

/// We use a step function as a curve to hide the front of the polaroid
/// without resorting to a complex implementation with an AnimationController

class Polaroid extends ConsumerWidget {
  const Polaroid.target(
      {Key? key,
      required this.targetLabel,
      required this.targetPicture,
      required this.animateDuration})
      : withTarget = true,
        description = null,
        super(key: key);

  const Polaroid.description(
      {Key? key, required this.description, required this.animateDuration})
      : withTarget = false,
        targetPicture = null,
        targetLabel = null,
        super(key: key);

  final String? targetLabel;
  final Widget? targetPicture;
  final Duration animateDuration;
  final String? description;
  final bool withTarget;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rotationState = watch(rotationProvider).state;
    final size = MediaQuery.of(context).size;
    final rng = Random();

    return GestureDetector(
      onTap: () => context.read(rotationProvider).state ^= true,
      child: AspectRatio(
        aspectRatio: 3.5 / 4.2,
        child: AnimatedContainer(
          duration: animateDuration,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(rotationState ? 0 : pi)
            ..rotateZ(rng.nextDouble() * pi / 16),
          curve: Curves.easeInOut,
          child: Stack(
            children: [
              _buildBack(),
              _buildSheet(rotationState),
              if (withTarget) _buildTarget(rotationState, size, context),
              if (!withTarget)
                AnimatedOpacity(
                  curve: StepCurve(),
                  duration: animateDuration,
                  opacity: rotationState ? 1 : 0,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(50, 30, 50, 20),
                    transformAlignment: Alignment.center,
                    transform: Matrix4.identity()..rotateZ(pi / 32),
                    child: Text(
                      description!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontFamily: 'Special Elite',
                            height: 1.3,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedOpacity _buildTarget(
      bool rotationState, Size size, BuildContext context) {
    return AnimatedOpacity(
      curve: StepCurve(),
      duration: animateDuration,
      opacity: rotationState ? 1 : 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.4,
              height: size.width * 0.4,
              transformAlignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(-pi / 64),
              color: assassinWhite,
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
              child: targetPicture,
            ),
            SizedBox(height: 20),
            Text('Your target:'),
            Container(
              width: size.width,
              alignment: Alignment.center,
              child: Text(
                targetLabel!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  AnimatedOpacity _buildSheet(bool rotationState) {
    return AnimatedOpacity(
      curve: StepCurve(),
      duration: animateDuration,
      opacity: rotationState ? 1 : 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0),
        child: Container(
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateZ(pi / 32)
            ..translate(-10.0, -20.0),
          color: assassinBlue,
        ),
      ),
    );
  }

  Container _buildBack() {
    return Container(
      color: assassinDarkBlue2,
    );
  }
}
