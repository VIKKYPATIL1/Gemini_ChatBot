import 'package:flutter/material.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';
import 'package:gemini_ai_new/screens/chat_history.dart';
import 'package:gemini_ai_new/screens/chat_screen.dart';
import 'package:gemini_ai_new/screens/contactus.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PageController pagectr = PageController();
  final List<Widget> _pages = [
    const ProfileScreen(),
    const ChatScreen(),
    const ChatHistoryScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return Scaffold(
        body: PageView(
            controller: chatProvider.pagectr,
            onPageChanged: (index) {
              setState(() {
                chatProvider.setCurrentIndex(index: index);
                // _currentIndex = index;
              });
            },
            children: _pages),
        bottomNavigationBar: BottomNavigationBar(
            // type: BottomNavigationBarType.shifting,
            // enableFeedback: true,
            // selectedIconTheme: IconThemeData().copyWith(color: Colors.blue),
            // selectedItemColor: Colors.black,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            // selectedLabelStyle: const TextStyle(color: Colors.black),
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            currentIndex: chatProvider.currentIndex,
            elevation: 0,
            onTap: (index) {
              setState(() {
                // _currentIndex = index;
                chatProvider.setCurrentIndex(index: index);
                chatProvider.pagectr.jumpToPage(chatProvider.currentIndex);
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.connect_without_contact,
                    // color: Colors.black,
                  ),
                  label: "Contact"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    // color: Colors.black,
                  ),
                  label: "Chat"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history_outlined,
                    // color: Colors.black,
                  ),
                  label: "Chat History")
            ]),
      );
    });
  }
}
