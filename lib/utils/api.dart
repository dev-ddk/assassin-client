// Package imports:
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:assassin_client/utils/login_utils.dart';

const api_url = 'https://dev.devddk.it/v1/';

String? bearerToken;

final FirebaseAuth _auth = FirebaseAuth.instance;

// final _dio = Dio();

// Future<UserCredential?> login(String email, String password) async {
//   try {
//     final userCredential = await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     return userCredential;
//   } on FirebaseAuthException catch (_) {}

//   return null;
// }

//owo.owi@test.com
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
