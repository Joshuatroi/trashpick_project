import 'package:flutter/material.dart';

class OfficialNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const OfficialNavBar({
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
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Dashboard',
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
              label: 'Routes',
              index: 1,
            ),
            _buildNavItem(
              icon: Icons.folder_open_outlined,
              activeIcon: Icons.folder,
              label: 'Reports',
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.campaign_outlined,
              activeIcon: Icons.campaign,
              label: 'Announce',
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withAlpha(80) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
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
