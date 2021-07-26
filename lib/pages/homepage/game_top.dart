// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameRoute extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        for (int i = 0; i < 20; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 300,
              color: Colors.red,
            ),
          )
      ],
    );
  }
}
