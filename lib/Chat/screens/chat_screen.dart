import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Menu/Widgets/MenuButtonWidget.dart';
import '../core/storage.dart';
import 'ChatRoomScreen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<UserData> users = [];
  late String currentUserID;

  @override
  void initState() {
    super.initState();
    // Fetch users from storage when the screen initializes
    fetchUsers();
    fetchCurrentUserID();
  }

  void fetchUsers() async {
    // Retrieve users from the storage
    users = await Storage.getUsers();
    setState(() {}); // Update the UI after fetching users
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
        title: const Text("Chats"),
        centerTitle: true,
      ),
      drawer: const MenuDrawer(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFF232d4b),
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
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
                    _navigateToConversation(user);
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }



  void _navigateToConversation(UserData user) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          userId1: currentUserID,
          userId2: user.userId,
        ),
      ),
    );
  }
}
