import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  final Color primaryGreen = const Color(0xFF00A651);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Collection Schedule',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Barangay [Your Barangay Name]', // Placeholder for barangay
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: primaryGreen.withOpacity(0.5), thickness: 1),
            const SizedBox(height: 24),

            // This week's announcement
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next Collection',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      Icon(Icons.notifications_outlined, color: primaryGreen, size: 28),
                    ],
                  ),
                  const SizedBox(height: 48),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: 'Wednesday, ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'October 26, 2024',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Collection time: 6:00 AM - 10:00 AM',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Next pickup dates
            Text(
              'Upcoming Schedule',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            _buildScheduleTile('Wednesday', 'November 2, 2024'),
            _buildScheduleTile('Wednesday', 'November 9, 2024'),
            _buildScheduleTile('Wednesday', 'November 16, 2024'),

            const SizedBox(height: 32),
            Divider(color: primaryGreen, thickness: 1),
            const SizedBox(height: 16),

            // Waste segregation guide
            Text(
              'Quick Segregation Guide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            _buildSegregationGuideItem(
              icon: Icons.eco,
              color: primaryGreen,
              title: 'Biodegradable',
              examples: 'Fruit peels, leftover food, garden waste.',
            ),
            _buildSegregationGuideItem(
              icon: Icons.recycling,
              color: Colors.blue,
              title: 'Recyclable',
              examples: 'Paper, plastic bottles, glass, metal cans.',
            ),
            _buildSegregationGuideItem(
              icon: Icons.delete_forever,
              color: Colors.black54,
              title: 'Residual',
              examples: 'Sanitary napkins, diapers, contaminated plastics.',
            ),
            _buildSegregationGuideItem(
              icon: Icons.warning,
              color: Colors.red,
              title: 'Hazardous',
              examples: 'Batteries, light bulbs, paint cans.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTile(String day, String date) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: const Icon(Icons.calendar_today, color: Colors.grey, size: 28),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
            children: [
              TextSpan(
                text: '$day, ',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: date,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegregationGuideItem({
    required IconData icon,
    required Color color,
    required String title,
    required String examples,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 6),
                Text(examples, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
