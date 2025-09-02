import 'package:firebase_auth/firebase_auth.dart';

/// Service class to handle all Firebase Authentication operations
class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  /// Returns UserCredential on success, throws FirebaseAuthException on failure
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Re-throw with more user-friendly error messages
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with this email address.',
          );
        case 'wrong-password':
          throw FirebaseAuthException(
            code: 'wrong-password',
            message: 'Incorrect password. Please try again.',
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'Please enter a valid email address.',
          );
        case 'user-disabled':
          throw FirebaseAuthException(
            code: 'user-disabled',
            message: 'This account has been disabled.',
          );
        case 'too-many-requests':
          throw FirebaseAuthException(
            code: 'too-many-requests',
            message: 'Too many failed attempts. Please try again later.',
          );
        default:
          throw FirebaseAuthException(
            code: e.code,
            message: 'An error occurred during sign in. Please try again.',
          );
      }
    }
  }

  /// Create a new user account with email and password
  /// Returns UserCredential on success, throws FirebaseAuthException on failure
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Re-throw with more user-friendly error messages
      switch (e.code) {
        case 'email-already-in-use':
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'An account with this email already exists.',
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'Please enter a valid email address.',
          );
        case 'operation-not-allowed':
          throw FirebaseAuthException(
            code: 'operation-not-allowed',
            message: 'Email/password accounts are not enabled.',
          );
        case 'weak-password':
          throw FirebaseAuthException(
            code: 'weak-password',
            message: 'Password is too weak. Please choose a stronger password.',
          );
        default:
          throw FirebaseAuthException(
            code: e.code,
            message: 'An error occurred during sign up. Please try again.',
          );
      }
    }
  }

  /// Send password reset email
  /// Returns void on success, throws FirebaseAuthException on failure
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      // Re-throw with more user-friendly error messages
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with this email address.',
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'Please enter a valid email address.',
          );
        default:
          throw FirebaseAuthException(
            code: e.code,
            message: 'An error occurred while sending reset email. Please try again.',
          );
      }
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user is currently signed in
  bool get isSignedIn => _auth.currentUser != null;
}
