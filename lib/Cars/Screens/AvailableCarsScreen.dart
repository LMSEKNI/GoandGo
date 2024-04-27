import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Menu/Widgets/MenuButtonWidget.dart';
import 'CarDetailsScreen.dart';

class AvailableCarsScreen extends StatefulWidget {
  @override
  _AvailableCarsScreenState createState() => _AvailableCarsScreenState();
}

class _AvailableCarsScreenState extends State<AvailableCarsScreen> {
  late String _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cars'),
        centerTitle: true,
        backgroundColor: Color(0xFF00aa9b),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for cars...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchValue = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
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
                      if (_searchValue.isNotEmpty &&
                          !carData['carType'].toLowerCase().contains(_searchValue.toLowerCase())) {
                        return SizedBox.shrink(); // Hide if not matched
                      }
                      final String carOwnerID = carData['userID'];
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarDetailsScreen(carID:carData['carID'],carData: carData),
                              ),
                            );
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
                              leading: FutureBuilder<bool>(
                                future: checkFavoriteStatus(carOwnerID),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  final bool isFavorite = snapshot.data ?? false;
                                  final Color heartIconColor = isFavorite ? Colors.red : Colors.grey;
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        carData['photoUrl'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      Icon(
                                        Icons.favorite,
                                        color: heartIconColor,
                                      ),
                                    ],
                                  );
                                },
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
          ),
        ],
      ),
    );
  }

  Future<bool> checkFavoriteStatus(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final currentUserId = currentUser.uid;
      final favoritesCollection = FirebaseFirestore.instance.collection('favorites');

      final querySnapshot = await favoritesCollection
          .where('userId', isEqualTo: currentUserId)
          .where('favoriteUserId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    }
    return false;
  }
}