import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ResidentProfilePage extends StatefulWidget {
  const ResidentProfilePage({super.key});

  @override
  State<ResidentProfilePage> createState() => _ResidentProfilePageState();
}

class _ResidentProfilePageState extends State<ResidentProfilePage> {
  XFile? _imageFile;

  final String name = "Maria Santos";
  final String role = "Resident";
  final String joined = "Joined 2023";
  final TextEditingController emailController = TextEditingController(
    text: "maria.santos@email.com",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "+63 917 123 4567",
  );
  final TextEditingController addressController = TextEditingController(
    text: "123 Main St, Barangay 176, Manila",
  );

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    setState(() => _imageFile = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Account",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Profile Picture
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFFE8F2ED),
                backgroundImage: _imageFile != null
                    ? FileImage(File(_imageFile!.path))
                    : null,
                child: _imageFile == null
                    ? const Icon(Icons.person, size: 48, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            // Name and role
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1C12),
              ),
            ),
            Text(
              role,
              style: const TextStyle(fontSize: 16, color: Color(0xFF4F946B)),
            ),
            Text(
              joined,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Account Information Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Account Information",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildEditableField("Email", emailController, Icons.email),
            _buildEditableField("Phone Number", phoneController, Icons.phone),
            _buildEditableField("Address", addressController, Icons.home),

            const SizedBox(height: 24),

            // Settings Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),

            _buildSettingsOption("Notifications"),
            _buildSettingsOption("Privacy Policy"),
            _buildSettingsOption("Terms of Service"),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Profile tab active
        selectedItemColor: const Color(0xFF1CC961),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_outlined),
            label: "Report",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // Editable Field Widget
  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  readOnly: true,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF4F946B),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: () {
              // Future: Make editable or open dialog
            },
          ),
        ],
      ),
    );
  }

  // Settings Option Widget
  Widget _buildSettingsOption(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("$title clicked")));
      },
    );
  }
}
