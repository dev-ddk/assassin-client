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
    this.minWidth = 0,
    this.minHeight = 0,
  }) : super(key: key);

  final String text;
  final double minWidth, minHeight;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: assassinRed,
          padding: EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: Size(minWidth, minHeight)),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: assassinDarkestBlue,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
