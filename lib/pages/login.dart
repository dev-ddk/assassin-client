// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:assassin_client/widgets/template_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedantic/pedantic.dart';

// Project imports:
import 'package:assassin_client/colors.dart';
import 'package:assassin_client/main.dart';
import 'package:assassin_client/providers/providers.dart';
import 'package:assassin_client/utils/login_utils.dart';
import 'package:assassin_client/widgets/user_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TemplatePage(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBody(),
          _buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        const Logo(),
        const SizedBox(height: 40),
        const LoginForm(),
        const SizedBox(height: 40),
        _buildSocialLoginButtons(),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildSocialLoginButtons() {
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

  Widget _buildRegisterButton(context) {
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
          Text('Don’t have an account? ', style: style1),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/register'),
            child: Text('Sign up!', style: style2),
          ),
        ],
      ),
    );
  }
}

class Logo extends StatefulWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  bool _showRoutes = false;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.bodyText2!.copyWith(color: assassinBlue);

    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            setState(() => _showRoutes = !_showRoutes && kDebugMode);
          },
          child: !_showRoutes ? _buildLogo() : const DebugRoutes(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('by /dev/ddk', style: style),
        )
      ],
    );
  }

  Widget _buildLogo() {
    final size = MediaQuery.of(context).size;
    final borderRadius = BorderRadius.circular(size.width / 4);

    return Material(
      elevation: 10,
      borderRadius: borderRadius,
      child: Container(
        width: size.width / 2,
        height: size.width / 2,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: assassinBlue,
        ),
        child: SvgPicture.asset('assets/assassin_logo.svg'),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _attemptingLogin = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            _buildEmailForm(),
            _buildPasswordForm(),
            _buildForgotPassword(context),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Future<void> _doLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _attemptingLogin = true);

      // Unfocus the keyboard when we start the login process
      FocusManager.instance.primaryFocus?.unfocus();

      final userCredential = await login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      await userCredential.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            //TODO: differentiate with network problem vs invalid credentials
            const SnackBar(content: Text('Login Failed')),
          );
        },
        (loginData) async {
          unawaited(Navigator.popAndPushNamed(context, '/homepage'));
          unawaited(context.read(userViewCntrl).updateState());

          // starts polling for game updates
          //context.read(gameUpdater).start();

          print(await FirebaseAuth.instance.currentUser!.getIdToken());
        },
      );
    }

    setState(() => _attemptingLogin = false);
  }

  Widget _buildLoginButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AssassinConfirmButton(
        text: 'LOGIN',
        heroTag: 'ASSASSIN',
        backgroundColor: _attemptingLogin ? assassinDarkBlue : assassinWhite,
        onPressed: _doLogin,
      ),
    );
  }

  Widget _buildEmailForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AssassinFormField(
        icon: Icons.mail,
        controller: _emailController,
        validator: emailValidator,
        hintText: 'mario.rossi@example.com',
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AssassinFormField(
        icon: Icons.password,
        controller: _passwordController,
        validator: passwordValidator,
        hintText: 'password',
        obscureText: true,
      ),
    );
  }

  Widget _buildForgotPassword(context) {
    final style = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: assassinBlue, decoration: TextDecoration.underline);

    return TextButton(
      onPressed: () {}, //TODO
      child: Text('Forgot password?', style: style),
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
        onPressed: null,
        elevation: 2.0,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(15.0),
        shape: const CircleBorder(),
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
    final style = Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 12);

    return Column(
      children: [
        for (final route in routes.keys)
          Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, route),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(route, style: style),
            ),
          ),
      ],
    );
  }
}
