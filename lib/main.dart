import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geomark/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geomark/bloc/internet_bloc.dart';
import 'package:geomark/firebase_options.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
        title: 'GeoMark',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.dmSansTextTheme(
            Theme.of(context).textTheme,
          ),
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black),
          useMaterial3: true,
        ),
        home: const Authentication(),
        // home: const MapsPage(),
      ),
    );
  }
}
