// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/pages/edit_profile.dart';
import 'package:assassin_client/pages/game_joining/configure_lobby.dart';
import 'package:assassin_client/pages/game_joining/game_lobby.dart';
import 'package:assassin_client/pages/game_joining/join_game.dart';
import 'package:assassin_client/pages/game_joining/join_lobby.dart';
import 'package:assassin_client/pages/game_settings.dart';
import 'package:assassin_client/pages/homepage/game_top.dart';
import 'package:assassin_client/pages/homepage/homepage.dart';
import 'package:assassin_client/pages/homepage/report_bug.dart';
import 'package:assassin_client/pages/homepage/target.dart';
import 'package:assassin_client/pages/login.dart';
import 'package:assassin_client/pages/register.dart';
import 'package:assassin_client/pages/test_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AssassinApp()));
}

final routes = {
  '/login': (context) => LoginRoute(),
  '/register': (context) => RegisterRoute(),
  '/homepage': (context) => HomePage(),
  '/target': (context) => TestRoute(),
  '/edit-profile': (context) => const EditProfileRoute(),
  '/homepage/target': (context) => const TargetRoute(),
  '/homepage/game': (context) => GameRoute(),
  '/homepage/report': (context) => const TargetRoute(),
  '/homepage/report-bug': (context) => const ReportBugRoute(),
  '/homepage/profile': (context) => const EditProfileRoute(),
  '/homepage/joingame': (context) => const JoinGameRoute(),
  '/homepage/joingame/configure-lobby': (context) => ConfigureLobbyRoute(),
  '/homepage/joingame/join-lobby': (context) => JoinLobbyRoute(),
  '/homepage/gamelobby': (context) => GameLobbyRoute(),
  '/homepage/settings': (context) => GameSettingsRoute(),
};

final firebaseProvider = FutureProvider<FirebaseApp>(
  (ref) async => await Firebase.initializeApp(),
);

class AssassinApp extends ConsumerWidget {
  const AssassinApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebase = watch(firebaseProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: _buildTheme(),
      debugShowCheckedModeBanner: false,
      home: firebase.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading Firebase')),
        data: (firebase) => LoginRoute(),
      ),
      routes: routes,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Open Sans',
      textTheme: TextTheme(
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
