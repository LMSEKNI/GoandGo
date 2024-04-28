import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();
  late User? currentUser;
  Map<String, dynamic> userData = {}; // Initialize with an empty map
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _statusController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _statusController = TextEditingController();
      _addressController = TextEditingController();

      fetchUserData();
    }
  }

  void fetchUserData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get()
        .then((userDataSnapshot) {
      if (userDataSnapshot.exists) {
        setState(() {
          userData = userDataSnapshot.data()!;
          _nameController.text = userData['userName'] ?? '';
          _emailController.text = userData['userEmail'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _statusController.text = userData['status'] ?? '';
          _addressController.text = userData['address'] ?? '';
        });
      }
    });
  }

  Future<void> _updateProfileData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser!.uid)
            .update({
          'userName': _nameController.text,
          'userEmail': _emailController.text,
          'phone': _phoneController.text,
          'status': _statusController.text,
          'address': _addressController.text,
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        // If an error occurs, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00aa9b),
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateProfileData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout, // Call the logout function
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFF232d4b),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userData['userAvatarUrl'] ?? ''),
                  ),
                ),
                const SizedBox(height: 20.0),
                buildEditableProfileItem("Name", _nameController),
                buildEditableProfileItem("Email", _emailController),
                buildEditableProfileItem("Phone", _phoneController),
                buildEditableProfileItem("Status", _statusController),
                buildEditableProfileItem("Address", _addressController),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditableProfileItem(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF00aa9b)),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00aa9b)),
          ),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
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
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const AuthScreen()));
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