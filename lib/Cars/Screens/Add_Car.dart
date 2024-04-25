import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../Home/mainScreens/home_screen.dart';


class AddCarScreen extends StatefulWidget {
  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _carType;
  late String _serialNumber;
  late int _numberOfSeats;
  XFile? _carImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _carImage = pickedImage;
    });
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the current user's ID from Firebase Authentication
      String? userID = FirebaseAuth.instance.currentUser?.uid;
      if (userID == null) {
        // Handle the case when user is not logged in
        return;
      }

      // Upload image to Firebase Storage if an image was selected
      String photoUrl = '';
      if (_carImage != null) {
        photoUrl = await _uploadImage(File(_carImage!.path));
      }

      // Add car data to Firestore
      await FirebaseFirestore.instance.collection('cars').add({
        'carType': _carType,
        'serialNumber': _serialNumber,
        'numberOfSeats': _numberOfSeats,
        'photoUrl': photoUrl,
        'userID': userID,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Car added successfully!'),
        ),
      );

      // Navigate to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    // Upload image file to Firebase Storage and get the download URL
    final ref = FirebaseStorage.instance.ref().child('car_photos').child('${DateTime.now()}.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Car'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Car Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a car type';
                  }
                  return null;
                },
                onSaved: (value) => _carType = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Serial Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a serial number';
                  }
                  return null;
                },
                onSaved: (value) => _serialNumber = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Number of Seats'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of seats';
                  }
                  return null;
                },
                onSaved: (value) => _numberOfSeats = int.parse(value!),
              ),
              InkWell(
                onTap: () {
                  _selectImage();
                },
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _carImage == null ? null : FileImage(File(_carImage!.path)),
                  child: _carImage == null
                      ? Icon(
                    Icons.add_photo_alternate,
                    size: 80,
                    color: Colors.grey[400],
                  )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
