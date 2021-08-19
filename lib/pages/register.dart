// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/utils/login_utils.dart';
import 'package:assassin_client/widgets/template_page.dart';
import 'package:assassin_client/widgets/user_input.dart';

class RegisterRoute extends StatelessWidget {
  const RegisterRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      title: 'NEW ACCOUNT',
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const RegisterForm(),
            _buildGoToLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGoToLoginButton(context) {
    final style1 = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: assassinLightBlue);

    final style2 = Theme.of(context).textTheme.bodyText2!.copyWith(
          color: assassinRed,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
        );

    return Positioned(
      bottom: 10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Already have an account? ', style: style1),
          GestureDetector(
            onTap: () => Navigator.popAndPushNamed(context, '/'),
            child: Text('Sign in!', style: style2),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _attemptingLogin = false;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: assassinWhite);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Text('E-mail', style: style),
          const SizedBox(height: 4),
          _buildEmailForm(),
          const SizedBox(height: 20),
          Text('Password', style: style),
          const SizedBox(height: 4),
          _buildPasswordForm(),
          const SizedBox(height: 20),
          Text('Repeat Password', style: style),
          const SizedBox(height: 4),
          _buildPasswordForm(confirm: true),
          const SizedBox(height: 80),
          _buildRegisterButton(context),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AssassinConfirmButton(
        text: 'REGISTER',
        backgroundColor: _attemptingLogin ? assassinDarkBlue : assassinWhite,
        onPressed: _doRegister,
      ),
    );
  }

  Future<void> _doRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _attemptingLogin = true);

      // Unfocus the keyboard when we start the login process
      FocusManager.instance.primaryFocus?.unfocus();

      final userCredential = await registerr(
        _emailController.text.trim(),
        _passwordController.text,
      );

      await userCredential.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('sos')),
          );
        },
        (loginData) => Navigator.pushNamed(context, '/homepage'),
      );
    }

    setState(() => _attemptingLogin = false);
  }

  Widget _buildEmailForm() {
    return AssassinFormField(
      icon: Icons.mail,
      controller: _emailController,
      hintText: 'mario.rossi@example.com',
      validator: emailValidator,
    );
  }

  Widget _buildPasswordForm({confirm = false}) {
    return AssassinFormField(
      icon: Icons.password,
      controller: confirm ? _confirmPassController : _passwordController,
      hintText: 'password',
      obscureText: true,
      validator: confirm
          ? _confirmPwdValidator(_passwordController, _confirmPassController)
          : passwordValidator,
    );
  }

  String? Function(String?)? _confirmPwdValidator(controller1, controller2) {
    return (value) {
      if (_passwordController.text != _confirmPassController.text) {
        return 'passwords do not match';
      }

      return null;
    };
  }
}
