import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Chat/core/storage.dart';

class AvailableTravelerScreen extends StatefulWidget {
  const AvailableTravelerScreen({Key? key}) : super(key: key);

  @override
  _AvailableTravelerScreenState createState() =>
      _AvailableTravelerScreenState();
}

class _AvailableTravelerScreenState extends State<AvailableTravelerScreen> {
  late List<UserData> travelers = [];
  late String currentUserID;
  String _searchValue = '';

  @override
  void initState() {
    super.initState();
    // Fetch travelers from storage when the screen initializes
    fetchTravelers();
    fetchCurrentUserID();
  }

  void fetchTravelers() async {
    // Retrieve travelers from the storage
    travelers = await Storage.getUsers();
    setState(() {}); // Update the UI after fetching travelers
  }

  void fetchCurrentUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00aa9b),
        title: const Text("Available Travelers"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
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
                    hintText: 'Search for travelers...',
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
                padding: const EdgeInsets.all(16.0),
                color: const Color(0xFF232d4b),
                child: ListView.builder(
                  itemCount: travelers.length,
                  itemBuilder: (context, index) {
                    final traveler = travelers[index];
                    if (_searchValue.isNotEmpty &&
                        !traveler.name
                            .toLowerCase()
                            .contains(_searchValue.toLowerCase())) {
                      return SizedBox.shrink(); // Hide if not matched
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(traveler.avatarUrl),
                        ),
                        title: Text(
                          traveler.name,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF00aa9b),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Handle tapping on a traveler
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
