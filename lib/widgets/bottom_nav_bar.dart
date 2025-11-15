import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final Color primaryGreen = const Color(0xFF00A651);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: primaryGreen.withAlpha(40), // Very light green background
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.schedule_outlined,
              activeIcon: Icons.schedule,
              label: 'Schedule',
              index: 1,
            ),
            _buildNavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Alerts',
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.report_outlined,
              activeIcon: Icons.report,
              label: 'Report',
              index: 3,
            ),
            _buildNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.translucent, // Ensures the whole area is tappable
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withAlpha(50) : Colors.transparent,

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? primaryGreen : Colors.grey[700],
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryGreen : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
