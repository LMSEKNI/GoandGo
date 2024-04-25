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
        actions: [
          Expanded( // Wrap the search box with Expanded
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for cars...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Perform search based on input value
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            return Expanded(
              child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final carData = documents[index].data() as Map<String, dynamic>;
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
                          carData['photoUrl'], // Assuming the photoUrl contains the URL of the car's image
                          width: 60, // Adjust width as needed
                          height: 60, // Adjust height as needed
                          fit: BoxFit.cover,
                        ),
                        title: Text(carData['carType']),
                        subtitle: Text('Serial Number: ${carData['serialNumber']}'),
                        trailing: Text('Seats: ${carData['numberOfSeats']}'),
                        // You can display more details about the car as needed
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
