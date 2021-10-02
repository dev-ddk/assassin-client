// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import '../colors.dart';

const iconShow = Icons.visibility_off;
const iconHide = Icons.visibility;

//TODO: refactor
class AssassinFormField extends ConsumerWidget {
  final focusProvider = ChangeNotifierProvider.autoDispose((_) => FocusNode());

  final hidePwdStateProvider = StateProvider.autoDispose<bool>((_) => true);
  final showIconProvider = StateProvider.autoDispose<bool>((_) => false);

  AssassinFormField(
      {Key? key,
      this.icon,
      this.obscureText = false,
      this.hintText = '',
      this.validator,
      this.enabled = true,
      this.controller,
      this.maxLines = 1,
      this.onFieldSubmitted})
      : super(key: key);

  final IconData? icon;
  final String hintText;

  final bool enabled;
  final bool obscureText;

  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final int maxLines;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final hidePassword = watch(hidePwdStateProvider).state;
    final focusNode = watch(focusProvider);

    final borderRadius = BorderRadius.circular(24);

    final border = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    );

    final errorBorder = border.copyWith(
      borderSide: const BorderSide(color: assassinRed, width: 2.5),
    );

    final disabledBorder = border.copyWith(
      borderSide: border.borderSide.copyWith(color: Colors.grey),
    );

    final textStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: assassinDarkestBlue);

    final form = _buildForm(textStyle, focusNode, hidePassword, context, border,
        errorBorder, disabledBorder);

    return Stack(
      children: [
        Material(
          color: assassinBlue.withAlpha(180),
          elevation: 4,
          borderRadius: borderRadius,
          child: form,
        ),
        if (obscureText)
          _buildShowPasswordButton(focusNode.hasFocus, hidePassword, context),
      ],
    );
  }

  Widget _buildForm(
      TextStyle textStyle,
      FocusNode focusNode,
      bool hidePassword,
      BuildContext context,
      OutlineInputBorder border,
      OutlineInputBorder errorBorder,
      OutlineInputBorder disabledBorder) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 0.0), //PUT THIS TO 8 ONLY WHEN ERROR IS SHOWING
      child: TextFormField(
        style: textStyle,
        focusNode: focusNode,
        controller: controller,
        validator: validator,
        textAlign: maxLines == 1 ? TextAlign.center : TextAlign.start,
        autofillHints: [
          obscureText ? AutofillHints.password : AutofillHints.email,
        ],
        obscureText: obscureText && hidePassword,
        obscuringCharacter: '*',
        enabled: enabled,
        maxLines: maxLines,
        decoration: _buildInputDecoration(
          context,
          border,
          errorBorder,
          disabledBorder,
          textStyle,
        ),
      ),
    );
  }

  Widget _buildShowPasswordButton(
    bool showIcon,
    bool hidePassword,
    BuildContext context,
  ) {
    return Visibility(
      visible: showIcon,
      child: Container(
        padding: EdgeInsets.only(top: 10, right: 10),
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(
            hidePassword ? iconHide : iconShow,
            color: assassinDarkBlue,
          ),
          onPressed: () {
            // invert hide state
            context.read(hidePwdStateProvider).state ^= true;
          },
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    context,
    border,
    errorBorder,
    disabledBorder,
    TextStyle textStyle,
  ) {
    final hintStyle = textStyle.copyWith(
      color: assassinDarkBlue.withAlpha(150),
    );

    final errorStyle = textStyle.copyWith(
      color: assassinRed,
      fontSize: 14,
      height: 1.2,
    );

    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 20, top: 2),
        child: Icon(icon, color: assassinDarkBlue),
      ),
      isDense: true,
      errorStyle: errorStyle,
      hintStyle: hintStyle,
      contentPadding: const EdgeInsets.all(24),
      filled: true,
      fillColor: assassinBlue,
      hoverColor: Colors.red,
      border: border,
      errorBorder: errorBorder,
      disabledBorder: disabledBorder,
      enabledBorder: border,
      focusedBorder: border,
      focusedErrorBorder: errorBorder,
      hintText: hintText,
    );
  }
}

class AssassinDropDownForm extends ConsumerWidget {
  AssassinDropDownForm({
    Key? key,
    required this.items,
    required this.selectedProvider,
  }) : super(key: key);

  final IconData icon = FontAwesomeIcons.users;
  final focusProvider = ChangeNotifierProvider.autoDispose((_) => FocusNode());

  final List<Widget> items;
  final selectedProvider;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final focusNode = watch(focusProvider);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: assassinDarkBlue, width: 2),
    );

    final errorBorder = border.copyWith(
      borderSide: border.borderSide.copyWith(color: assassinRed),
    );

    final disabledBorder = border.copyWith(
      borderSide: border.borderSide.copyWith(color: Colors.grey),
    );

    final textStyle = Theme.of(context)
        .textTheme
        .bodyText1!
        .copyWith(color: assassinDarkestBlue);

    return DropdownButtonFormField(
      focusNode: focusNode,
      iconEnabledColor: assassinDarkBlue,
      iconSize: 24.0,
      decoration: _buildInputDecoration(
          context, border, errorBorder, disabledBorder, textStyle),
      value: 1,
      isExpanded: true,
      items: [
        for (int i = 0; i < items.length; i++)
          DropdownMenuItem(
            value: i,
            child: Center(child: items[i]),
          )
      ],
      onChanged: (int? value) {
        context.read(selectedProvider).state = value ?? -1;
      },
    );
  }

  InputDecoration _buildInputDecoration(
    context,
    border,
    errorBorder,
    disabledBorder,
    textStyle,
  ) {
    final hintStyle = textStyle.copyWith(
      color: assassinDarkBlue.withAlpha(180),
    );

    final errorStyle = textStyle.copyWith(color: assassinRed, fontSize: 14.0);

    return InputDecoration(
      errorStyle: errorStyle,
      hintStyle: hintStyle,
      contentPadding: const EdgeInsets.all(24),
      filled: true,
      fillColor: assassinBlue,
      border: border,
      errorBorder: errorBorder,
      disabledBorder: disabledBorder,
      enabledBorder: border,
      focusedBorder: border,
      focusedErrorBorder: border,
      // hintText: hintText,
    );
  }
}

class AssassinConfirmButton extends StatelessWidget {
  const AssassinConfirmButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = assassinDarkestBlue,
    this.backgroundColor = assassinWhite,
    this.width = double.infinity,
    this.height = 60,
    this.heroTag,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;
  final Color textColor;
  final Color backgroundColor;
  final double width;
  final double? height;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headline5!.copyWith(
          color: onPressed == null ? textColor.withAlpha(120) : textColor,
        );

    return heroTag != null
        ? Hero(tag: heroTag!, child: _buildButton(style))
        : _buildButton(style);
  }

  SizedBox _buildButton(TextStyle style) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          primary: backgroundColor,
          onSurface: assassinRed,
          onPrimary: assassinRed,
          splashFactory: InkRipple.splashFactory,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, textAlign: TextAlign.center, style: style),
      ),
    );
  }
}
