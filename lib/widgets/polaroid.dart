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
  Polaroid({
    Key? key,
    required this.duration,
    required this.target,
  }) : super(key: key);

  final Duration duration;
  final String target;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final rotationState = watch(rotationProvider).state;
    final Random rng = Random();

    return GestureDetector(
      onTap: () => context.read(rotationProvider).state ^= true,
      child: AspectRatio(
        aspectRatio: 3.5 / 4.2,
        child: AnimatedContainer(
          padding: EdgeInsets.all(rotationState ? 10 : 0),
          duration: duration,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateY(rotationState ? 0 : pi)
            ..rotateZ(rng.nextDouble() * pi / 8),
          curve: Curves.easeInOut,
          color: Colors.blue,
          child: AnimatedOpacity(
            curve: _StepCurve(),
            duration: duration,
            opacity: rotationState ? 1 : 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    transform: Matrix4.identity()..translate(0.0, 0.0, 10.0),
                    child: Image.asset("assets/logo.jpg"),
                  ),
                ),
                Text(target, style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 4)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
