import 'package:demo/auth/auth_methods.dart';
import 'package:demo/pages/sign_up.dart';
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
  String name = "";
  bool change = false;
  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        change = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        change = false;
      });
    }
  }

  String? validateInput(String? value) {
    if (value!.isEmpty) {
      return "This field cannot be empty";
    } else {
      return null;
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Use the form key to validate the form
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "assets/images/Blue ResQ_new.png",
                  fit: BoxFit.contain,
                  height: 150,
                  width: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome $name",
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter Username",
                            labelText: "Username",
                            labelStyle: TextStyle(
                              fontSize: 20,
                            )),
                        onChanged: (value) {
                          name = value;
                          setState(() {});
                        },
                        validator: (value) => validateInput(value),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 20)),
                        validator: (value) => validateInput(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => moveToHome(context),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: change ? 50 : 100,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: change
                        ? const Icon(Icons.done, color: Colors.white)
                        : const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the sign-up page when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const RegisterForm()), // Replace with your sign-up page widget
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.deepPurple, // Set the button's background color
                    padding:
                        const EdgeInsets.all(16.0), // Set the button's padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Set button's border radius
                    ),
                  ),
                  child: const Text(
                    'Not registered ?  Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set button's text color
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Google icon
          Icon(
            FontAwesomeIcons.google,
            color: Colors.white, // Set icon color
          ),
          const SizedBox(width: 8), // Add some space between the icon and text
          // Text
          Text(
            'Log-In With Google',
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
