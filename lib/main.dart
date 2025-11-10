import 'package:flutter/material.dart';
import 'package:trashpick_project/screens/landing_page.dart';
import 'package:trashpick_project/screens/admin_dashboard.dart'; // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Clean white and green color palette
    const Color primaryGreen = Color(0xFF00A651); // main green
    const Color lightGreen = Color(0xFFB8E6D0); // light mint green
    const Color surfaceWhite = Color(0xFFFFFFFF); // white surface
    const Color textDark = Color(0xFF212121); // dark text
    const Color textGrey = Color(0xFF757575); // grey text

    return MaterialApp(
      title: 'TrashPick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryGreen,
          onPrimary: Colors.white,
          secondary: lightGreen,
          onSecondary: textDark,
          error: Colors.red,
          onError: Colors.white,
          surface: surfaceWhite,
          onSurface: textDark,
        ),
        scaffoldBackgroundColor: surfaceWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceWhite,
          foregroundColor: primaryGreen,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: primaryGreen),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            elevation: 3,
            shadowColor: primaryGreen.withValues(alpha: 0.3),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryGreen,
            side: const BorderSide(color: primaryGreen, width: 2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primaryGreen),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
          labelStyle: const TextStyle(color: textGrey),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: textDark, fontSize: 16),
          bodyMedium: TextStyle(color: textGrey, fontSize: 14),
          titleLarge: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleMedium: TextStyle(
            color: textDark,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: primaryGreen, size: 24),
        cardTheme: CardThemeData(
          color: surfaceWhite,
          elevation: 2,
          shadowColor: Colors.grey.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        useMaterial3: true,
      ),
      home: const LandingPageWithAdminButton(),
    );
  }
}

// Wrapper to add temporary admin button to landing page
class LandingPageWithAdminButton extends StatelessWidget {
  const LandingPageWithAdminButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LandingPage(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
        },
        backgroundColor: const Color(0xFF00A651),
        icon: const Icon(Icons.admin_panel_settings),
        label: const Text(
          'Admin',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
