import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUserStatus(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        final userStatus = snapshot.data;

        final items = <BottomNavigationBarItem>[
          if (userStatus == 'driver') // Conditionally render the traveler icon
            const BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Traveler',
            ),
          if (userStatus != 'driver') // Conditionally render the cars icon
            const BottomNavigationBarItem(
              icon: Icon(Icons.car_rental),
              label: 'Cars',
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chat',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ];

        return BottomNavigationBar(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
        );
      },
    );
  }

  Future<String> fetchUserStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .get();

      if (userDataSnapshot.exists) {
        final userData = userDataSnapshot.data() as Map<String, dynamic>;
        final userStatus = userData['status'] as String;
        return userStatus;
      }
    }

    return '';
  }
}