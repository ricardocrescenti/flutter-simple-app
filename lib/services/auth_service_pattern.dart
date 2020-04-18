import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

abstract class AuthServicePattern extends Service {
  final FirebaseAuth auth = FirebaseAuth.instance;
  get googleSignIn => null;

  FirebaseUser _firebaseUser;
  FirebaseUser get firebaseUser => _firebaseUser;

  UserInfo get userInfo => _firebaseUser?.providerData[_firebaseUser.providerData.length - 1];

  AuthServicePattern(Module module) : super(module);

  signInAnonimous() async {
    await auth.signInAnonymously();
    return await getCurrentFirebaseUser();
  }

  getCurrentFirebaseUser() async {
    _firebaseUser = await auth.currentUser();
    return _firebaseUser;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    if (googleSignIn == null) {
      throw Exception('Login with Google is not configured. Override the getGoogleSignIn method in AuthService.');
    }

    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuthentication = await googleAccount.authentication;

      AuthCredential authCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );

      AuthResult authResult;
      if (_firebaseUser != null && _firebaseUser.isAnonymous) {
        authResult = await _firebaseUser.linkWithCredential(authCredential);
        authResult.user.unlinkFromProvider('firebase');
      } else {
        authResult = await auth.signInWithCredential(authCredential);
      }

      return await getCurrentFirebaseUser();
    }
    
    return null;
  }

  @mustCallSuper
  Future signOut() async {
    await auth.signOut();
  }

  @override
  void dispose() {
    super.dispose();
  }
}