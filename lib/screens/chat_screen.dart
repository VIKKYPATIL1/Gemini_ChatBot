import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:gemini_ai_by_chetan/models/message.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';
// import 'package:gemini_ai_by_chetan/widgets/assistan_message.dart';
import 'package:gemini_ai_new/widgets/chat_field.dart';
import 'package:gemini_ai_new/widgets/chat_message.dart';
// import 'package:gemini_ai_by_chetan/widgets/my_message.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          scrollController.position.maxScrollExtent > 0.0) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastEaseInToSlowEaseOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        if (chatProvider.inChatMsg.isNotEmpty) {
          scrollToBottom();
        }
        chatProvider.addListener(() {
          if (chatProvider.inChatMsg.isNotEmpty) {
            scrollToBottom();
          }
        });
        return Scaffold(
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartTop,
          floatingActionButton: FloatingActionButton(
            mini: true,
            elevation: 10,
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            onPressed: () {
              chatProvider.prepareChatRoom(chatID: '', isNewChat: true);
            },
            child: const Icon(size: 30, Icons.add),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: chatProvider.inChatMsg.isEmpty
                      ? const Center(
                          child: Text(
                            "Start Chatting",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ChatMessage(
                          scrollController: scrollController,
                          chatProvider: chatProvider),
                ),
                ChatField(
                  chatProvider: chatProvider,
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
