import 'package:flutter/material.dart';
import 'package:gemini_ai_new/models/message.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';
import 'package:gemini_ai_new/widgets/assistan_message.dart';
import 'package:gemini_ai_new/widgets/my_message.dart';
// import 'package:gemini_ai_by_chetan/widgets/assistan_message.dart';
// import 'package:gemini_ai_by_chetan/widgets/my_message.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key, required this.scrollController, required this.chatProvider});

  final ScrollController scrollController;
  final ChatProvider chatProvider;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatProvider.inChatMsg.length,
      itemBuilder: (context, index) {
        final message = chatProvider.inChatMsg[index];
        return message.role == Role.user
            ? MyMessage(message: message)
            : AssistantMessage(message: message.message.toString());
      },
    );
  }
}
