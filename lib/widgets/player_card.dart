import 'package:assassin_client/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssassinAvatar extends StatelessWidget {
  const AssassinAvatar({
    Key? key,
    required this.username,
    this.imageUrl,
  }) : super(key: key);

  final String username;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url =
        imageUrl ?? 'https://robohash.org/$username?set=set4&size=150x150';

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(50),
      color: assassinWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.network(url, fit: BoxFit.contain),
      ),
    );
  }
}

class AssassinPlayerCard extends StatelessWidget {
  const AssassinPlayerCard({
    Key? key,
    required this.username,
    this.variant = false,
  }) : super(key: key);

  final String username;
  final bool variant;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);

    var children = [
      //TODO: add image?
      AssassinAvatar(username: username, imageUrl: null),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          username,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: assassinDarkBlue, fontSize: 24),
        ),
      ),
    ];

    if (variant) {
      children = children.reversed.toList();
    }

    return Material(
      elevation: 4,
      borderRadius: borderRadius,
      color: variant ? assassinDarkBlue2 : assassinDarkBlue2,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {},
        child: Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
