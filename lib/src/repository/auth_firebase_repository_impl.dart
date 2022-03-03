// import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:yodravet/src/model/user_dao.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/auth_repository.dart';

class AuthFirebaseRepositoryImpl implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  // final _analytics = new FirebaseAnalytics();

  @override
  Future<String> logIn(String email, String pass) async {
    if (kDebugMode) {
      print('Estoy en login en auth firebase auth: $_auth ,$email, $pass');
    }
    // final FirebaseUser user = (await _auth.signInWithEmailAndPassword
    // (email: email, password: pass)).user;
    UserCredential authResult;
    try {
      authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      String? message = e.message;
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        message = 'Correo incorrecto';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta';
      } else if (e.code == 'user-disabled') {
        message = 'Usuario inactivo';
      }

      throw message!;
    }

    if (kDebugMode) {
      print(
        'Estoy en login en auth con respuesta de '
            'firebase authResult= $authResult');
    }
    final User user = authResult.user!;
    if (kDebugMode) {
      print('Estoy en login en auth y tengo user= $user');
    }
    // _analytics.logSignUp(signUpMethod: 'AuthLogIn');
    if (kDebugMode) {
      print('Estoy en login en auth y he podido invocar a analytics');
    }
    return user.uid;
  }

  @override
  Future<UserDao> googleLogIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

    // Trigger the authentication flow
    // final GoogleSignInAccount googleUser =
    //     await (_googleSignIn.signIn() as FutureOr<GoogleSignInAccount>);

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    ) as GoogleAuthCredential;

    // Once signed in, return the UserCredential
    late UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithCredential(credential);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return TransformModel.raw2UserDao(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        name: userCredential.user!.displayName,
        lastname: '',
        photo: userCredential.user!.photoURL,
        isStravaLogin: false);
  }

  @override
  Future<UserDao> appleLogIn() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`,
    // sign in will fail.
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    return TransformModel.raw2UserDao(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        name: '${appleCredential.givenName!} ${appleCredential.familyName!}',
        // name: userCredential.user.displayName ?? 'Anónimo',
        lastname: '',
        photo: userCredential.user!.photoURL ?? '',
        isStravaLogin: false);
  }

  @override
  Future<bool> logOut() async {
    await _auth.signOut();

    return true;
  }

  @override
  Future<String?> isUserLoggedIn() async {
    if (kDebugMode) {
      print('Estoy en UserLoggedIn en firebase repository');
    }
    var user = _auth.currentUser;
    if (kDebugMode) {
      print('Salgo de UserLoggedIn en firebase repository');
    }
    return user?.uid;
  }

  @override
  Future<bool> changePassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);

    return true;
  }

  @override
  Future<String> createAuthUser(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
