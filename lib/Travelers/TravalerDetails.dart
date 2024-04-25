import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'RatingInterface.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  UserDetailsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        centerTitle: true,
        backgroundColor: Color(0xFF00aa9b),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Color(0xFF232d4b),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection("users").doc(userId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userData = snapshot.data!.data()!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['userAvatarUrl'] ?? ''),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    buildProfileItem("Name", userData['userName'] ?? ''),
                    buildProfileItem("Email", userData['userEmail'] ?? ''),
                    buildProfileItem("Phone", userData['phone'] ?? ''),
                    buildProfileItem("Address", userData['address'] ?? ''),
                    buildProfileItem("Status", userData['status'] ?? ''),
                    // Add more profile items as needed
                    SizedBox(height: 20.0),
                    Center( // Center the button horizontally
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the rating interface
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RatingInterface()),
                          );
                        },
                        child: Text('Rate User'),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
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
        SizedBox(height: 10.0),
      ],
    );
  }
}
