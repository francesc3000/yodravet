// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yodravet/src/model/user_dao.dart';
import 'package:yodravet/src/shared/transform_model.dart';

import 'interface/auth_repository.dart';

class AuthFirebaseRepositoryImpl implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  // final _analytics = new FirebaseAnalytics();

  @override
  Future<String> logIn(String email, String pass) async {
    print('Estoy en login en auth firebase auth: $_auth ,$email, $pass');
    // final FirebaseUser user = (await _auth.signInWithEmailAndPassword(email: email, password: pass)).user;
    UserCredential authResult;
    try {
      authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      String message = e.message;
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        message = 'Correo incorrecto';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta';
      } else if (e.code == 'user-disabled') {
        message = 'Usuario inactivo';
      }

      throw message;
    }

    print(
        'Estoy en login en auth con respuesta de firebase authResult= $authResult');
    final User user = authResult.user;
    print('Estoy en login en auth y tengo user= $user');
    // _analytics.logSignUp(signUpMethod: 'AuthLogIn');
    print('Estoy en login en auth y he podido invocar a analytics');
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
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential;
    try {
     userCredential =
        await _auth.signInWithCredential(credential); 
    } catch (error) {
      print(error);
    }

    return TransformModel.raw2UserDao(
        id: userCredential.user.uid,
        email: userCredential.user.email,
        name: userCredential.user.displayName,
        lastname: '',
        photo: userCredential.user.photoURL,
        isStravaLogin: false);
  }

  @override
  Future<bool> logOut() async {
    await _auth.signOut();

    return true;
  }

  @override
  Future<String> isUserLoggedIn() async {
    print('Estoy en UserLoggedIn en firebase repository');
    var user = _auth.currentUser;
    print('Salgo de UserLoggedIn en firebase repository');
    return user?.uid ?? null;
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
    return userCredential.user.uid;
  }
}
