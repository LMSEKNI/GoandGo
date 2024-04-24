import 'package:flutter/material.dart';
import 'package:goandgoapp/Profile/profile.dart';
import '../../Chat/screens/chat_screen.dart';
import '../../Chat/widgets/bottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return Placeholder();
      case 1:
        return Placeholder();
      case 2:
        return ChatScreen();
      case 3:
        return ProfileScreen();
      default:
        return Placeholder();
    }
  }
}
