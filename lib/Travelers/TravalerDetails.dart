import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favorites_service.dart';
import 'RatingInterface.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  UserDetailsScreen({required this.userId});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}
class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool isFavorite = false;

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
            future: FirebaseFirestore.instance.collection("users").doc(widget.userId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final userData = snapshot.data!.data()!;
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  final currentUserId = currentUser.uid;
                  final favoritesCollection = FirebaseFirestore.instance.collection('favorites');

                  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: favoritesCollection
                        .where('userId', isEqualTo: currentUserId)
                        .where('favoriteUserId', isEqualTo: userData['userUID'])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        isFavorite = snapshot.data!.docs.isNotEmpty;
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
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RatingInterface(ratedUserID: widget.userId)),
                                      );
                                    },
                                    child: Text('Rate User'),
                                  ),
                                  SizedBox(width: 20),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isFavorite = !isFavorite; // Toggle the favorite status
                                      });
                                      addToFavorites(userData['userUID']);
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: isFavorite ? Colors.red : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                } else {
                  // User is not logged in
                  return Column(
                    children: [
                      Text(
                        'Please log in to manage favorites.',
                        style: TextStyle(color: Colors.white),
                      ),
                      // Add more profile items as needed
                    ],
                  );
                }
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