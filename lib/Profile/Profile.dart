import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Authentification/authentication/auth_screen.dart';
import '../Authentification/global/global.dart';
import '../Chat/screens/chat_screen.dart';
import '../Chat/widgets/bottomNavigationBar.dart';
import './dialogs.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;
  late DocumentSnapshot userData;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchUserData();
  }

  void fetchUserData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();
    setState(() {
      userData = docSnapshot;
    });
  }

  // Function to handle logout action.
  logout() async {
    questionDialog(
      context: context,
      title: "Logout",
      content: "Are you sure want to logout from your account?",
      func: () async {
        // Your logout logic here
        firebaseAuth.signOut().then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
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
        backgroundColor: Color(0xFF00aa9b),
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Color(0xFF232d4b),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['userAvatarUrl']),
                ),
              ),
              SizedBox(height: 20.0),
              buildProfileItem("Name", userData['userName']),
              buildProfileItem("Email", userData['userEmail']),
              buildProfileItem("Phone", userData['phone']),
              buildProfileItem("Address", userData['address']),
              buildProfileItem("Status", userData['status']),
              const Spacer(), // Add a spacer to push the logout button to the bottom
            ],
          ),
        ),
      ),
      floatingActionButton: buildLogoutButton(), // Add logout button as a floating action button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Position logout button at the bottom center
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Set the current index to 3 for the ProfileScreen
        onTap: (index) {
          setState(() {
            // Navigate to the corresponding screen when an item is tapped
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/search');
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                break;
              case 3:
              // Do nothing because we are already on the ProfileScreen
                break;
            }
          });
        },
      ),
    );
  }

  // Builds a profile item with a label and its value
  Widget buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF00aa9b),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        const Gap(10),
      ],
    );
  }

  // Builds the logout button.
  Widget buildLogoutButton() {
    return ElevatedButton(
      onPressed: logout,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        foregroundColor: Colors.white,
        elevation: 10,
        backgroundColor: Colors.red,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.logout_outlined, size: 28),
          Gap(10),
          Text(
            "Log Out",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
