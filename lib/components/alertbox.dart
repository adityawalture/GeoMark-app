
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geomark/Pages/auth_pages/login_pg.dart';
import 'package:geomark/components/custom_snackbar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AlertBox extends StatefulWidget {
  const AlertBox({super.key});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  //signOut function
  // ignore: unused_field
  bool _isSigningOut = false;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _signOut() async {
    Navigator.of(context).pop();
    final GoogleSignIn googleSignIn = GoogleSignIn();

    setState(() {
      _isSigningOut = true;
    });
    try {
      await FirebaseAuth.instance.signOut();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: 'Error signing out. Please try again')
              .snackbar,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      elevation: 2.0,
      title: const Text("Are you sure ?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            MaterialButton(
              onPressed: _isSigningOut ? null : _signOut,
              child: const Text("Yes"),
            ),
          ],
        ),
      ],
    );
  }
}
