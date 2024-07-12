import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geomark/Pages/home_pg.dart';

import 'package:geomark/components/custom_snackbar.dart';
import 'package:geomark/components/customtextfield.dart';
import 'package:geomark/services/auth_google.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool passwordVisible = false;
  // String name = "";
  // String email = "";
  // String password = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  void showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  Future<void> registration() async {
    if (_formKey.currentState!.validate()) {
      try {
        //loading circle
        showLoadingDialog();
        // UserCredential signupCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (mounted) {
          // Navigator.of(context).pop();
          _hideLoadingDialog();
          ScaffoldMessenger.of(context).showSnackBar(
            const CustomSnackBar(message: "Registered successfully").snackbar,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          _hideLoadingDialog();
          String message = 'Something went wrong';
          if (e.code == 'weak-password') {
            message = 'Weak password';
          } else if (e.code == 'email-already-in-use') {
            message = 'Account already exist';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            CustomSnackBar(message: message).snackbar,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //function for auth_google

  void _signIn() async {
    showLoadingDialog();

    UserCredential? userCredential = await SignInGoogle().signInWithGoogle();
    _hideLoadingDialog();

    if (mounted) {
      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "Successfully signed in with Google")
              .snackbar,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "Something went wrong").snackbar,
        );
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
                    top: MediaQuery.of(context).size.height * 0.10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.13,
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
              height: MediaQuery.of(context).size.height * 0.75,
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
                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Name';
                        }
                        return null;
                      },
                      hintText: "Name",
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                    ),
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
                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Password';
                        } else if (value.length < 7) {
                          return 'Password length is short';
                        }
                        return null;
                      },
                      hintText: "password",
                      controller: _passwordController,
                      isObsecureText: passwordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        registration();
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
                            "Sign Up",
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
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          width: 55,
                          child: Divider(
                            thickness: 1.0,
                            color: Color.fromARGB(144, 55, 55, 55),
                          ),
                        ),
                        Text(
                          " Or ",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 55,
                          child: Divider(
                            thickness: 1.0,
                            color: Color.fromARGB(144, 55, 55, 55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        // AuthMethods().signInWithGoogle(context);
                        _signIn();
                      },
                      child: Image.asset(
                        "assets/images/google.png",
                        height: MediaQuery.of(context).size.height * 0.044,
                        width: MediaQuery.of(context).size.height * 0.044,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
