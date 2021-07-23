// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:assassin_client/colors.dart';

class AssassinConfirmButton extends StatelessWidget {
  const AssassinConfirmButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = assassinWhite,
    this.width = double.infinity,
    this.height,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;
  final Color backgroundColor;
  final double width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
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
