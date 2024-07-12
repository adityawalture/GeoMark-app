import 'package:flutter/material.dart';
import 'package:geomark/Pages/attendancepage.dart';
import 'package:geomark/Pages/home.dart';
import 'package:geomark/Pages/settingspage.dart';

import 'package:geomark/components/custom_bottomnavigationbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//for bottomnavigationbar
  int _selectIndex = 0;
  late List<Widget> listScreens;

  @override
  void initState() {
    super.initState();
    listScreens = [
      const Home(),
      const AttendancePage(),
      SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: listScreens[_selectIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectIndex,
        onItemTapped: (int index) {
          setState(() {
            _selectIndex = index;
          });
        },
      ),
    );
  }
}
