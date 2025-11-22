// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Import the service

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get an instance of the AuthService
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TrashPick'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            // Call the signOut method from the service
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to TrashPick!\nLogged in as: ${user?.email}',
           textAlign: TextAlign.center,
        ),
      ),
    );
  }
}