import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String id;
  final String scheduleName;
  final String location;
  final String wasteType;
  final DateTime date;
  final String timePeriod;
  final String status;
  final String createdBy;
  final String barangayName;

  Schedule({
    required this.id,
    required this.scheduleName,
    required this.location,
    required this.wasteType,
    required this.date,
    required this.timePeriod,
    required this.status,
    required this.createdBy,
    required this.barangayName,
  });

  factory Schedule.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Schedule(
      id: doc.id,
      scheduleName: data['scheduleName'] ?? 'Untitled',
      location: data['location'] ?? 'No Location',
      wasteType: data['wasteType'] ?? 'N/A',
      date: (data['date'] as Timestamp).toDate(),
      timePeriod: data['timePeriod'] ?? 'N/A',
      status: data['status'] ?? 'Unknown',
      createdBy: data['createdBy'] ?? 'Unknown',
      barangayName: data['barangayName'] ?? 'Unknown',
    );
  }
}
