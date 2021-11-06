import 'package:assassin_client/pages/game_joining/configure_lobby.dart';
import 'package:assassin_client/pages/homepage/join_game.dart';
import 'package:assassin_client/pages/game_joining/join_lobby.dart';
import 'package:assassin_client/pages/homepage/homepage.dart';
import 'package:assassin_client/pages/homepage/report_bug.dart';
import 'package:assassin_client/pages/login.dart';
import 'package:assassin_client/pages/register.dart';
import 'package:flutter/material.dart';

class LoginRoute extends StatelessWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => LoginPage();
}

class RegisterRoute extends StatelessWidget {
  const RegisterRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => RegisterPage();
}

class ReportBugRoute extends StatelessWidget {
  const ReportBugRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ReportBugPage();
}

class HomePageRoute extends StatelessWidget {
  const HomePageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => HomepagePage();
}

class JoinGameRoute extends StatelessWidget {
  const JoinGameRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => JoinGamePage();
}

class JoinLobbyRoute extends StatelessWidget {
  const JoinLobbyRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => JoinLobbyPage();
}

class ConfigureLobbyRoute extends StatelessWidget {
  const ConfigureLobbyRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ConfigureLobbyPage();
}
