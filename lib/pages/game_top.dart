// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';

class GameRoute extends ConsumerWidget {
  /// Used to trigger an event when the widget has been built
  // ignore: unused_element
  Future<bool> _afterWidgetBuilt() {
    final completer = Completer<bool>();
    // Register callback after the frame is built
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      completer.complete(true);
    });
    return completer.future;
  }

  final pageControllerProvider =
      ChangeNotifierProvider((_) => PageController(initialPage: 0));

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final pageController = watch(pageControllerProvider);

    return Scaffold(
      backgroundColor: assassinDarkestBlue,
      body: PageView(
        controller: pageController,
        children: [
          Container(color: Colors.red),
          Container(color: Colors.green),
          Container(color: Colors.blue)
        ],
      ),
      appBar: AppBar(
        title: Text('PARTITA DEMOCRATICA'),
      ),
    );
  }
}

class FingerPainter extends CustomPainter {
  final Color color;

  const FingerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    //Valid values for Xs -> (0, 0.5)
    final ctrl1X = .20;
    final ctrl1Y = .10;
    final ctrl2X = .10;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    // https://cubic-bezier.com/#.40,.20,.20,1.00
    final path = Path()
      ..moveTo(0, size.height)
      ..cubicTo(ctrl1X * size.width, (1 - ctrl1Y) * size.height,
          ctrl2X * size.width, 0, size.width * .5, 0)
      ..cubicTo((1 - ctrl2X) * size.width, 0, (1 - ctrl1X) * size.width,
          (1 - ctrl1Y) * size.height, size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant FingerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
