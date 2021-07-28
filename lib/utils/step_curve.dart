// Flutter imports:
import 'package:flutter/animation.dart';

class StepCurve extends Curve {
  @override
  double transformInternal(double t) => t > 0.5 ? 1 : 0;
}
