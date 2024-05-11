import 'package:flutter/material.dart';
import 'package:gemini_ai_new/hive/boxes.dart';
import 'package:gemini_ai_new/hive/chat_history.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';
import 'package:gemini_ai_new/utility/show_dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<ChatHistory>>(
        valueListenable: Boxes.getChatHistory().listenable(),
        builder: (context, box, _) {
          final chatHistory =
              box.values.toList().cast<ChatHistory>().reversed.toList();
          return chatHistory.isEmpty
              ? GestureDetector(
                  onTap: () async {
                    // Here on click function will be created
                    final chatProvider = context.read<ChatProvider>();
                    await chatProvider.prepareChatRoom(
                        chatID: '', isNewChat: true);
                    chatProvider.setCurrentIndex(index: 1);
                    chatProvider.pagectr.jumpToPage(1);
                  },
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "No Chat Are there...\n" "Click here +",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = chatHistory[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Color.fromRGBO(238, 227, 203, 1),
                        enabled: true,
                        leading: const Icon(Icons.message),
                        title: Text(chat.prompt),
                        subtitle: Text(
                          chat.response,
                          maxLines: 1,
                        ),
                        trailing: Icon(Icons.arrow_forward_sharp),
                        onTap: () async {
                          final chatProvider = context.read<ChatProvider>();
                          await chatProvider.prepareChatRoom(
                              chatID: chat.chatId, isNewChat: false);
                          print("${chat.chatId} this is chat id");
                          chatProvider.setCurrentIndex(index: 1);
                          chatProvider.pagectr.jumpToPage(1);
                        },
                        onLongPress: () => showDialogBox(
                            context: context,
                            content:
                                "Are you sure you want to delete this Message?",
                            title: "Delete Message",
                            actionText: "Delete",
                            onActionPressed: (value) async {
                              if (value) {
                                // Delete the message
                                await context
                                    .read<ChatProvider>()
                                    .deleteMsgDB(chatId: chat.chatId);
                                await chat.delete();
                              }
                            }),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
