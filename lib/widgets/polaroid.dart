// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rotationProvider = StateProvider<bool>((ref) => false);

/// We use a step function as a curve to hide the front of the polaroid
/// without resorting to a complex implementation with an AnimationController
class _StepCurve extends Curve {
  @override
  double transformInternal(double t) => t > 0.5 ? 1 : 0;
}

class Polaroid extends ConsumerWidget {
  const Polaroid({
    Key? key,
    required this.targetLabel,
    required this.targetPicture,
    required this.animateDuration,
  }) : super(key: key);

  final String targetLabel;
  final Widget targetPicture;
  final Duration animateDuration;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rotationState = watch(rotationProvider).state;
    final Random rng = Random();

    return GestureDetector(
      onTap: () => context.read(rotationProvider).state ^= true,
      child: AspectRatio(
        aspectRatio: 3.5 / 4.2,
        child: AnimatedContainer(
          duration: animateDuration,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(rotationState ? 0 : pi)
            ..rotateZ(rng.nextDouble() * pi / 8),
          curve: Curves.easeInOut,
          child: Stack(
            children: [
              Image(image: AssetImage("assets/polaroid.png")),
              AnimatedOpacity(
                curve: _StepCurve(),
                duration: animateDuration,
                opacity: rotationState ? 1 : 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AspectRatio(aspectRatio: 1, child: targetPicture),
                      Text(
                        targetLabel,
                        //TODO: add 'handwritten' font
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 50)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
