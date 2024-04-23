import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Authentification/authentication/auth_screen.dart';
import '../Authentification/global/global.dart';
import './dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Function to handle logout action.
  logout() async {
    questionDialog(
      context: context,
      title: "Logout",
      content: "Are you sure want to logout from your account?",
      func: () async {
        // Your logout logic here
        firebaseAuth.signOut().then((value){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
        });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You are successfully logged out."),
              backgroundColor: Colors.green,
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: const Color(0xFF005573),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(20),
              buildLogoutButton(),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the logout button.
  Widget buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: logout,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          foregroundColor: Colors.white,
          elevation: 10,
          backgroundColor: Colors.red,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout_outlined, size: 28),
            const Gap(10),
            const Text(
              "Log Out",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
