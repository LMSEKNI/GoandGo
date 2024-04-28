import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingManager {
  static void manageBooking(BuildContext context, String bookingID, String carID, int numberOfSeats) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Manage Booking'),
          content: Text('Choose an option for this booking:'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                acceptBooking(context, bookingID);
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                declineBooking(context, bookingID, carID, numberOfSeats);
              },
              child: Text('Decline'),
            ),
          ],
        );
      },
    );
  }

  static void acceptBooking(BuildContext context, String bookingID) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingID).update({
      'status': 'accepted'
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking accepted successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept booking')),
      );
    });
  }

  static void declineBooking(BuildContext context, String bookingID, String carID, int numberOfSeats) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingID).update({
      'status': 'declined'
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking declined successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decline booking')),
      );
    });
  }
}
