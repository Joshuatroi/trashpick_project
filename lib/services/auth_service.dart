// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String userType,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'userType': userType,
          'createdAt': Timestamp.now(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required String userType,
  }) async {
    try {

      // 1. Authenticate with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-not-found');
      }

      // 2. Authorize from Firestore IMMEDIATELY
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'user-data-not-found',
          message: 'User data not found. Please contact support.',
        );
      }

      final userData = userDoc.data();

      final dbUserType = userData?['userType'];

      // 3. Compare roles
      if (dbUserType != userType) {

        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'wrong-role',
          message: "Access Denied. You are registered as a '$dbUserType', not a '$userType'.",
        );
      }

    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Get user profile data from Firestore
  /// Returns a Map with user data or null if not found
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) return null;

      // Merge Firestore data with auth data
      final data = userDoc.data() ?? {};
      data['email'] = user.email; // Always get email from Auth

      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile in Firestore
  /// Updates fullName and phone number
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is currently signed in',
        );
      }

      await _firestore.collection('users').doc(user.uid).update({
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'updatedAt': Timestamp.now(),
      });


    } catch (e) {
      rethrow;
    }
  }

  /// Change user password
  /// Requires reauthentication with current password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null || user.email == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is currently signed in',
        );
      }

      // Reauthenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      // Re-throw with more specific error messages
      switch (e.code) {
        case 'wrong-password':
          throw FirebaseAuthException(
            code: 'wrong-password',
            message: 'Current password is incorrect',
          );
        case 'weak-password':
          throw FirebaseAuthException(
            code: 'weak-password',
            message: 'New password is too weak',
          );
        case 'requires-recent-login':
          throw FirebaseAuthException(
            code: 'requires-recent-login',
            message: 'Please log out and log back in, then try again',
          );
        default:
          rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Stream of user profile data
  /// Useful for real-time updates in the UI
  Stream<Map<String, dynamic>?> getUserProfileStream() {
    final user = currentUser;
    if (user == null) return Stream.value(null);

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return null;

      final data = doc.data() ?? {};
      data['email'] = user.email;
      return data;
    });
  }

}