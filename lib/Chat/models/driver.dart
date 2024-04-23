// driver.dart
import 'people.dart';
class Driver extends People {
  final String vehicleModel;

  Driver({
    required String name,
    required String gender,
    required String avatarUrl,
    required String lastMessage,
    required String dateTime,
    required int unreadCount,
    required this.vehicleModel,
  }) : super(
    gender: gender,
    name: name,
    avatarUrl: avatarUrl,
    lastMessage: lastMessage,
    dateTime: dateTime,
    unreadCount: unreadCount,
  );
}