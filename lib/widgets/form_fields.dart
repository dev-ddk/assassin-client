// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../colors.dart';

class AssassinFormField extends ConsumerWidget {
  AssassinFormField({
    Key? key,
    required this.icon,
    this.obscureText = false,
    this.hintText = '',
    this.validator,
    this.enabled = true,
    this.controller,
  }) : super(key: key);

  final IconData icon;
  final bool obscureText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextEditingController? controller;

  static const iconShow = Icons.ac_unit;
  static const iconHide = Icons.handyman_outlined;

  final focusNodeProvider = ChangeNotifierProvider((_) => FocusNode());
  final hidePwdStateProvider = StateProvider<bool>((_) => true);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final focusNode = watch(focusNodeProvider);
    final hidePassword = watch(hidePwdStateProvider).state;

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
            focusNode: focusNode,
            controller: controller,
            validator: validator,
            textAlign: TextAlign.center,
            obscureText: obscureText && hidePassword,
            enabled: enabled,
            decoration: _buildInputDecoration(
              border,
              errorBorder,
              disabledBorder,
            ),
          ),
          if (obscureText)
            Visibility(
              visible: focusNode.hasFocus,
              child: Container(
                padding: EdgeInsets.only(top: 10, right: 10),
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    hidePassword ? iconHide : iconShow,
                    color: assassinDarkBlue,
                  ),
                  // invert hide state
                  onPressed: () {
                    context.read(hidePwdStateProvider).state ^= true;
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(OutlineInputBorder border,
      OutlineInputBorder errorBorder, OutlineInputBorder disabledBorder) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 20, top: 2),
        child: Icon(icon, color: assassinDarkBlue),
      ),
      hintStyle: TextStyle(color: assassinDarkBlue, fontSize: 20),
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
