import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'edit_official_profile_page.dart';
import 'change_password_page.dart';
import 'package:trashpick_project/controller/theme_controller.dart';

class OfficialProfilePage extends StatefulWidget {
  const OfficialProfilePage({super.key});

  @override
  State<OfficialProfilePage> createState() => _OfficialProfilePageState();
}

class _OfficialProfilePageState extends State<OfficialProfilePage> {
  XFile? _imageFile;

  String name = "Ricardo Santos";
  String role = "Barangay Official";
  String joined = "Joined 2022";
  String language = "English";

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final bool isDarkMode = themeController.isDarkMode;

    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color secondaryTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[800]!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              backgroundColor: isDarkMode
                  ? const Color(0xFF2A2A2A)
                  : const Color(0xFFE8F2ED),
              backgroundImage: _imageFile != null
                  ? FileImage(File(_imageFile!.path))
                  : null,
              child: _imageFile == null
                  ? Icon(
                      Icons.person,
                      size: 48,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey,
                    )
                  : null,
            ),
            const SizedBox(height: 12),

            // Name and role
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              role,
              style: const TextStyle(fontSize: 16, color: Color(0xFF4F946B)),
            ),
            Text(joined, style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 28),

            // ACCOUNT SECTION
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Account",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildAccountTile(
              "Edit Profile",
              textColor,
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditOfficialProfilePage(
                      currentName: name,
                      currentRole: role,
                      currentJoin: joined,
                      currentImage: _imageFile,
                    ),
                  ),
                );

                if (updatedData != null) {
                  setState(() {
                    name = updatedData['name'];
                    role = updatedData['role'];
                    joined = updatedData['joined'];
                    _imageFile = updatedData['image'];
                  });
                }
              },
            ),
            _buildAccountTile(
              "Change Password",
              textColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ),
                );
              },
            ),
            _buildAccountTile(
              "Notifications",
              textColor,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notifications clicked")),
                );
              },
            ),

            const SizedBox(height: 28),

            // SETTINGS SECTION
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: secondaryTextColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingsRow("Language", "English", textColor, onTap: () {}),
            _buildSettingsRow(
              "Theme",
              isDarkMode ? "Dark" : "Light",
              textColor,
              onTap: () {
                themeController.toggleTheme();
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTile(
    String title,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSettingsRow(
    String title,
    String value,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontSize: 15, color: textColor)),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
      onTap: onTap,
    );
  }
}
