import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geomark/components/custom_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  //to update/add user phone number
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String? _verificationId;

  @override
  void dispose() {
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Profile',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
            ),
          ),
          content: TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Enter phone number',
              hintStyle: GoogleFonts.dmSans(),
            ),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _verifyPhoneNumber();
                Navigator.of(context).pop();
              },
              child: const Text('Send Code'),
            ),
          ],
        );
      },
    );
  }

  void _verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await user?.updatePhoneNumber(credential);
          await _reloadUser();
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(message: 'Failed to verify ${e.message}').snackbar,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
          _showSmsCodeDialog();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        });
  }

  void _showSmsCodeDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter SMS Code',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: _smsController,
            decoration: InputDecoration(
              hintText: 'Enter SMS code',
              hintStyle: GoogleFonts.dmSans(),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                _updatePhoneNumber();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Verify',
              ),
            ),
          ],
        );
      },
    );
  }

  void _updatePhoneNumber() async {
    if (_verificationId != null) {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsController.text,
      );

      try {
        await user?.updatePhoneNumber(credential);
        await _reloadUser();
        setState(() {});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const CustomSnackBar(message: 'Phone number updated successfully!')
                .snackbar,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(
                    message: 'Failed to update phone number: ${e.toString()}')
                .snackbar,
          );
        }
      }
    }
  }

  Future<void> _reloadUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the dynamic radius
    final minRadius = screenWidth * 0.1; // 10% of screen width
    final maxRadius = screenHeight * 0.1; // 10% of screen height

    double basefontSize = 15.0;
    double fontSize = basefontSize * (screenWidth / 375);

    final textStyle = GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );

    final boxDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 236, 236, 236),
      borderRadius: BorderRadius.circular(9),
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Profile',
          style: GoogleFonts.dmSans(
            fontSize: MediaQuery.of(context).size.width * 0.055,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 134, 134, 134),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    minRadius: minRadius,
                    maxRadius: maxRadius,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoRow(
                        label: "User Name:",
                        value: user?.displayName ?? 'N/A',
                        boxDecoration: boxDecoration,
                        context: context,
                        fontSize: fontSize,
                        textStyle: textStyle,
                      ),
                      _buildUserInfoRow(
                        label: "Phone number:",
                        value: user?.phoneNumber ?? 'N/A',
                        boxDecoration: boxDecoration,
                        context: context,
                        fontSize: fontSize,
                        textStyle: textStyle,
                      ),
                      _buildUserInfoRow(
                        label: "E-mail:",
                        value: user?.email ?? 'N/A',
                        boxDecoration: boxDecoration,
                        context: context,
                        fontSize: fontSize,
                        textStyle: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  _showEditDialog();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.060,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(16.0, 16.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Update Phone number",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.04, //17
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow({
    required String label,
    required String value,
    required double fontSize,
    required BoxDecoration boxDecoration,
    required TextStyle textStyle,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 236, 236, 236),
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
