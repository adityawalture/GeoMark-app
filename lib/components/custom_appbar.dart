import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomAppBar extends StatelessWidget {
  CustomAppBar({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the dynamic radius
    final minRadius = screenWidth * 0.02; // 10% of screen width
    final maxRadius = screenHeight * 0.026; // 10% of screen height

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.13,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, bottom: 6.0, top: 20.0),
              child: CircleAvatar(
                minRadius: minRadius, //10
                maxRadius: maxRadius, //
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null ? const Icon(Icons.person) : null,
              ),
            ),
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                user?.displayName ?? 'User',
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width * 0.052,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
