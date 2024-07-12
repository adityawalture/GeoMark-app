import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geomark/components/listview.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the dynamic radius
    final minRadius = screenWidth * 0.1; // 10% of screen width
    final maxRadius = screenHeight * 0.1; // 10% of screen height

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          'Settings',
          style: GoogleFonts.dmSans(
            fontSize: MediaQuery.of(context).size.width * 0.055,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(
              minRadius: minRadius,
              maxRadius: maxRadius,
              backgroundImage:
                  user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(height: 10),
            Text(
              user?.displayName ?? 'User',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              user?.email ?? 'User',
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              // color: Colors.amber,
              child: const SettingsListView(),
            ),
          ],
        ),
      ),
    );
  }
}
