import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditOfficialProfilePage extends StatefulWidget {
  final String currentName;
  final String currentRole;
  final String currentJoin;
  final XFile? currentImage;

  const EditOfficialProfilePage({
    super.key,
    required this.currentName,
    required this.currentRole,
    required this.currentJoin,
    this.currentImage,
  });

  @override
  State<EditOfficialProfilePage> createState() =>
      _EditOfficialProfilePageState();
}

class _EditOfficialProfilePageState extends State<EditOfficialProfilePage> {
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController joinController;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    roleController = TextEditingController(text: widget.currentRole);
    joinController = TextEditingController(text: widget.currentJoin);
    _imageFile = widget.currentImage;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    setState(() => _imageFile = picked);
  }

  void saveProfile() {
    Navigator.pop(context, {
      'name': nameController.text,
      'role': roleController.text,
      'joined': joinController.text,
      'image': _imageFile,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
            _buildTextField("Name", nameController),
            const SizedBox(height: 12),
            _buildTextField("Role", roleController),
            const SizedBox(height: 12),
            _buildTextField("Joined", joinController),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CC961),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(
                  color: Color(0xFF0D1C12),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFE8F2ED),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
