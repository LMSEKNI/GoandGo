// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../core/storage.dart';
import '../utils/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> user = {};

  // Function to handle logout action.
  logout() async {
    questionDialog(
      context: context,
      title: "Logout",
      content: "Are you sure want to logout from your account?",
      func: () async {
        Storage storage = Storage();
        await storage.clearUser();
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/welcome",
              (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You are successfully logged out."),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  // Function to load user information.
  getUser() async {
    Storage storage = Storage();
    var user = await storage.loadUser();
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/welcome", (route) => false);
    } else {
      setState(() {
        this.user = user;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildProfileBody(),
    );
  }

  // Builds the app bar.
  AppBar buildAppBar() {
    return AppBar(
      title: const Center(
        child: Text(
          "My Profile",
        ),
      ),
    );
  }

  // Builds the body of the profile screen.
  Widget buildProfileBody() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 241, 241, 241),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAvatarSection(),
            const Gap(20),
            const Divider(thickness: 2, endIndent: 15, indent: 15),
            const Gap(20),
            buildUserInfoSection(),
            const Gap(20),
            const Divider(thickness: 2, endIndent: 15, indent: 15),
            const Gap(20),
            buildStatisticsSection(),
            const Gap(20),
            const Divider(thickness: 2, endIndent: 15, indent: 15),
            const Gap(20),
            buildLogoutButton(),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  // Builds the avatar section.
  Widget buildAvatarSection() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(198, 255, 221, 1),
            Color.fromRGBO(251, 215, 134, 1),
            Color.fromRGBO(247, 121, 125, 1),
          ],
        ),
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 241, 241, 241),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: CircleAvatar(
            radius: 64,
            backgroundColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                "assets/images/profile-avatar.svg",
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the user information section.
  Widget buildUserInfoSection() {
    return Column(
      children: [
        Text(
          "${user['username']}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          "@${user['username']}",
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  // Builds the statistics section.
  Widget buildStatisticsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildStatistic("messages", "128"),
        buildStatistic("online time", "12 hours"),
        buildStatistic("is admin?", user['admin'] == "1" ? "Yes" : "No"),
      ],
    );
  }

  // Builds a single statistic widget.
  Widget buildStatistic(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }

  // Builds the logout button.
  Widget buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: logout,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          foregroundColor: Colors.white,
          elevation: 10,
          backgroundColor: Colors.red,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_outlined, size: 28),
            const Gap(10),
            Text(
              "Log Out",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
