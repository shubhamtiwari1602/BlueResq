import 'package:demo/utils/routes.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String nameError = '';
  String emailError = '';
  String passwordError = '';
  String verifyPasswordError = '';
  String locationError = '';
  String selectedLocation = 'GC';
  List<String> locations = ['GC', 'Main Gate', 'V Gate', 'T Gate'];
  bool acceptedTerms = false;
  String termsError = '';

  bool validateFields() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      setState(() {
        nameError = 'Please enter your name.';
        isValid = false;
      });
    } else {
      setState(() {
        nameError = '';
      });
    }

    String email = emailController.text;
    if (email.isEmpty) {
      setState(() {
        emailError = 'Please enter your email.';
        isValid = false;
      });
    } else if (!isEmailValid(email)) {
      setState(() {
        emailError = 'Please enter a valid email address.';
        isValid = false;
      });
    } else {
      setState(() {
        emailError = '';
      });
    }

    String password = passwordController.text;
    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter your password.';
        isValid = false;
      });
    } else if (!isPasswordValid(password)) {
      setState(() {
        passwordError =
            'Password must contain at least one uppercase letter, one lowercase letter, one special character, and be at least 8 characters long.';
        isValid = false;
      });
    } else {
      setState(() {
        passwordError = '';
      });
    }

    String verifyPassword = verifyPasswordController.text;
    if (verifyPassword.isEmpty) {
      setState(() {
        verifyPasswordError = 'Please re-enter your password.';
        isValid = false;
      });
    } else if (password != verifyPassword) {
      setState(() {
        verifyPasswordError = 'Passwords do not match. Please re-enter.';
        isValid = false;
      });
    } else {
      setState(() {
        verifyPasswordError = '';
      });
    }

    if (selectedLocation.isEmpty) {
      setState(() {
        locationError = 'Please select your location.';
        isValid = false;
      });
    } else {
      setState(() {
        locationError = '';
      });
    }

    if (!acceptedTerms) {
      setState(() {
        termsError = 'Please accept the terms and conditions.';
        isValid = false;
      });
    } else {
      setState(() {
        termsError = '';
      });
    }

    return isValid;
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.{8,})');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Registration Form',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField('Name', nameController, nameError),
                    _buildTextField('Email ID', emailController, emailError),
                    _buildTextField(
                      'Password',
                      passwordController,
                      passwordError,
                      isPassword: true,
                      onChanged: () => clearErrorMessage('password'),
                    ),
                    _buildTextField(
                      'Re-Enter Password',
                      verifyPasswordController,
                      verifyPasswordError,
                      isPassword: true,
                      onChanged: () => clearErrorMessage('verifyPassword'),
                    ),
                    _buildDropdownField('Location', selectedLocation, locations, locationError),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: acceptedTerms,
                          onChanged: (value) {
                            setState(() {
                              acceptedTerms = value!;
                            });
                          },
                        ),
                        Text('I accept the terms and conditions'),
                      ],
                    ),
                    if (termsError.isNotEmpty)
                      Text(
                        termsError,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (validateFields()) {
                          String password = passwordController.text;
                          String verifyPassword = verifyPasswordController.text;

                          if (password == verifyPassword) {
                            // Navigate to home page on successful registration
                            // Assuming you have a Navigator in the widget tree
                            Navigator.pushNamed(context, MyRoutes.homeRoute);
                          } else {
                            setState(() {
                              verifyPasswordError =
                                  'Passwords do not match. Please re-enter.';
                            });
                          }
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String error,
      {bool isPassword = false, void Function()? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: isPassword
                ? 'Must contain at least one uppercase letter, one lowercase letter, one special character, and be at least 8 characters long.'
                : 'Enter $label',
            errorText: error.isNotEmpty ? error : null,
            hintMaxLines: 2,
          ),
          onChanged: (value) {
            if (onChanged != null) {
              onChanged();
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: (newValue) {
            setState(() {
              selectedLocation = newValue!;
            });
          },
          items: items.map((location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select $label',
            errorText: error.isNotEmpty ? error : null,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void clearErrorMessage(String field) {
    setState(() {
      switch (field) {
        case 'password':
          passwordError = '';
          break;
        case 'verifyPassword':
          verifyPasswordError = '';
          break;
      }
    });
  }
}
