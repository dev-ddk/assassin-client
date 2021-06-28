// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordToggleField extends ConsumerWidget {
  final passwordController = TextEditingController();
  final String? hint;
  final TextAlign textAlign;
  final String? Function(String?)? validator;

  final focusNodeProvider = ChangeNotifierProvider((_) => FocusNode());
  final hidePwdStateProvider = StateProvider<bool>((_) => true);

  static final iconShow = Icons.ac_unit;
  static final iconHide = Icons.handyman_outlined;

  PasswordToggleField({
    Key? key,
    this.hint,
    this.validator,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final focusNode = watch(focusNodeProvider);
    final hidePassword = watch(hidePwdStateProvider).state;

    return Stack(
      children: [
        TextFormField(
          controller: passwordController,
          focusNode: focusNode,
          obscureText: hidePassword,
          textAlign: textAlign,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
        Visibility(
          visible: focusNode.hasFocus,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(hidePassword ? iconHide : iconShow),
              // invert hide state
              onPressed: () => context.read(hidePwdStateProvider).state ^= true,
            ),
          ),
        ),
      ],
    );
  }
}
