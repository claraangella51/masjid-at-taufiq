import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? user;
  bool loading = false;

  static const adminEmail = "admin@masjid.com";

  bool get isLoggedIn => user != null;

  bool get isAdmin => user?.email == adminEmail;

  AuthProvider() {
    user = _auth.currentUser;
  }

  /// LOGIN EMAIL
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = cred.user;
      await user?.reload();
      user = _auth.currentUser;

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  ///REGISTER EMAIL
  Future<String?> registerUser(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      loading = true;
      notifyListeners();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = cred.user;

      /// simpan nama ke profile firebase
      await user!.updateDisplayName(name);

      /// reload supaya displayName langsung terbaca
      await user!.reload();
      user = _auth.currentUser;

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// LOGIN GOOGLE
  Future<String?> loginWithGoogle() async {
    try {
      loading = true;
      notifyListeners();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      user = userCredential.user;

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  //LUPA PASSWORD
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();

    user = null;

    notifyListeners();
  }
}
