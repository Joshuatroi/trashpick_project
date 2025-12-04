import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;

// Updated data class to match the Firestore 'announcements' collection
class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime postedAt;
  final String postedBy;
  final String barangayName;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.postedAt,
    required this.postedBy,
    required this.barangayName,
  });

  // Factory to create an Announcement from a Firestore document
  factory Announcement.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      postedAt: (data['postedAt'] as Timestamp).toDate(),
      postedBy: data['postedBy'] ?? 'Unknown',
      barangayName: data['barangayName'] ?? 'Unknown',
    );
  }
}

class OfficialAnnouncement extends StatefulWidget {
  const OfficialAnnouncement({super.key});

  @override
  State<OfficialAnnouncement> createState() => _OfficialAnnouncementState();
}

class _OfficialAnnouncementState extends State<OfficialAnnouncement> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color primaryGreen = const Color(0xFF00A651);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Rebuild the widget every minute to update the 'timeago' text
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Shows confirmation before posting
  void _showConfirmationDialog() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both title and content.')),
      );
      return;
    }

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
              onPressed: () {
                Navigator.of(context).pop(); // Close confirmation dialog
                _postAnnouncement();
              },
              child: Text('Post', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Saves the new announcement to Firestore
  Future<void> _postAnnouncement() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final announcementData = {
      'title': _titleController.text,
      'content': _contentController.text,
      'postedAt': Timestamp.now(),
      'postedBy': currentUser?.displayName ?? currentUser?.email ?? 'Official',
      'barangayName': 'Pardo',
    };

    try {
      await _firestore.collection('announcements').add(announcementData);
      _titleController.clear();
      _contentController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement posted successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post announcement: $e')),
      );
    }
  }
  
  // Shows the full announcement and delete option in a dialog
  void _showAnnouncementDetails(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(announcement.content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close details dialog first
              _showDeleteConfirmation(announcement.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Shows confirmation before deleting an announcement
  Future<void> _showDeleteConfirmation(String announcementId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this announcement?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _firestore.collection('announcements').doc(announcementId).delete();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    _titleController.dispose();
    _contentController.dispose();
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
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter the title...',
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type your announcement content here...',
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore.collection('announcements').orderBy('postedAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No announcements yet.'));
        }

        final announcements = snapshot.data!.docs.map((doc) => Announcement.fromFirestore(doc)).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final announcement = announcements[index];
            return Card(
              color: primaryGreen.withAlpha(26),
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                onTap: () => _showAnnouncementDetails(announcement),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    announcement.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
                trailing: Text(
                  timeago.format(announcement.postedAt),
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600], fontSize: 12),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
