import 'package:hive_flutter/hive_flutter.dart';

part 'chat_history.g.dart';

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  final String chatId;
  @HiveField(1)
  final String prompt;
  @HiveField(2)
  final String response;
  @HiveField(3)
  final List<String> imageUrls;
  @HiveField(4)
  final DateTime timestamp;
  ChatHistory(
      {required this.chatId,
      required this.prompt,
      required this.response,
      required this.imageUrls,
      required this.timestamp});
}
// build run build_runner build run this command to generate hive output files
