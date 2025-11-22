import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WasteReportingPage extends StatefulWidget {
  const WasteReportingPage({super.key});

  @override
  State<WasteReportingPage> createState() => _WasteReportingPageState();
}

class _WasteReportingPageState extends State<WasteReportingPage> {
  final TextEditingController issueController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  XFile? imageFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    setState(() => imageFile = picked);
  }

  // Detect current GPS location
  Future<void> detectCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if GPS is on
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location services.")),
      );
      return;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permissions are permanently denied."),
        ),
      );
      return;
    }

    // Get coordinates
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];
    String address =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";

    setState(() {
      locationController.text = address;
    });
  }

  void submitReport() {
    if (issueController.text.isEmpty ||
        locationController.text.isEmpty ||
        imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted successfully!")),
    );

    issueController.clear();
    locationController.clear();
    setState(() => imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFA),

      // ✅ APP BAR WITH BACK ARROW
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFA),
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black87),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          "Report Issue",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Issue description
            TextField(
              controller: issueController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Describe Issue",
                filled: true,
                fillColor: const Color(0xFFE8F2ED),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Location field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: "Enter or detect location",
                        hintStyle: TextStyle(color: Color(0xFF4F946B)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.my_location,
                      color: Color(0xFF0D1C12),
                    ),
                    onPressed: detectCurrentLocation,
                    tooltip: "Detect Current Location",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Image upload
            Center(
              child: Column(
                children: [
                  imageFile == null
                      ? Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F2ED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              "No image selected",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imageFile!.path),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.photo, color: Color(0xFF0D1C12)),
                    label: const Text(
                      "Upload Photo",
                      style: TextStyle(color: Color(0xFF0D1C12)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F2ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Submit button
            ElevatedButton(
              onPressed: submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CC961),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit Report",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1C12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
