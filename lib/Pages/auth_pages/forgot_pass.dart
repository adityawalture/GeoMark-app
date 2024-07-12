import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geomark/components/customtextfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  String email = "";

  final _formKey = GlobalKey<FormState>();

  void forgotpassword() async {
    if (email != "") {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Reset email sent"),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No user found"),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.message.toString(),
                ),
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Colors.black,
                color: HexColor("#3d3c3c"),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Reset Password",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.09,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.width * 1.6,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                ),
                color: Colors.white,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50.0),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains("@")) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                      hintText: "E-mail",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = _emailController.text;
                          });
                          forgotpassword();
                        }
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
                            "Send Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
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
          )
        ],
      ),
    );
  }
}
