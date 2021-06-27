// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:provider/provider.dart';

class PasswordFieldModel extends ChangeNotifier {
  String _password;
  bool _show;

  PasswordFieldModel()
      : _password = "",
        _show = false;

  get show => _show;
  get password => _password;

  void toggle(String currPass) {
    _password = currPass;
    _show = !_show;
    notifyListeners();
  }
}

class PasswordToggleField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FocusNode>(
      create: (_) => FocusNode(),
      child: ChangeNotifierProvider(
        create: (_) => PasswordFieldModel(),
        child: Consumer2<PasswordFieldModel, FocusNode>(
          builder: (context, pwfield, focusNode, child) => Stack(
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
                    onPressed: () => pwfield.toggle(passwordController.text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
