import 'package:flutter/material.dart';
// You can replace these imports with your actual Home and Schedule pages
// e.g., import 'home_page.dart'; import 'schedule_page.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    final feedback = _feedbackController.text.trim();

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback.")),
      );
      return;
    }

    // Simulate sending feedback (can integrate Firebase later)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );

    _feedbackController.clear();
  }

  // ... (rest of the class before build method remains the same)

  @override
  Widget build(BuildContext context) {
    // Use a fixed height or a proportional height for the feedback box
    final screenHeight = MediaQuery.of(context).size.height;
    final feedbackBoxHeight =
        screenHeight * 0.3; // Example: 30% of screen height

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
          "Feedback",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 👇 FIX APPLIED HERE: Replace Expanded with a Container/SizedBox for a defined height
            Container(
              height: feedbackBoxHeight, // Use the calculated height
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _feedbackController,
                // Since height is fixed, we can remove expands: true
                maxLines: null, // Allow multiple lines
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "Enter your feedback or suggestions",
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.all(
                    16,
                  ), // Add padding inside
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE8F2ED),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Submit button
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CC961),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit",
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
