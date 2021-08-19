// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Project imports:
import 'failures.dart';

final String? Function(dynamic) emailValidator = (value) {
  if (value?.isEmpty) {
    return 'email must not be empty';
  }
  return EmailValidator.validate(value) ? null : 'invalid email';
};

final passwordValidator =
    (value) => value?.isEmpty ? 'password must not be empty' : null;

final _auth = FirebaseAuth.instance;

final _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

BaseOptions baseOptions({contentType = 'application/json'}) {
  return BaseOptions(
    baseUrl: 'https://dev.devddk.it/v1/',
    contentType: contentType,
    connectTimeout: 7500,
  );
}

Future<Either<Failure, Dio>> authenticateRequest(Dio dio) async {
  final token = await _auth.currentUser?.getIdToken();

  if (token == null) {
    return Left(AuthFailure());
  }

  dio.options.headers['authorization'] = 'Bearer ' + token;

  return Right(dio);
}

Future<Either<Failure, UserCredential>> login(
  String email,
  String password,
) async {
  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return Right(userCredential);
  } on FirebaseAuthException {
    return Left(AuthFailure());
  }
}

Future<Either<Failure, UserCredential>> registerr(
  String email,
  String password,
) async {
  try {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final dio = Dio(baseOptions());

    //TODO: handle the case of an user registered on firebase but not on backend
    //(this can happen if backend is down and the registration is done on firebase
    await authenticateRequest(dio)
        .thenRight((right) => _registerOnBackend(dio, email));

    return Right(userCredential);
  } on FirebaseAuthException catch (_) {
    //TODO: differentiate Register failure based on error
    return Left(RegisterFailure());
  }
}

Future<Either<Failure, String>> _registerOnBackend(
  Dio dio,
  String nickname,
) async {
  final response = await dio.post('register', data: {'nickname': nickname});

  if (response.statusCode == 201) {
    return Right(response.toString());
  } else if (response.statusCode != null) {
    return Left(RequestFailure());
  } else {
    return Left(NetworkFailure());
  }
}

Future<Either<Failure, UserCredential>> signInWithGoogle(auth) async {
  try {
    final googleAccount = await _googleSignIn.signIn();

    if (googleAccount != null) {
      final googleSignInAuthentication = await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return Right(await auth.signInWithCredential(credential));
    } else {
      return Left(AuthFailure());
    }
  } catch (error) {
    return Left(AuthFailure());
  }
}
