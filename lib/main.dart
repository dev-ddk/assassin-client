// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/pages/edit_profile.dart';
import 'package:assassin_client/pages/homepage/homepage.dart';
import 'package:assassin_client/pages/login.dart';
import 'package:assassin_client/pages/register.dart';
import 'package:assassin_client/pages/test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: AssassinApp()));
}

final routes = {
  '/': (context) => const LoginRoute(),
  '/register': (context) => RegisterRoute(),
  '/homepage': (context) => HomePage(),
  '/target': (context) => TestRoute(),
  '/edit-profile': (context) => const EditProfileRoute(),
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
      theme: _buildTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
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
