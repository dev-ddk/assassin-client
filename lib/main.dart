// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/pages/edit_profile.dart';
import 'package:assassin_client/pages/game_top.dart';
import 'package:assassin_client/pages/logged_in.dart';
import 'package:assassin_client/pages/login.dart';
import 'package:assassin_client/pages/target.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: AssassinApp()));
}

final routes = {
  '/login': (context) => LoginRoute(),
  '/homepage': (context) => HomePage(),
  '/target': (context) => const TargetRoute(),
  '/edit-profile': (context) => const EditProfileRoute(),
  '/homepage/target': (context) => const TargetRoute(),
  '/homepage/game': (context) => const EditProfileRoute(),
  '/homepage/report': (context) => const TargetRoute(),
  '/homepage/profile': (context) => const EditProfileRoute(),
  '/game': (context) => GameRoute(),
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: firebase.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading Firebase')),
        data: (firebase) => LoginRoute(),
      ),
      routes: routes,
    );
  }
}
