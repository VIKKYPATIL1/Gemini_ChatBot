import 'package:gemini_ai_new/constants.dart';
import 'package:gemini_ai_new/hive/chat_history.dart';
import 'package:gemini_ai_new/hive/user_model.dart';

import 'package:hive/hive.dart';

class Boxes {
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistory);
  static Box<UserModel> getUserModel() =>
      Hive.box<UserModel>(Constants.userModel);
}
