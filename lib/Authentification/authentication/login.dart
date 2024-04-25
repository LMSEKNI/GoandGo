import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goandgoapp/Authentification/global/global.dart';
import 'package:goandgoapp/Authentification/widgets/custom_text_field.dart';
import 'package:goandgoapp/Authentification/widgets/error_dialog.dart';
import 'package:goandgoapp/Authentification/widgets/loading_dialog.dart';

import '../../Cars/Screens/CarDecisionScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Please write email/password.",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return const LoadingDialog(
            message: "Checking Credentials",
          );
        });

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => CarDecisionScreen()));
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance.collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", snapshot.data()!["userEmail"]);
      await sharedPreferences!.setString("name", snapshot.data()!["userName"]);
      await sharedPreferences!.setString("photoUrl", snapshot.data()!["userAvatarUrl"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecre: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00aa9b),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: () {
                formValidation();
              },
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
              ),
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

}
