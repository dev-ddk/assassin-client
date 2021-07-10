// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/widgets/polaroid.dart';

final rotateProvider = StateProvider<bool>((ref) => false);

class TargetRoute extends StatelessWidget {
  const TargetRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: assassinDarkestBlue,
      appBar: AppBar(
        backgroundColor: assassinDarkBlue,
        title: const Text('Second Route'),
      ),
      body: Column(
        children: [
          Polaroid(
            targetLabel: 'Target',
            targetPicture: Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -pi / 4,
                child: const Text('Target Profile Picture'),
              ),
            ),
            animateDuration: Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }
}
