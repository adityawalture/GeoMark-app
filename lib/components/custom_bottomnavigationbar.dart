import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  const CustomBottomNavigationBar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: GNav(
        selectedIndex: selectedIndex,
        onTabChange: onItemTapped,
        backgroundColor: Colors.grey.shade300,
        color: Colors.black,
        activeColor: Colors.black,
        tabBackgroundColor: Colors.grey.shade400,
        gap: 8,
        padding: const EdgeInsets.all(16),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.calendar_month_outlined,
            text: 'Attendance',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
          ),
        ],
      ),
    );
  }
}
