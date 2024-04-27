import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Profile/Profile.dart';
import '../../Bookings/Screens/BookedCars.dart';
import '../../Favorites/mainPage.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  User? user;
  String username = '';
  String userAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserData();
    }
  }

  void fetchUserData() {
    FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((userData) {
      if (userData.exists) {
        setState(() {
          username = userData.data()?['userName'] ?? 'User Name';
          userAvatarUrl = userData.data()?['userAvatarUrl'] ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color:  Color(0xFF232d4b),
            ),
            accountName: Text(username),
            accountEmail: Text('View profile'),
            currentAccountPicture: userAvatarUrl.isNotEmpty
                ? CircleAvatar(backgroundImage: NetworkImage(userAvatarUrl))
                : CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                username.isNotEmpty ? username[0] : 'U',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
            onDetailsPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('My rides'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookedCarsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('favorites'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen_main()));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_mark),
            title: Text('support'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.info_rounded),
            title: Text('about'),
            onTap: () {
              //
            },
          ),
          // ... Add other ListTiles for the rest of the menu items
        ],
      ),
    );
  }
}
