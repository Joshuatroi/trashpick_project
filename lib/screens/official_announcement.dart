import 'package:flutter/material.dart';

// A simple data class for holding announcement information
class Announcement {
  final String text;
  final String time;

  Announcement({required this.text, required this.time});
}

class OfficialAnnouncement extends StatefulWidget {
  const OfficialAnnouncement({super.key});

  @override
  State<OfficialAnnouncement> createState() => _OfficialAnnouncementState();
}

class _OfficialAnnouncementState extends State<OfficialAnnouncement> {
  final TextEditingController _announcementController = TextEditingController();
  final List<Announcement> _previousAnnouncements = [
    Announcement(text: 'Garbage collection for the North District will be delayed by one hour on Friday.', time: 'Posted 1 day ago'),
    Announcement(text: 'A special collection for e-waste will be held this Saturday. Please leave items on the curb by 8 AM.', time: 'Posted 3 days ago'),
  ];

  final Color primaryGreen = const Color(0xFF00A651);

  void _showConfirmationDialog() {
    if (_announcementController.text.isEmpty) return; // Don't show if empty

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Post Announcement?'),
          content: const Text('Are you sure you want to post this announcement to the public?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: _postAnnouncement,
              child: Text('Post', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _postAnnouncement() {
    setState(() {
      _previousAnnouncements.insert(
        0,
        Announcement(text: _announcementController.text, time: 'Posted just now'),
      );
      _announcementController.clear();
    });
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement posted successfully!'), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildCreateAnnouncementCard(),
        const SizedBox(height: 32),
        const Text(
          'Previous Announcements',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPreviousAnnouncementsList(),
      ],
    );
  }

  Widget _buildCreateAnnouncementCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: primaryGreen.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New Announcement:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _announcementController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type your announcement here...',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Submit Announcement', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousAnnouncementsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _previousAnnouncements.length,
      itemBuilder: (context, index) {
        final announcement = _previousAnnouncements[index];
        return Card(
          color: primaryGreen.withAlpha(26),
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            title: Text(announcement.text, style: const TextStyle(fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(announcement.time, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600])),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
