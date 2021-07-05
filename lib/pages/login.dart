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
      child: Scaffold(
        backgroundColor: assassinDarkestBlue,
        body: Padding(
          padding: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        _buildLogo(context),
                        Column(
                          children: [
                            _buildEmailForm(),
                            const SizedBox(height: 20),
                            _buildPasswordForm(),
                            _buildForgotPassword(context),
                            _buildLoginButton(context, auth),
                            const SizedBox(height: 20),
                            _buildSocialLoginButtons(context, auth),
                          ],
                        ),
                        _buildRegisterButton(context),
                        DebugRoutes(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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

  Widget _buildForgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Forgot password?',
        style: DefaultTextStyle.of(context).style.copyWith(
              color: assassinLightBlue,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: RichText(
        text: TextSpan(
          text: 'Don’t have an account? ',
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(color: assassinLightBlue),
          children: [
            TextSpan(
              text: 'Sign up!',
              style: TextStyle(
                color: assassinRed,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, FirebaseAuth auth) {
    return AssassinConfirmButton(
      text: 'LOGIN',
      minWidth: MediaQuery.of(context).size.width / 2,
      onPressed: () async {
        FocusScope.of(context).unfocus();

        if (_formKey.currentState!.validate()) {
          try {
            final userCredential = await auth.signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(userCredential.toString())),
            );
          } on FirebaseAuthException catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Failed')),
            );
          }
        }
      },
    );
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

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width / 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Image.asset('assets/assassin_logo.png'),
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
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: assassinBlue,
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
            width: double.infinity,
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
