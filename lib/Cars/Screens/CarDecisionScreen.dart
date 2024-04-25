import 'package:flutter/material.dart';
import '../../Home/mainScreens/home_screen.dart';
import 'Add_Car.dart';

class CarDecisionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00aa9b),
        title: Text('Car Decision'),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF232d4b), // Set the body color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder image holder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                    image: AssetImage('images/SPLASH.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCarScreen()),
                  );
                },
                child: Text('Yes, I have a car'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('No, I don\'t have a car'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('I Already Set My Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
