// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordFieldModel extends ChangeNotifier {
  bool _show;

  PasswordFieldModel() : _show = false;

  get show => _show;

  void toggle() {
    _show = !_show;
    notifyListeners();
  }
}

final focusNodeProvider = ChangeNotifierProvider((ref) => FocusNode());
final fieldModelProvider =
    ChangeNotifierProvider((ref) => PasswordFieldModel());

class PasswordToggleField extends ConsumerWidget {
  final passwordController = TextEditingController();
  final String? hint;
  final TextAlign textAlign;
  final String? Function(String?)? validator;

  static final iconShow = Icons.ac_unit;
  static final iconHide = Icons.handyman_outlined;

  PasswordToggleField(
      {Key? key, this.hint, this.validator, this.textAlign = TextAlign.center})
      : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final focusNode = watch(focusNodeProvider);
    final pwfield = watch(fieldModelProvider);

    return Stack(
      children: [
        TextFormField(
          controller: passwordController,
          focusNode: focusNode,
          obscureText: !pwfield.show,
          textAlign: textAlign,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
        Visibility(
          visible: focusNode.hasFocus,
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(pwfield.show ? iconShow : iconHide),
              onPressed: () => pwfield.toggle(),
            ),
          ),
        ),
      ],
    );
  }
}
