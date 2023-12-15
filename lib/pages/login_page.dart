import 'package:demo/auth/auth_methods.dart';
import 'package:demo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
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
                  "Blue Resq ",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                LogInButton(authMethods: _authMethods),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogInButton extends StatelessWidget {
  final AuthMethods authMethods;

  const LogInButton({Key? key, required this.authMethods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool res = await authMethods.signInWithGoogle(context);
        if (res) {
          Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.google,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            'Sign In With Google',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
