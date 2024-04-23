import 'package:flutter/material.dart';
import '../../Profile/Profile.dart';
import '../core/storage.dart';
import '../widgets/bottomNavigationBar.dart'; // Import the CustomBottomNavigationBar widget

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<UserData> users = []; // Define a list to store the users

  @override
  void initState() {
    super.initState();
    // Fetch users from storage when the screen initializes
    fetchUsers();
  }

  void fetchUsers() async {
    // Retrieve users from the storage
    users = await Storage.getUsers();
    setState(() {}); // Update the UI after fetching users
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00aa9b),
        title: const Text("Chats"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFF232d4b),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF00aa9b),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  // Handle tapping on a user
                  // e.g., navigate to a chat screen with this user
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2, // Set the current index to 2 for the ChatScreen
        onTap: (index) {
          setState(() {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/search');
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            }
          });
        },
      ), // Add bottom navigation bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
