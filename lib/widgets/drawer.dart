import 'package:demo/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            const DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                accountName: Text("User XYZ"),
                accountEmail: Text("abc@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundImage: AssetImage('assets/images/user.png'),
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
            const ListTile(
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.black,
              ),
              title: Text(
                "Profile",
                textScaleFactor: 1.3,
                style: TextStyle(color: Colors.black),
              ),
              
            ),
            const ListTile(
              leading: Icon(
                CupertinoIcons.info,
                color: Colors.black,
              ),
              title: Text(
                "About Us",
                textScaleFactor: 1.3,
                style: TextStyle(color: Colors.black),
              ),
            ),
            const ListTile(
              leading: Icon(
                CupertinoIcons.square_list,
                color: Colors.black,
              ),
              title: Text(
                "Feedback",
                textScaleFactor: 1.3,
                style: TextStyle(color: Colors.black),
              ),
            ),
            const ListTile(
              leading: Icon(
                CupertinoIcons.settings_solid,
                color: Colors.black,
              ),
              title: Text(
                "Settings",
                textScaleFactor: 1.3,
                style: TextStyle(color: Colors.black),
              ),
            ),
            const Divider(),
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
                // Handle logout logic here
                // Navigate to the login page
                Navigator.pushReplacementNamed(context, MyRoutes.loginRoute);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // App Version at the bottom
            const Align(
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
        ),
      ),
    );
  }
}
