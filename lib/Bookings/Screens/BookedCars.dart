import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      body: Container(
        color: Color(0xFF232d4b), // Change body color
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
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(
                child: Text('No cars booked.'),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final bookingData = documents[index].data() as Map<
                    String,
                    dynamic>;
                final carID = bookingData['carID'];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('cars').doc(
                      carID).get(),
                  builder: (context, carSnapshot) {
                    if (carSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox(); // Placeholder while loading car details
                    }
                    if (carSnapshot.hasError || !carSnapshot.hasData) {
                      return SizedBox(); // Placeholder if car details not found
                    }
                    final carData = carSnapshot.data!.data() as Map<
                        String,
                        dynamic>;
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Change box color
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
                          leading: Image.network(
                            carData['photoUrl'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(carData['carType']),
                          subtitle: Text(
                              'Serial Number: ${carData['serialNumber']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              _cancelBooking(
                                  context, documents[index].id, carID,
                                  carData['numberOfSeats']);
                            },
                          ),
                        ),
                      ),
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

  void _cancelBooking(BuildContext context, String bookingID, String carID,
      int numberOfSeats) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Booking'),
          content: Text('Are you sure you want to cancel this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performCancellation(context, bookingID, carID, numberOfSeats);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _performCancellation(BuildContext context, String bookingID,
      String carID, int numberOfSeats) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingID)
        .delete()
        .then((_) {
      // Update number of seats for the canceled booking
      FirebaseFirestore.instance.collection('cars').doc(carID).update({
        'numberOfSeats': numberOfSeats + 1,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking canceled successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update number of seats')),
        );
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking')),
      );
    });
  }
}
