import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geomark/Pages/auth_pages/login_pg.dart';
import 'package:geomark/Pages/home_pg.dart';
import 'package:geomark/bloc/internet_bloc.dart';
import 'package:geomark/bloc/internetstate_bloc.dart';
import 'package:geomark/components/custom_snackbar.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state is InternetConnectedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const CustomSnackBar(message: "Internet Connected").snackbar,
          );
        } else if (state is InternetLossState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const CustomSnackBar(message: "Internet not connected....")
                .snackbar,
          );
        }
      },
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          }),
    );
  }
}
