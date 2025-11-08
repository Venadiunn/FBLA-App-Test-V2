import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  Stream<fb.User?> get authStateChanges => _auth.authStateChanges();

  Future<void> init() async {
    // Initialize GoogleSignIn singleton (required by google_sign_in >=7)
    await GoogleSignIn.instance.initialize();
  }

  // Email/password
  Future<fb.UserCredential> signUpWithEmail(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<fb.UserCredential> signInWithEmail(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Google sign-in (Android/iOS/web)
  Future<fb.UserCredential?> signInWithGoogle() async {
    try {
      // authenticate() starts an interactive sign-in flow and returns an
      // authenticated account on success. It throws a GoogleSignInException
      // for failures (including cancellation), so we catch cancellation codes
      // and return null to preserve the previous behavior.
      final googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: const <String>['email', 'profile'],
      );
      final googleAuth = googleUser.authentication;
      // New google_sign_in returns an authentication object that currently
      // contains only an idToken. Pass the idToken to Firebase; accessToken
      // may not be available from this API surface.
      final credential = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on Exception catch (e) {
      // If the exception is a GoogleSignInException with a cancellation-like
      // code, treat it as user-aborted and return null. Otherwise rethrow.
      if (e is GoogleSignInException) {
        final code = e.code;
        if (code == GoogleSignInExceptionCode.canceled ||
            code == GoogleSignInExceptionCode.interrupted ||
            code == GoogleSignInExceptionCode.uiUnavailable) {
          return null;
        }
      }
      rethrow;
    }
  }

  // Apple sign-in (iOS/macOS)
  Future<fb.UserCredential?> signInWithApple() async {
    // Note: sign_in_with_apple setup required in Xcode with capabilities
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = fb.OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
    return await _auth.signInWithCredential(oauthCredential);
  }
}
