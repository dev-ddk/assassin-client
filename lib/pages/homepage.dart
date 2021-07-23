// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/main.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  static const Map<String, IconData> pages = {
    '/homepage/target': FontAwesomeIcons.bullseye,
    '/homepage/game': FontAwesomeIcons.users,
    '/homepage/report': FontAwesomeIcons.skullCrossbones,
    '/homepage/profile': FontAwesomeIcons.userSecret,
  };

  final controllerProvider = ChangeNotifierProvider((ref) => PageController());
  static const duration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(controllerProvider);

    return Scaffold(
      backgroundColor: assassinDarkestBlue,
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: duration,
        backgroundColor: Colors.transparent,
        color: assassinRed,
        items: pages.values.map((i) => FaIcon(i)).toList(),
        onTap: (index) {
          controller.animateToPage(
            index,
            duration: duration,
            curve: Curves.ease,
          );
        },
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        itemBuilder: (context, index) {
          return routes[pages.keys.elementAt(index)]!.call(context);
        },
      ),
    );
  }
}
