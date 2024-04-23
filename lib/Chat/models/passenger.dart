// passenger.dart
import 'people.dart';

class Passenger extends People {
  final String passengerId;

  Passenger({
    required String name,
    required String gender,
    required String avatarUrl,
    required String lastMessage,
    required String dateTime,
    required int unreadCount,
    required this.passengerId,
  }) : super(
    name: name,
    gender:gender,
    avatarUrl: avatarUrl,
    lastMessage: lastMessage,
    dateTime: dateTime,
    unreadCount: unreadCount,
  );
}
