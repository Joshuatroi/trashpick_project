import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashpick_project/models/report.dart';
import 'package:trashpick_project/models/schedule.dart';
import 'package:trashpick_project/screens/official_announcement.dart';
import 'package:trashpick_project/screens/official_profile_page.dart';
import 'package:trashpick_project/screens/official_reports.dart';
import 'package:trashpick_project/screens/official_schedule.dart';
import 'package:trashpick_project/widgets/official_nav_bar.dart';

class OfficialDashboard extends StatefulWidget {
  const OfficialDashboard({super.key});

  @override
  State<OfficialDashboard> createState() => _OfficialDashboardState();
}

class _OfficialDashboardState extends State<OfficialDashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<String> _titles = ['Dashboard', 'Schedules', 'Reports', 'Announcements', 'Profile'];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the screens list here to ensure _onTabTapped is always valid.
    final List<Widget> screens = [
      DashboardContent(onTabTapped: _onTabTapped),
      const OfficialSchedule(),
      const OfficialReports(),
      const OfficialAnnouncement(),
      const OfficialProfilePage(),
    ];

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        _onTabTapped(0);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex], style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 1,
          automaticallyImplyLeading: false,
          leading: _currentIndex != 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _onTabTapped(0),
                )
              : null,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: screens, // Use the list created in the build method
        ),
        bottomNavigationBar: OfficialNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final Function(int) onTabTapped;
  const DashboardContent({super.key, required this.onTabTapped});

  final Color primaryGreen = const Color(0xFF00A651);

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: firestore.collection('users').doc(user?.uid).snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() as Map<String, dynamic>?;
                final officialName = data?['fullName'] as String? ?? 'Official';
                final barangayName = data?['barangay'] as String? ?? 'Your Barangay';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome, $officialName!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen)),
                      const SizedBox(height: 4),
                      Text('Barangay $barangayName', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
            Divider(color: primaryGreen.withAlpha(128), thickness: 1),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              decoration: BoxDecoration(color: primaryGreen.withAlpha(26), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOverviewItem(firestore.collection('schedules').where('status', isEqualTo: 'Active').snapshots(), 'Schedules'),
                      _buildOverviewItem(firestore.collection('reports').snapshots(), 'Reports'),
                      _buildOverviewItem(firestore.collection('reports').where('status', isEqualTo: 'Pending').snapshots(), 'Pending'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Quick Actions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildQuickActionButton(context, icon: Icons.map_outlined, label: 'Schedules', index: 1),
                _buildQuickActionButton(context, icon: Icons.campaign_outlined, label: 'Announce', index: 3),
                _buildQuickActionButton(context, icon: Icons.folder_open_outlined, label: 'Reports', index: 2),
                _buildQuickActionButton(context, icon: Icons.person_outline, label: 'Profile', index: 4),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Active Schedules', 1),
            const SizedBox(height: 16),
            _buildRecentSchedules(firestore),
            const SizedBox(height: 32),
            _buildSectionHeader(context, 'Recent Reports', 2),
            const SizedBox(height: 16),
            _buildRecentReports(firestore),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(Stream<QuerySnapshot> stream, String label) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length.toString() ?? '0';
        return Column(
          children: [
            Text(count, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        );
      },
    );
  }

  Widget _buildQuickActionButton(BuildContext context, {required IconData icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: primaryGreen),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
        TextButton(
          onPressed: () => onTabTapped(index),
          child: Text('View All', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildRecentSchedules(FirebaseFirestore firestore) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('schedules').where('status', isEqualTo: 'Active').limit(2).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final schedules = snapshot.data!.docs.map((doc) => Schedule.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
        return schedules.isEmpty
            ? const Text('No active schedules.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: schedules.length,
                itemBuilder: (context, index) => _buildActiveScheduleCard(schedules[index]),
              );
      },
    );
  }

  Widget _buildRecentReports(FirebaseFirestore firestore) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('reports').orderBy('submittedAt', descending: true).limit(2).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final reports = snapshot.data!.docs.map((doc) => Report.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
        return reports.isEmpty
            ? const Text('No recent reports.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reports.length,
                itemBuilder: (context, index) => _buildInfoCard(reports[index]),
              );
      },
    );
  }

  Widget _buildActiveScheduleCard(Schedule schedule) {
    Color wasteColor = Colors.grey;
    if (schedule.wasteType == 'Recyclable') wasteColor = Colors.blue;
    if (schedule.wasteType == 'Biodegradable') wasteColor = Colors.green;

    return GestureDetector(
      onTap: () => onTabTapped(1),
      child: Card(
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
                  Expanded(child: Text(schedule.scheduleName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  Text(schedule.status, style: TextStyle(color: schedule.status == 'Ongoing' ? primaryGreen : Colors.orangeAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: wasteColor.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                    child: Text(schedule.wasteType, style: TextStyle(color: wasteColor, fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(schedule.timePeriod),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Report report) {
    return GestureDetector(
      onTap: () => onTabTapped(2),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          leading: Icon(report.status == 'Pending' ? Icons.report_problem_outlined : Icons.check_circle_outline, color: report.status == 'Pending' ? Colors.orange : Colors.green, size: 32),
          title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(report.locationAddress),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
