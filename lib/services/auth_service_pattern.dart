import 'package:firebase_auth/firebase_auth.dart';
import 'package:module_provider/module_provider.dart';

abstract class AuthServicePattern extends Service {
  final FirebaseAuth auth = FirebaseAuth.instance;
  get googleSignIn => null;

  FirebaseUser _firebaseUser;
  FirebaseUser get firebaseUser => _firebaseUser;

  AuthServicePattern(Module module) : super(module);

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
      AuthResult authResult = await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      ));

      _firebaseUser = authResult.user;
      return _firebaseUser;
    }
    
    return null;
  }

  signOut() async {
    await auth.signOut();
  }

  @override
  void dispose() {
    super.dispose();
  }
}