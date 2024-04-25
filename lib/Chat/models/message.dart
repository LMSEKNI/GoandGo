import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String userId1;
  final String userId2;
  final String content;
  final Timestamp createdAt;

  Message({
    required this.userId1,
    required this.userId2,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId1': userId1,
      'userId2': userId2,
      'content': content,
      'createdAt': createdAt,
    };
  }

  factory Message.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Message(
      userId1: data['userId1'],
      userId2: data['userId2'],
      content: data['content'],
      createdAt: data['createdAt'],
    );
  }
}
