// Package imports:
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'failures.dart';

final _auth = FirebaseAuth.instance;

var logger = Logger(printer: PrettyPrinter());

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
    return Left(
      AuthFailure.log(
        code: 'AUT-001',
        message: 'auth: login token is null',
        logger: logger,
        level: Level.error,
      ),
    );
  }
  dio.options.headers['authorization'] = 'Bearer ' + token;
  logger.i(token);
  return Right(dio);
}

Future<Either<Failure, UserCredential>> login(
    String email, String password) async {
  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return Right(userCredential);
  } on FirebaseAuthException catch (e) {
    return Left(
      AuthFailure.log(
        code: 'AUT-002',
        message: 'firebase: ${e.message}',
        logger: logger,
        level: Level.warning,
      ),
    );
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
      return Left(
        AuthFailure.log(
          code: 'AUT-003',
          message: 'google: account is null',
          logger: logger,
          level: Level.error,
        ),
      );
    }
  } catch (error) {
    return Left(
      AuthFailure.log(
        code: 'AUT-004',
        message: 'google: unknown error',
        logger: logger,
        level: Level.error,
      ),
    );
  }
}
