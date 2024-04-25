import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatRoomScreen extends StatefulWidget {
  final String userId1;
  final String userId2;
  final String? chatId;

  const ChatRoomScreen({Key? key, required this.userId1, required this.userId2, this.chatId}) : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late TextEditingController _messageController;
  late Stream<QuerySnapshot> _messageStream;
  String userName = '';

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _messageStream = FirebaseFirestore.instance
        .collection('chat')
        .where('userId1', isEqualTo: widget.userId1)
        .where('userId2', isEqualTo: widget.userId2)
        .orderBy('createdAt', descending: true)
        .snapshots();

    fetchUserName();
  }

  void fetchUserName() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId2).get();
    setState(() {
      userName = userDoc['userName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName), // Display the user's name dynamically
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final message = Message.fromFirestore(snapshot.data!.docs[index]);
                      return ListTile(
                        title: Text(message.content),
                        subtitle: Text(message.createdAt.toString()), // Display other details like createdAt
                        // You can customize the ListTile based on your message model
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No messages yet.'),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final newMessage = Message(
        userId1: widget.userId1,
        userId2: widget.userId2,
        content: content,
        createdAt: Timestamp.now(),
      );

      // If chatId is provided, update the existing document
      if (widget.chatId != null) {
        await FirebaseFirestore.instance.collection('chat').doc(widget.chatId).update({
          'messages': FieldValue.arrayUnion([newMessage.toMap()]),
        });
      } else {
        // Otherwise, add a new document and retrieve the chatId
        final docRef = await FirebaseFirestore.instance.collection('chat').add({
          'userId1': widget.userId1,
          'userId2': widget.userId2,
          'messages': [newMessage.toMap()], // Assuming messages is an array field in the document
        });

        // Fetch the document to get the chatId
        final docSnapshot = await docRef.get();
        final chatId = docSnapshot.id;

        // Navigate to the ChatRoomScreen with the obtained chatId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(
              userId1: widget.userId1,
              userId2: widget.userId2,
              chatId: chatId,
            ),
          ),
        );
      }
      _messageController.clear();
    }
  }
}
