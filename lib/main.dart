// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:assassin_client/pages/edit_profile.dart';
import 'package:assassin_client/pages/target.dart';
import 'package:assassin_client/widgets/password.dart';

void main() {
  runApp(const ProviderScope(child: AssassinApp()));
}

final routes = {
  '/target': (context) => const TargetRoute(),
  '/edit-profile': (context) => const EditProfileRoute(),
};

class AssassinApp extends StatelessWidget {
  const AssassinApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
      routes: routes,
    );
  }
}

class Homepage extends StatelessWidget {
  final String title = "ASSASSIN APP";
  final _formKey = GlobalKey<FormState>();
  Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("ASSASIN LOGIN PAGE"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DebugRoutes(),
                  Image.asset("assets/logo.jpg"),
                  const SizedBox(height: 25),
                  TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'Email should contain stuff';
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: 'Mario Rossi'),
                  ),
                  PasswordToggleField(
                    hint: "Password",
                    validator: (value) {
                      if (value?.isEmpty ?? false) {
                        return 'passowrd should contain stuff';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')));
                          await Future.delayed(const Duration(seconds: 2));
                          Navigator.pushNamed(context, '/target');
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
              child: Text(route),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ),
      ],
    );
  }
}
