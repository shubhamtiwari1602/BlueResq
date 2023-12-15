import 'package:demo/auth/auth_methods.dart';
import 'package:demo/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: StreamBuilder<User?>(
          stream: AuthMethods().authChanges,
          builder: (context, snapshot) {
            User? user = snapshot.data;

            return Column(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: UserAccountsDrawerHeader(
                    accountName: Text(user?.displayName ?? "User XYZ"),
                    accountEmail: Text(user?.email ?? "abc@gmail.com"),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: user?.photoURL != null
                          ? Image.network(
                              user?.photoURL as String,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/user.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    margin: EdgeInsets.zero,
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.home,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Home",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
                  },
                ),
                
                ListTile(
                  leading: Icon(
                    CupertinoIcons.info,
                    color: Colors.black,
                  ),
                  title: Text(
                    "About Us",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, MyRoutes.about);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.square_list,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Feedback",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, MyRoutes.feedback);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.settings_solid,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Settings",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, MyRoutes.setting);
                  },
                ),
                Divider(),
                ListTile(
                  leading: const Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Logout",
                    textScaleFactor: 1.3,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    AuthMethods().signOut(); // Sign out the user
                    Navigator.pushReplacementNamed(
                        context, MyRoutes.loginRoute);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // App Version at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "App Version: 0.0.0 ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
