import 'package:demo/pages/Active_cards.dart';
import 'package:demo/pages/Sample_map_page.dart';
import 'package:demo/pages/empty.dart';
import 'package:demo/pages/home_page.dart';
import 'package:demo/pages/login_page.dart';
import 'package:demo/pages/resolved_confirm.dart';
import 'package:demo/pages/sign_up.dart';
import 'package:demo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


//Stateful widgets - which involve change in state.
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child:  Myapp()));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

//override -used to rewrite the class function widget
  //context - helps in telling the location of each widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: HomePage(),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner:
          false, //removes the debug banner while testing
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.lato().fontFamily,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 1.0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
        ),
      ),
      //  initialRoute: "/home",
      routes: {
        "/": (context) => const LoginPage(),
        MyRoutes.homeRoute: (context) => const HomePage(),
        MyRoutes.loginRoute: (context) => const LoginPage(),
        MyRoutes.activecases: (context) => const CardPage(),
        MyRoutes.mappage: (context) => const MapPage(),
        MyRoutes.register: (context) => const RegisterForm(),
        MyRoutes.emptypage: (context) => const zeroclass(),
        MyRoutes.verify: (context) => const verify(),
      },
    );
  }
}
