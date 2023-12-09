import 'package:demo/auth/auth_methods.dart';
import 'package:demo/pages/Active_cards.dart';
import 'package:demo/pages/Sample_map_page.dart';
import 'package:demo/pages/empty.dart';
import 'package:demo/pages/home_page.dart';
import 'package:demo/pages/login_page.dart';
import 'package:demo/pages/resolved_confirm.dart';

import 'package:demo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true,
        
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
        MyRoutes.mappage: (context) => const MapPage(),
        MyRoutes.emptypage: (context) => const zeroclass(),
        MyRoutes.verify: (context) => const verify(),
      },
      home: StreamBuilder(
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
      ),
    );
  }
}
