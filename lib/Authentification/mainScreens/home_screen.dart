import 'package:flutter/material.dart';
import 'package:goandgoapp/Profile/profile.dart';
import '../../Chat/screens/chat_screen.dart';
import '../../Chat/widgets/bottomNavigationBar.dart';
// Import the bottom navigation bar file

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: _buildScreen(), // Call a helper method to build the current screen
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
            // Navigate to the corresponding screen when an item is tapped
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/search');
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                break;
            }
          });
        },
      ),
    );
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return Placeholder(); // Replace Placeholder with the actual HomeScreen widget
      case 1:
        return Placeholder(); // Replace Placeholder with the actual SearchScreen widget
      case 2:
        return ChatScreen(); // Show the ChatScreen when 'New Message' is selected
      case 3:
        return ProfileScreen(); // Show the ProfileScreen when 'Profile' is selected
      default:
        return Placeholder(); // Default to a Placeholder if the index is not recognized
    }
  }
}
