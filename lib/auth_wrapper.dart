// lib/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/official_dashboard.dart';
import 'screens/admin_dashboard.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          // User is logged out
          if (user == null) {
            return const LoginScreen();
          }

          // User is logged in, fetch role from Firestore
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, userDocSnapshot) {
              // Loading indicator while fetching
              if (userDocSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If user data doesn't exist, sign out
              if (!userDocSnapshot.hasData || !userDocSnapshot.data!.exists) {
                authService.signOut();
                return const LoginScreen();
              }

              // Get user role
              final userData = userDocSnapshot.data!.data() as Map<String, dynamic>;
              final role = userData['role'] ?? 'official'; // default to official if role missing

              // Route based on role (focusing on admin and official for now)
              if (role == 'official') {
                return const OfficialDashboard();
              } else if (role == 'admin') {
                return const AdminDashboard();
              } else {
                // Unknown or unsupported role
                return const Scaffold(
                  body: Center(child: Text('Access denied')),
                );
              }
            },
          );
        }

        // Waiting for auth connection
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
