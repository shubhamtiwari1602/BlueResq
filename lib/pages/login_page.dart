import 'package:demo/auth/auth_methods.dart';

import 'package:demo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//New Font library imported

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  

  



  

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
             // Use the form key to validate the form
            child: Column(
              children: [
                const SizedBox(
                  height: 0,
                ),
                Image.asset(
                  "assets/images/Blue ResQ_new.png",
                  fit: BoxFit.contain,
                  height: 250,
                  width: 250,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Welcome ",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "BlueResq ",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                
                GsignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GsignInButton extends ConsumerWidget {
   GsignInButton({
    super.key,
  });
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async{
        bool res = await _authMethods.signInWithGoogle(context);
        if(res){
          Navigator.pushNamed(context, MyRoutes.homeRoute);

        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Set the button's background color
        padding: const EdgeInsets.all(16.0), // Set the button's padding
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Set button's border radius
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Google icon
          Icon(
            FontAwesomeIcons.google,
            color: Colors.white, // Set icon color
          ),
          SizedBox(width: 8), // Add some space between the icon and text
          // Text
          Text(
            'Sign In With Google',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Set button's text color
            ),
          ),
        ],
      ),
    );
  }
}
