// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/utils/api.dart';
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/form_fields.dart';
import 'package:assassin_client/widgets/template_page.dart';

class RegisterRoute extends StatelessWidget {
  RegisterRoute({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return TemplatePage(
      title: 'NEW ACCOUNT',
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Form(
              key: _formKey,
              child: AutofillGroup(
                child: _buildBody(context, auth),
              ),
            ),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(context, auth) {
    final textStyle =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: assassinWhite);
    return Column(
      children: [
        const SizedBox(height: 60),
        Text('E-mail', style: textStyle),
        const SizedBox(height: 4),
        _buildEmailForm(),
        const SizedBox(height: 20),
        Text('Password', style: textStyle),
        const SizedBox(height: 4),
        _buildPasswordForm(),
        const SizedBox(height: 20),
        Text('Repeat Password', style: textStyle),
        const SizedBox(height: 4),
        _buildPasswordForm(confirm: true),
        const SizedBox(height: 80),
        _buildRegisterButton(context, auth),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildLoginButton(context) {
    return Positioned(
      bottom: 10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: assassinLightBlue,
                ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Sign in!',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: assassinRed,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(context, auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AssassinConfirmButton(
        text: 'REGISTER',
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();

          final register = await _doRegister(auth, context);

          final displayContent = register?.toString() ?? 'Register Failed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(displayContent)),
          );

          if (register != null) {
            await Navigator.pushNamed(context, '/homepage');
          }
        },
      ),
    );
  }

  Future<UserCredential?> _doRegister(FirebaseAuth auth, context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await register(
          emailController.text.trim(),
          passwordController.text,
        );

        return userCredential;
      } on FirebaseAuthException catch (_) {}
    }
  }

  Widget _buildEmailForm() {
    return AssassinFormField(
      icon: Icons.mail,
      controller: emailController,
      hintText: 'mario.rossi@example.com',
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return 'email should contain stuff';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordForm({confirm = false}) {
    return AssassinFormField(
      icon: Icons.password,
      controller: confirm ? confirmPassController : passwordController,
      hintText: 'password',
      obscureText: true,
      validator: (value) {
        if (confirm && passwordController.text != confirmPassController.text) {
          return 'passwords do not match';
        } else if (value?.isEmpty ?? false) {
          return 'passwords should contain stuff';
        }

        return null;
      },
    );
  }
}
