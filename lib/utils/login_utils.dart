// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
Future<UserCredential?> signInWithGoogle(auth) async {
  try {
    final googleAccount = await _googleSignIn.signIn();

    if (googleAccount != null) {
      final googleSignInAuthentication = await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await auth.signInWithCredential(credential);
    } else {
      print('null google account sign in');
    }
  } catch (error) {
    print(error);
  }

  return null;
}
