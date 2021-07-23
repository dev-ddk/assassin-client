// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/main.dart';
import 'package:assassin_client/widgets/buttons.dart';
import 'package:assassin_client/widgets/form_fields.dart';

class LoginRoute extends StatelessWidget {
  LoginRoute({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Scaffold(
          backgroundColor: assassinDarkestBlue,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: _buildBody(constraints, context, auth),
                      ),
                    ),
                    _buildRegisterButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildBody(constraints, context, auth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLogo(context, constraints.maxWidth),
            DebugRoutes(),
          ],
        ),
        const SizedBox(height: 60),
        _buildEmailForm(),
        const SizedBox(height: 20),
        _buildPasswordForm(),
        _buildForgotPassword(context),
        _buildLoginButton(context, auth, constraints.minWidth),
        const SizedBox(height: 20),
        _buildSocialLoginButtons(context, auth),
        const SizedBox(height: 20),
      ],
    );
  }

  Row _buildSocialLoginButtons(context, auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          icon: FontAwesomeIcons.google,
          onPressed: () {},
        ),
        SocialLoginButton(
          icon: FontAwesomeIcons.facebook,
          onPressed: () {},
        ),
        SocialLoginButton(
          icon: FontAwesomeIcons.twitter,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildForgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Forgot password?',
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: assassinBlue,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }

  Widget _buildRegisterButton(context) {
    return Positioned(
      bottom: 10,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don’t have an account? ',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: assassinLightBlue,
                ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Sign up!',
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

  Widget _buildLoginButton(context, auth, width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AssassinConfirmButton(
        text: 'LOGIN',
        onPressed: () async {
          FocusManager.instance.primaryFocus?.unfocus();

          final login = await _doLogin(auth, context);

          final displayContent = login?.toString() ?? 'Login Failed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(displayContent)),
          );

          if (login != null) {
            await Navigator.pushNamed(context, '/homepage');
          }
        },
      ),
    );
  }

  Future<UserCredential?> _doLogin(FirebaseAuth auth, context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
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

  Widget _buildPasswordForm() {
    return AssassinFormField(
      icon: Icons.password,
      controller: passwordController,
      hintText: 'password',
      obscureText: true,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return 'password should contain stuff';
        }
        return null;
      },
    );
  }

  Widget _buildLogo(context, width) {
    return Column(
      children: [
        Container(
          width: width / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width / 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Image.asset('assets/assassin_logo.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'by /dev/ddk',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: assassinBlue),
          ),
        )
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawMaterialButton(
        onPressed: () {},
        elevation: 2.0,
        fillColor: Colors.white,
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
        child: FaIcon(icon, color: assassinDarkBlue),
      ),
    );
  }
}

class DebugRoutes extends StatelessWidget {
  const DebugRoutes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final route in routes.keys)
          Container(
            width: 150,
            height: 24,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, route),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(route),
            ),
          ),
      ],
    );
  }
}
