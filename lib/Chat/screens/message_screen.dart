
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../core/storage.dart';
import '../core/variables.dart';
import '../models/driver.dart';
import '../models/passenger.dart';
import '../widgets/message_item.dart';
import '../models/people.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  var messageController = TextEditingController();

  // Ensure user authentication, redirect to welcome screen if not authenticated.
  getUser() async {
    Storage storage = Storage();
    var user = await storage.loadUser();
    if (user == null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/welcome", (route) => false);
    }
  }

  // Call getUser() when screen is loaded.
  @override
  void initState() {
    super.initState();
    getUser();
  }

  // Function to send message.
  sendMessage(_, index, func) {
    dynamic currentTime = DateFormat('hh:mm a').format(DateTime.now());
    setState(() {
      messages[index].add(
        MessageItem(
          message: messageController.text,
          time: currentTime,
          isMe: false,
        ),
      );
      peopleList[index].lastMessage = messageController.text;
      peopleList[index].unreadCount = -1;
      peopleList[index].dateTime = currentTime;
    });
    func();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final People people = arguments[0];
    final int index = arguments[1];
    final Function func = arguments[2];

    return Scaffold(

      extendBodyBehindAppBar: true,
      appBar: buildAppBar(people),
      body: buildMessageBody(index, func),
    );
  }

  // Builds the app bar.
  AppBar buildAppBar(People people) {
    return AppBar(
      scrolledUnderElevation: 0,
      toolbarHeight: 100.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      title: buildAppBarTitle(people),
      backgroundColor: Colors.white,
    );
  }

  // Builds the title section of the app bar.
  Widget buildAppBarTitle(People people) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildProfileInfo(people),
        buildActionIcons(),
        buildUserType(people), // Add this line to display user type
      ],
    );
  }

// Builds the user type (passenger or driver) next to the name
  Widget buildUserType(People people) {
    String userType = '';
    // Check if the People object is an instance of Passenger or Driver
    if (people is Passenger) {
      userType = 'Passenger';
    } else if (people is Driver) {
      userType = 'Driver';
    }

    // Display the user type if it's not empty
    if (userType.isNotEmpty) {
      return Text(
        userType,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      );
    } else {
      // Return an empty container if the user type is empty
      return Container();
    }
  }

  // Builds the profile information section in the app bar.
  Widget buildProfileInfo(People people) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(people.avatarUrl),
          radius: 25,
        ),
        const Gap(10),
        buildNameAndStatus(people),
      ],
    );
  }

  // Builds the name and status part of the profile information.
  Widget buildNameAndStatus(People people) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          people.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        getOnlineOrOffline(),
      ],
    );
  }

  // Builds action icons in the app bar.
  Widget buildActionIcons() {
    return Row(
      children: [
        Icon(Icons.videocam),
        const Gap(25),
        Icon(Icons.phone),
      ],
    );
  }

  // Builds the body of the message screen.
  Widget buildMessageBody(int index, Function func) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 241, 241, 241),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildMessageList(index),
            ),
          ),
          buildMessageInputSection(index, func),
        ],
      ),
    );
  }

  // Builds the list of messages.
  Widget buildMessageList(int index) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...messages[index],
        ],
      ),
    );
  }

  // Builds the message input section.
  Widget buildMessageInputSection(int index, Function func) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onSubmitted: (value) => sendMessage(value, index, func),
                  controller: messageController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type here...',
                    hintStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              VerticalDivider(color: Colors.black.withOpacity(0.2)),
              const Gap(15),
              Row(
                children: [
                  Icon(Icons.mood, size: 25, color: Colors.black.withOpacity(0.5)),
                  const Gap(17),
                  Icon(Icons.photo_camera, size: 25, color: Colors.black.withOpacity(0.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Returns a widget indicating whether the user is online or offline.
  Widget getOnlineOrOffline() {
    int rand = Random().nextInt(2) + 1;
    switch (rand) {
      case 1:
        return const Text(
          "Online",
          style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 58, 158, 62)),
        );
      default:
        return const Text(
          "Offline",
          style: TextStyle(fontSize: 16, color: Colors.red),
        );
    }
  }
}
