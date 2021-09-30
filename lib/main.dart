// Flutter imports:
import 'package:assassin_client/pages/homepage/report_bug.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

// Project imports:
import 'package:assassin_client/pages/edit_profile.dart';
import 'package:assassin_client/pages/game_joining/configure_lobby.dart';
import 'package:assassin_client/pages/game_joining/game_lobby.dart';
import 'package:assassin_client/pages/game_joining/join_game.dart';
import 'package:assassin_client/pages/game_joining/join_lobby.dart';
import 'package:assassin_client/pages/homepage/homepage.dart';
import 'package:assassin_client/pages/login.dart';
import 'package:assassin_client/pages/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //TODO: check without internet

  runApp(const ProviderScope(child: AssassinApp()));
}

final Map<String, Widget> routes = {
  '/': const LoginRoute(),
  '/register': const RegisterRoute(),
  '/homepage': const HomePageRoute(),
  '/homepage/report_bug': const ReportBugRoute(),
  '/homepage/join-game': const JoinGameRoute(),
  '/homepage/join-game/join-lobby': const JoinLobbyRoute(), //TODO: ??
  '/homepage/join-game/configure-lobby': ConfigureLobbyRoute(),
  '/homepage/join-game/lobby': const GameLobbyRoute(),
  '/edit-profile': const EditProfileRoute(),
};

final firebaseProvider = FutureProvider<FirebaseApp>(
  (ref) async => await Firebase.initializeApp(),
);

class AssassinApp extends ConsumerWidget {
  const AssassinApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _buildTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) => PageTransition(
        //TODO: error handling
        child: routes[settings.name]!,

        type: PageTransitionType.fade,
        alignment: Alignment.center,
        reverseDuration: const Duration(milliseconds: 400),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        settings: settings,
      ),
    );
  }

  ThemeData _buildTheme(context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      primarySwatch: Colors.blue,
      fontFamily: 'Open Sans',
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w800),
        bodyText1: TextStyle(fontSize: 18.0),
        bodyText2: TextStyle(fontSize: 14.0),
        button: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
        headline5: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900),
      ),
    );
  }
}
