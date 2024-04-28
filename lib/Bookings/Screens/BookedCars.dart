import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Menu/Widgets/MenuButtonWidget.dart';

class BookedCarsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
        backgroundColor: Color(0xFF00aa9b),
      ),
      drawer: const MenuDrawer(),
      body: Container(
        color: Color(0xFF232d4b),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .where('userIDs', arrayContains: currentUserID)
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
            final List<DocumentSnapshot> bookingDocuments = snapshot.data!.docs;
            if (bookingDocuments.isEmpty) {
              return Center(
                child: Text('No cars booked.'),
              );
            }
            final carIDs = bookingDocuments.map((doc) => doc['carID']).toList();

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cars')
                  .where('carID', whereIn: carIDs)
                  .snapshots(),
              builder: (context, carSnapshot) {
                if (carSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!carSnapshot.hasData) {
                  return Center(
                    child: Text('No cars details found.'),
                  );
                }
                final List<DocumentSnapshot> carDocuments = carSnapshot.data!
                    .docs;
                if (carDocuments.isEmpty) {
                  return Center(
                    child: Text('No cars details found.'),
                  );
                }
                return ListView.builder(
                  itemCount: carDocuments.length,
                  itemBuilder: (context, index) {
                    final carData = carDocuments[index].data() as Map<
                        String,
                        dynamic>;
                    final carType = carData['carType'];
                    final numberOfSeats = carData['numberOfSeats'];
                    final carPhotoUrl = carData['photoUrl'];

                    final bookingData = bookingDocuments.firstWhere(
                          (doc) => doc['carID'] == carDocuments[index].id,
                      orElse: () => null as DocumentSnapshot,
                    );
                    if (bookingData == null) {
                      return SizedBox(); // Placeholder if booking data is null
                    }
                    final userIDs = bookingData['userIDs'] as List<dynamic>;
                    final userID = userIDs.isNotEmpty ? userIDs[0] : '';

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userID)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(); // Placeholder if user data is loading
                        }
                        if (!userSnapshot.hasData) {
                          return SizedBox(); // Placeholder if user data is not available
                        }
                        final userData = userSnapshot.data!.data() as Map<
                            String,
                            dynamic>;
                        final name = userData['userName'];
                        final email = userData['userEmail'];
                        final userPhotoUrl = userData['userAvatarUrl'];

                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    userPhotoUrl ?? ''),
                              ),
                              title: Text(name ?? ''),
                              subtitle: Text(email ?? ''),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Car Type: $carType'),
                                  Text('Number of Seats: $numberOfSeats'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}