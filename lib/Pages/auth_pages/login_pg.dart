import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:geomark/Pages/auth_pages/forgot_pass.dart';
import 'package:geomark/Pages/auth_pages/signup_pg.dart';
import 'package:geomark/Pages/home_pg.dart';

import 'package:geomark/components/custom_snackbar.dart';
import 'package:geomark/components/customtextfield.dart';
import 'package:geomark/services/auth_google.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  // String email = "";
  // String password = "";

  final _formKey = GlobalKey<FormState>();

  Future<void> userLogin() async {
    if (_emailController.text.isNotEmpty &&
        _passController.text.length >= 8 &&
        _passController.text.isNotEmpty) {
      try {
        //loading circle
        showLoadingDialog();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );

        if (mounted) {
          // Navigator.of(context).pop();
          _hideLoadingDialog;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        handleLoginError(e);
      }
    }
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

  void handleLoginError(FirebaseAuthException e) {
    Navigator.of(context).pop(); // Remove loading dialog
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "User not found").snackbar);
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "Wrong password").snackbar);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const CustomSnackBar(message: "Something went wrong").snackbar);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();

    super.dispose();
  }

  //function for auth_google
  // ignore: unused_field

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
                    top: MediaQuery.of(context).size.height * 0.13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "GeoMark",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        color: HexColor("#FFD5B9"),
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
              height: MediaQuery.of(context).size.height * 0.65,
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
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.09,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
                      hintText: "Password",
                      controller: _passController,
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
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              MediaQuery.of(context).size.width * 0.1), //39.0
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ));
                            },
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.035, //16.0
                                color: const Color.fromARGB(217, 53, 161, 248),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          // setState(() {
                          //   email = _emailController.text;
                          //   password = _passController.text;
                          // });
                        }
                        userLogin();
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
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04, //17
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
                              fontSize: MediaQuery.of(context).size.width *
                                  0.035, //20.0
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont't have an account ?",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035, //16.0
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ));
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width * 0.035, //16.0
                      color: const Color.fromARGB(217, 53, 161, 248),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
