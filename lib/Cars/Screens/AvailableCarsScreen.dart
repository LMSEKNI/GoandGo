import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableCarsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cars'),
        centerTitle: true,
        backgroundColor: Color(0xFF00aa9b), // Change app bar color
      ),
      body: Container(
        color: Color(0xFF232d4b), // Change body color
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('cars').snapshots(),
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
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final carData = documents[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      String carID = documents[index].id;
                      _showBookingDialog(context, carID, carData);
                    },
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
                        subtitle: Text('Serial Number: ${carData['serialNumber']}'),
                        trailing: Text('Seats: ${carData['numberOfSeats']}'),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, String carID, Map<String, dynamic> carData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Do you want to book this car?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _bookCar(context, carID, carData);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


  void _bookCar(BuildContext context, String carID, Map<String, dynamic> carData) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    int availableSeats = carData['numberOfSeats'];
    if (availableSeats > 0) {
      FirebaseFirestore.instance.collection('bookings').add({
        'carID': carID,
        'userID': currentUserID,
        'timestamp': DateTime.now(),
      }).then((value) {
        // Update number of seats for the booked car
        FirebaseFirestore.instance.collection('cars').doc(carID).update({
          'numberOfSeats': availableSeats - 1,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Car booked successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update number of seats')),
          );
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book car')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No seats available')),
      );
    }
  }
}
