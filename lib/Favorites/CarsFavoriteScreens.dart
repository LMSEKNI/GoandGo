import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CarsFavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Center(
              child: Text('No favorite cars found.'),
            );
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final favoriteData = documents[index].data() as Map<String, dynamic>;
              final favoriteUserId = favoriteData['favoriteUserId'];
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('cars')
                    .where('userID', isEqualTo: favoriteUserId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final carDocs = snapshot.data!.docs;
                  if (carDocs.isEmpty) {
                    return ListTile(
                    );
                  }
                  final carData = carDocs[0].data() as Map<String, dynamic>;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(carData['photoUrl']),
                      ),
                      title: Text(
                        carData['carType'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Number of Seats: ${carData['numberOfSeats']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      // Display more car information here
                      // Example: Text('Serial Number: ${carData['serialNumber']}')
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}