import 'package:flutter/material.dart';

// A simple data class for holding report information
class Report {
  final String title;
  final String status;
  final String location;
  final String description;
  final String reporter;
  final String time;
  final String? imageUrl; // Made imageUrl optional

  Report({
    required this.title,
    required this.status,
    required this.location,
    required this.description,
    required this.reporter,
    required this.time,
    this.imageUrl, // Made imageUrl optional
  });
}

class OfficialReports extends StatefulWidget {
  const OfficialReports({super.key});

  @override
  State<OfficialReports> createState() => _OfficialReportsState();
}

class _OfficialReportsState extends State<OfficialReports> {
  // Dummy data for the reports
  final List<Report> _reports = [
    Report(
      title: 'Illegal Dumping on 5th St.',
      status: 'Pending',
      location: 'Corner of 5th St. and Main Ave',
      description: 'A large pile of construction debris and old furniture was left on the sidewalk overnight. It is blocking pedestrian access.',
      reporter: 'Jane Doe',
      time: '30 minutes ago',
      imageUrl: 'https://picsum.photos/seed/report1/400/300',
    ),
    Report(
      title: 'Overflowing bin at Central Park',
      status: 'Resolved',
      location: 'Central Park, near the fountain',
      description: 'The main trash bin by the fountain is completely full and overflowing. It needs to be emptied as soon as possible.',
      reporter: 'John Smith',
      time: '2 hours ago',
      imageUrl: 'https://picsum.photos/seed/report2/400/300',
    ),
    Report(
      title: 'Missed garbage pickup',
      status: 'Pending',
      location: '123 Oak St.',
      description: 'Our street\'s garbage was not collected this morning during the scheduled time. All the bins are still on the curb.',
      reporter: 'Emily White',
      time: '8 hours ago', 
      // No image for this report
    ),
  ];

  int? _selectedReportIndex;

  final Color primaryGreen = const Color(0xFF00A651);

  void _selectReport(int? index) {
    setState(() {
      _selectedReportIndex = index;
    });
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
    return _selectedReportIndex == null
        ? _buildReportList()
        : _buildReportDetailView(_reports[_selectedReportIndex!]);
  }

  Widget _buildReportList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _reports.length,
      itemBuilder: (context, index) {
        final report = _reports[index];
        return GestureDetector(
          onTap: () => _selectReport(index),
          child: Card(
            color: primaryGreen.withAlpha(29),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias, // Ensures the image is clipped to the card's shape
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report.imageUrl != null)
                  Image.network(
                    report.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                          Expanded(child: Text(report.location, style: TextStyle(color: Colors.grey[700]), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(report.status, style: TextStyle(color: _getStatusColor(report.status), fontWeight: FontWeight.w600)),
                          Text(report.time, style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
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
                if (report.imageUrl != null)
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
                _buildDetailRow(Icons.location_on, 'Location', report.location),
                _buildDetailRow(Icons.person, 'Reporter', report.reporter),
                _buildDetailRow(Icons.access_time, 'Time', report.time),
                _buildStatusRow(report.status), // Using a custom row for status
                const SizedBox(height: 16),
                const Text('Description:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(report.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text('Response:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your response or actions taken...',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Mark as Resolved', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
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
