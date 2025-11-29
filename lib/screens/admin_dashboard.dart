import 'package:flutter/material.dart';

// Dummy pages for navigation
class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Manage Accounts Page')));
  }
}

class CreateOfficialPage extends StatelessWidget {
  const CreateOfficialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Create Official Account Page')));
  }
}

class SendAlertPage extends StatelessWidget {
  const SendAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Send Alert Page')));
  }
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardHome(),
    const AlertsPage(),
    const ReportsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color(0xFF00A651),
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? const Color(0xFF00A651) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.dashboard, color: _selectedIndex == 0 ? Colors.white : const Color(0xFF00A651)),
              ),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
            const BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Reports'),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ------------------- DASHBOARD HOME -------------------
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Good morning, Admin!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('Cebu City', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFB8E6D0), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.admin_panel_settings, color: Color(0xFF00A651), size: 28),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Overview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.access_time, color: Color(0xFF00A651), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text("Today's Overview",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildOverviewItem('156', 'Accounts', const Color(0xFF00A651)),
                      _buildOverviewItem('12', 'Officials', const Color(0xFF2196F3)),
                      _buildOverviewItem('8', 'Pending', const Color(0xFFFF9800)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAccountsPage())),
                    child: _buildActionCard('Manage Accounts', 'View all users', Icons.people, const Color(0xFF00A651)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOfficialPage())),
                    child: _buildActionCard('Create Official\nAccount', 'Add barangay staff', Icons.person_add, const Color(0xFF2196F3)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SendAlertPage())),
                    child: _buildActionCard('Send Alert', 'Notify users', Icons.notifications_active, const Color(0xFF9C27B0)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Container()), // Empty for layout balance
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Official Accounts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
            const SizedBox(height: 12),
            _buildOfficialCard('Juan Dela Cruz', 'Collection Officer', 'Active', 'juandc@barangay.gov', Colors.green, context),
            const SizedBox(height: 12),
            _buildOfficialCard('Maria Santos', 'Route Manager', 'Active', 'maria.s@barangay.gov', Colors.green, context),
            const SizedBox(height: 12),
            _buildOfficialCard('Pedro Reyes', 'Field Officer', 'Pending', 'pedro.r@barangay.gov', Colors.orange, context),
            const SizedBox(height: 24),
            const Text('System Alerts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
            const SizedBox(height: 12),
            _buildAlertCard('New account registration', '5 new users registered today', 'Info', Icons.info, context),
            const SizedBox(height: 12),
            _buildAlertCard('Pending approvals', '3 official accounts need approval', 'Warning', Icons.warning_amber, context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String number, String label, Color color) {
    return Column(
      children: [
        Text(number, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildOfficialCard(String name, String role, String status, String email, Color statusColor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to official details page (can create a new screen)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Clicked $name')));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: const Color(0xFFB8E6D0), radius: 24, child: Text(name[0], style: const TextStyle(color: Color(0xFF00A651), fontWeight: FontWeight.bold, fontSize: 20))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                  const SizedBox(height: 4),
                  Text(role, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 2),
                  Text(email, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String description, String type, IconData icon, BuildContext context) {
    Color alertColor = type == 'Warning' ? Colors.orange : const Color(0xFF2196F3);
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Clicked alert: $title')));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: alertColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: alertColor, size: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF212121))),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: alertColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(type, style: TextStyle(color: alertColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// AlertsPage, ReportsPage, ProfilePage remain same, you can also make cards in ReportsPage tappable similarly

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alerts & Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'System alerts and user notifications',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _buildNotificationCard(
              'New User Registration',
              'John Doe registered 5 minutes ago',
              '5 min ago',
              Icons.person_add,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              'Account Approval Needed',
              'Official account pending approval',
              '15 min ago',
              Icons.approval,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildNotificationCard(
              'Schedule Updated',
              'Collection schedule for Route A modified',
              '1 hour ago',
              Icons.update,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Analytics and system statistics',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            _buildReportCard(
              'Total Users',
              '156',
              'Active accounts',
              Icons.people,
              const Color(0xFF00A651),
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              'Barangay Officials',
              '12',
              'Verified staff',
              Icons.badge,
              const Color(0xFF2196F3),
            ),
            const SizedBox(height: 12),
            _buildReportCard(
              'Collections This Month',
              '342',
              'Completed pickups',
              Icons.local_shipping,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFB8E6D0),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 50,
                color: Color(0xFF00A651),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'System Administrator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'admin@trashpick.com',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            _buildProfileOption(Icons.settings, 'Settings', 'App preferences'),
            _buildProfileOption(
              Icons.security,
              'Security',
              'Password & authentication',
            ),
            _buildProfileOption(Icons.help, 'Help & Support', 'Get assistance'),
            _buildProfileOption(Icons.info, 'About', 'App information'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00A651)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
        ],
      ),
    );
  }
}
