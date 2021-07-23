// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestRoute extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (_) {}

    return null;
  }

  Future<UserCredential?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // _updateBearer(await _auth.currentUser?.getIdToken());
      print(await login(email, password));

      final token = await _auth.currentUser?.getIdToken();
      print(token);

      var dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['authorization'] = 'Bearer ' + token!;

      final result = await dio
          .post('https://dev.devddk.it/v1/register', data: {'nickname': email});

      print(result);

      return userCredential;
    } on FirebaseAuthException catch (ex) {
      print(ex);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TextButton(
      child: Text('AAA'),
      onPressed: () async {
        await register('gabi@bo.it', 'giuseppegiuseppe');
      },
    ));
  }
}
