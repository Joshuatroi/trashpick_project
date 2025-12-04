import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String id;
  final String title;
  final String status;
  final String locationAddress;
  final String description;
  final String submittedBy;
  final DateTime submittedAt;
  final String? imageUrl;
  final String? response;

  Report({
    required this.id,
    required this.title,
    required this.status,
    required this.locationAddress,
    required this.description,
    required this.submittedBy,
    required this.submittedAt,
    this.imageUrl,
    this.response,
  });

  factory Report.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Report(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      status: data['status'] ?? 'Unknown',
      locationAddress: data['locationAddress'] ?? 'No Address',
      description: data['description'] ?? 'No Description',
      submittedBy: data['submittedBy'] ?? 'Anonymous',
      submittedAt: (data['submittedAt'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      response: data['response'],
    );
  }
}
