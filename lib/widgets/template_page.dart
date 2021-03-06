// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:assassin_client/colors.dart';

class TemplatePage extends StatelessWidget {
  const TemplatePage({
    Key? key,
    this.title,
    this.child,
    this.appBarActions = const [],
    this.bottomNavigationBar,
  }) : super(key: key);

  final String? title;
  final Widget? child;
  final List<Widget> appBarActions;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context).copyWith(
      color: assassinDarkestBlue,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final topBar =
            title != null ? _buildTopBar(context, constraints) : null;

        return Scaffold(
          backgroundColor: assassinDarkestBlue,
          bottomNavigationBar: bottomNavigationBar,
          body: CustomScrollView(
            slivers: [
              if (title != null)
                SliverAppBar(
                  actionsIconTheme: iconTheme,
                  iconTheme: iconTheme,
                  pinned: true,
                  snap: true,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: assassinDarkestBlue,
                  actions: appBarActions,
                  flexibleSpace: topBar,
                ),
              SliverToBoxAdapter(
                child: ConstrainedBox(
                  constraints: constraints.copyWith(
                    minHeight: constraints.maxHeight -
                        (bottomNavigationBar != null ? 75 : 0) -
                        (title != null ? 95 : 0),
                    maxHeight: double.infinity,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, BoxConstraints constraints) {
    return Hero(
      tag: title!,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 16),
        width: constraints.maxWidth,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
          color: assassinWhite,
        ),
        child: Text(
          title!,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: assassinDarkestBlue),
        ),
      ),
    );
  }
}
