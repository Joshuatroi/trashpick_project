import 'package:flutter/material.dart';
import 'package:trashpick_project/screens/official_routes.dart';
import 'package:trashpick_project/screens/official_reports.dart';
import 'package:trashpick_project/screens/official_announcement.dart';
import 'package:trashpick_project/screens/official_profile_screen.dart';
import 'package:trashpick_project/widgets/official_nav_bar.dart';

class OfficialDashboard extends StatefulWidget {
  const OfficialDashboard({super.key});

  @override
  State<OfficialDashboard> createState() => _OfficialDashboardState();
}

class _OfficialDashboardState extends State<OfficialDashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Define the screens and their titles
  final List<Widget> _screens = [
    const DashboardContent(),
    const OfficialRoutes(),
    const OfficialReports(),
    const OfficialAnnouncement(),
    const OfficialProfileScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Routes',
    'Reports',
    'Announcements',
    'Profile',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        _onTabTapped(0);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
          // Explicitly control the leading widget (back button)
          automaticallyImplyLeading: false, // Turn off automatic back button
          leading: _currentIndex != 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _onTabTapped(0),
                )
              : null, // No leading widget on the main dashboard tab
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Pass the tab controller to the DashboardContent
          children: [DashboardContent(onTabTapped: _onTabTapped), ..._screens.sublist(1)],
        ),
        bottomNavigationBar: OfficialNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

// The original dashboard content now takes a callback to control the tabs
class DashboardContent extends StatelessWidget {
  final Function(int)? onTabTapped;
  const DashboardContent({super.key, this.onTabTapped});

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
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Official!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Barangay [Your Barangay Name]',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: primaryGreen.withAlpha(128), thickness: 1),
            const SizedBox(height: 24),

            // Overview Container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: primaryGreen.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOverviewItem('12', 'Routes'),
                      _buildOverviewItem('86', 'Reports'),
                      _buildOverviewItem('14', 'Pending'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickActionButton(context, icon: Icons.map_outlined, label: 'Routes', index: 1),
                _buildQuickActionButton(context, icon: Icons.campaign_outlined, label: 'Announce', index: 3),
                _buildQuickActionButton(context, icon: Icons.folder_open_outlined, label: 'Reports', index: 2),
                _buildQuickActionButton(context, icon: Icons.person_outline, label: 'Profile', index: 4),
              ],
            ),
            const SizedBox(height: 32),

            // Active Routes Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Routes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                 TextButton(
                  onPressed: () => onTabTapped?.call(1),
                  child: Text(
                    'View All',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActiveRouteCard(
              routeName: 'North District',
              wasteType: 'Recyclable',
              timePeriod: '6:00 AM - 10:00 AM',
              status: 'Ongoing',
            ),
            _buildActiveRouteCard(
              routeName: 'South Commercial Zone',
              wasteType: 'Biodegradable',
              timePeriod: '8:00 AM - 12:00 PM',
              status: 'Starting Soon',
            ),
            const SizedBox(height: 32),

            // Recent Reports Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Recent Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                TextButton(
                   onPressed: () => onTabTapped?.call(2),
                  child: Text(
                    'View All',
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.report_problem_outlined,
              iconColor: Colors.orange,
              title: 'Illegal Dumping on 5th St.',
              subtitle: 'Reported 30 minutes ago',
            ),
            _buildInfoCard(
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
              title: 'Overflowing bin at Central Park',
              subtitle: 'Reported 2 hours ago',
            ),
            const SizedBox(height: 20), // Padding at the end
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(BuildContext context, {required IconData icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => onTabTapped?.call(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: primaryGreen),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActiveRouteCard({
    required String routeName,
    required String wasteType,
    required String timePeriod,
    required String status,
  }) {
    Color wasteColor = Colors.grey;
    if (wasteType == 'Recyclable') {
      wasteColor = Colors.blue;
    } else if (wasteType == 'Biodegradable') {
      wasteColor = Colors.green;
    } else if (wasteType == 'Non-Biodegradable') {
        wasteColor = Colors.black87;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    routeName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: status == 'Ongoing' ? primaryGreen : Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: wasteColor.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    wasteType,
                    style: TextStyle(color: wasteColor, fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(timePeriod),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required Color iconColor, required String title, required String subtitle}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
