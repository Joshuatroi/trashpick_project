// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;
g
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
      print('🔵 [AUTH] Step 1: Attempting to sign in');
      print('   Email: $email');
      print('   Selected userType: $userType');

      // 1. Authenticate with Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        print('🔴 [AUTH] Step 2: User is null after authentication');
        throw FirebaseAuthException(code: 'user-not-found');
      }

      print('🟢 [AUTH] Step 2: Firebase Auth successful');
      print('   User UID: ${user.uid}');

      // 2. Authorize from Firestore IMMEDIATELY
      print('🔵 [AUTH] Step 3: Fetching user document from Firestore...');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      print('🔵 [AUTH] Step 4: Firestore query completed');
      print('   Document exists: ${userDoc.exists}');

      if (!userDoc.exists) {
        print('🔴 [AUTH] Step 5: User document does NOT exist in Firestore');
        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'user-data-not-found',
          message: 'User data not found. Please contact support.',
        );
      }

      print('🟢 [AUTH] Step 5: User document exists in Firestore');

      final userData = userDoc.data();
      print('   Full user data: $userData');

      final dbUserType = userData?['userType'];
      print('   Database userType: "$dbUserType" (type: ${dbUserType.runtimeType})');
      print('   Selected userType: "$userType" (type: ${userType.runtimeType})');

      // 3. Compare roles
      print('🔵 [AUTH] Step 6: Comparing roles...');
      if (dbUserType != userType) {
        print('🔴 [AUTH] Step 7: ROLE MISMATCH!');
        print('   Expected: "$userType"');
        print('   Found in DB: "$dbUserType"');
        print('   Signing user out...');

        await _firebaseAuth.signOut();
        throw FirebaseAuthException(
          code: 'wrong-role',
          message: "Access Denied. You are registered as a '$dbUserType', not a '$userType'.",
        );
      }

      print('🟢 [AUTH] Step 7: Role matches! Login successful.');
      print('   ✅ User authenticated and authorized as $userType');

    } on FirebaseAuthException catch (e) {
      print('🔴 [AUTH] FirebaseAuthException caught: ${e.code}');
      print('   Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('🔴 [AUTH] Unexpected error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}