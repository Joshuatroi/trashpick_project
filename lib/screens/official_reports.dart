import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trashpick_project/models/report.dart';

class OfficialReports extends StatefulWidget {
  const OfficialReports({super.key});

  @override
  State<OfficialReports> createState() => _OfficialReportsState();
}

class _OfficialReportsState extends State<OfficialReports> {
  Report? _selectedReport;
  final _responseController = TextEditingController();
  final Color primaryGreen = const Color(0xFF00A651);

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  // Function to fetch all reports, ordered by submission time
  Stream<List<Report>> _getReportsStream() {
    return FirebaseFirestore.instance
        .collection('reports')
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());
  }

  // Updates the selected report and pre-fills the response text field
  void _selectReport(Report? report) {
    setState(() {
      _selectedReport = report;
      if (report != null) {
        _responseController.text = report.response ?? '';
      } else {
        _responseController.clear();
      }
    });
  }

  // Handles the logic to update a report's status and response in Firestore
  Future<void> _updateReportStatus(Report report, String newStatus) async {
    final responseText = _responseController.text.trim();
    if (responseText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a response before updating the status.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reports').doc(report.id).update({
        'status': newStatus,
        'response': responseText,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report status updated to $newStatus')),
      );

      _selectReport(null); // Return to the list view after updating

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update report: $e')),
      );
    }
  }


  Color _getStatusColor(String status) {
    final lowercasedStatus = status.toLowerCase();
    if (lowercasedStatus.contains('pending')) {
      return Colors.orange.shade700;
    } else if (lowercasedStatus == 'resolved') {
      return primaryGreen;
    }
    return Colors.grey[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Report>>(
      stream: _getReportsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reports found.'));
        }

        final reports = snapshot.data!;
        
        // If a report is selected, show the detail view, otherwise show the list
        return _selectedReport == null
            ? _buildReportList(reports)
            : _buildReportDetailView(_selectedReport!);
      },
    );
  }

  Widget _buildReportList(List<Report> reports) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return GestureDetector(
          onTap: () => _selectReport(report),
          child: Card(
            color: primaryGreen.withAlpha(29),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report.imageUrl != null && report.imageUrl!.isNotEmpty)
                  Image.network(
                    report.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(height: 150, child: Center(child: Text('Image not available'))),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(child: Text(report.locationAddress, style: TextStyle(color: Colors.grey[700]), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(report.status, style: TextStyle(color: _getStatusColor(report.status), fontWeight: FontWeight.w600)),
                          Text(timeago.format(report.submittedAt), style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportDetailView(Report report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: primaryGreen.withAlpha(29),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report.imageUrl != null && report.imageUrl!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        report.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Text(report.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.location_on, 'Location', report.locationAddress),
                _buildDetailRow(Icons.person, 'Reporter', report.submittedBy),
                _buildDetailRow(Icons.access_time, 'Time', timeago.format(report.submittedAt)),
                _buildStatusRow(report.status),
                const SizedBox(height: 16),
                const Text('Description:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(report.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text('Response:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: _responseController, // Use the controller
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Enter your response or actions taken...',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                // Updated button section
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateReportStatus(report, 'Resolved'),
                        style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Mark as Resolved', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateReportStatus(report, 'Pending'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700, padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: const Text('Mark as Pending', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: -8,
              right: -8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => _selectReport(null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
            child: Text(
              status,
              style: TextStyle(
                fontSize: 16,
                color: _getStatusColor(status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
