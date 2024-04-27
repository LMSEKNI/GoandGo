import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingInterface extends StatelessWidget {
  final String ratedUserID;

  RatingInterface({required this.ratedUserID});

  @override
  Widget build(BuildContext context) {
    double rating = 0;
    String remarks = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00aa9b),
        title: Text('Rate User'),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF232d4b),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rate the user:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                rating = newRating;
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Add remarks (optional)',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: null,
              onChanged: (value) {
                remarks = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitRating(ratedUserID, rating, remarks);
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitRating(String ratedUserID, double rating, String remarks) {
    FirebaseFirestore.instance.collection('rates').add({
      'ratedUserID': ratedUserID,
      'rating': rating,
      'remarks': remarks,
    }).then((value) {
      print('Rating submitted successfully');
    }).catchError((error) {
      print('Failed to submit rating: $error');
    });
  }
}