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

class AssassinFormField extends ConsumerWidget {
  final focusProvider = ChangeNotifierProvider.autoDispose((_) => FocusNode());

  final hidePwdStateProvider = StateProvider.autoDispose<bool>((_) => true);
  final showIconProvider = StateProvider.autoDispose<bool>((_) => false);

  AssassinFormField({
    Key? key,
    this.icon,
    this.obscureText = false,
    this.hintText = '',
    this.validator,
    this.enabled = true,
    this.controller,
    this.maxLines = 1,
  }) : super(key: key);

  final IconData? icon;
  final String hintText;

  final bool enabled;
  final bool obscureText;

  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final int maxLines;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final hidePassword = watch(hidePwdStateProvider).state;
    final focusNode = watch(focusProvider);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: assassinDarkBlue, width: 4),
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

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: Stack(
        children: [
          TextFormField(
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
          if (obscureText)
            _buildShowPasswordButton(focusNode.hasFocus, hidePassword, context),
        ],
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
    textStyle,
  ) {
    final hintStyle = textStyle.copyWith(
      color: assassinDarkBlue.withAlpha(180),
    );
    final errorStyle = textStyle.copyWith(color: assassinRed, fontSize: 14.0);

    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 20, top: 2),
        child: Icon(icon, color: assassinDarkBlue),
      ),
      errorStyle: errorStyle,
      hintStyle: hintStyle,
      contentPadding: EdgeInsets.all(24),
      filled: true,
      fillColor: assassinBlue,
      border: border,
      errorBorder: errorBorder,
      disabledBorder: disabledBorder,
      enabledBorder: border,
      focusedBorder: border,
      focusedErrorBorder: border,
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
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: assassinDarkBlue, width: 4),
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
      contentPadding: EdgeInsets.all(24),
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
