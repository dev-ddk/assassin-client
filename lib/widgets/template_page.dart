// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:assassin_client/colors.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({
    Key? key,
    required this.title,
    required this.child,
    this.appBarActions = const [],
  }) : super(key: key);

  final String title;
  final Widget child;
  final List<Widget> appBarActions;

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      centerTitle: true,
      backwardsCompatibility: false,
      backgroundColor: assassinWhite,
      foregroundColor: assassinDarkestBlue,
      actions: appBarActions,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5!
            .copyWith(color: assassinDarkestBlue),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          appBar: appbar,
          backgroundColor: assassinDarkestBlue,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight:
                    constraints.maxHeight - appbar.preferredSize.height - 35,
                maxHeight: double.infinity,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
