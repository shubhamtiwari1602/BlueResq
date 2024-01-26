import 'package:demo/auth/auth_methods.dart';
import 'package:demo/pages/Active_cards.dart';
import 'package:demo/pages/Sample_map_page.dart';

import 'package:demo/pages/drawer_pages/feedback.dart';
import 'package:demo/pages/drawer_pages/setting.dart';

import 'package:demo/pages/home_page.dart';
import 'package:demo/pages/login_page.dart';

import 'package:demo/pages/resolved_confirm.dart';
import 'package:demo/pages/map_pages/detailed_sit_report.dart';
import 'package:demo/utils/routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/drawer_pages/about_us.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  runApp(const ProviderScope(child: MyApp()));
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received FCM message: ${message.data}");
    // Handle the received data
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
        ),
      ),
      routes: {
        MyRoutes.homeRoute: (context) => const HomePage(),
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.activecases: (context) => const CardPage(),
        MyRoutes.mappage: (context) => const MapPage(
              animalName: '',
              severity: '',
              animalLocation: '',
            ),
        MyRoutes.verify: (context) => const verify(),
        MyRoutes.setting: (context) => const Setting(),
        MyRoutes.feedback: (context) => FeedBack(),
        MyRoutes.about: (context) => const AboutUs(),
        MyRoutes.sitrepo:(context) => SituationReportPage(),
        MyRoutes.resolved:(context)=> const verify(),
      },
      home:
          const AuthWrapper(), // Use AuthWrapper instead of StreamBuilder directly
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthMethods().authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
