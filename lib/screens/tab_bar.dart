// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:gemini_ai_new/provider/chat_provider.dart';
import 'package:gemini_ai_new/screens/sign_in_screen.dart';
import 'package:gemini_ai_new/screens/sign_up_screen.dart';
// import 'package:gemini_ai_new/utility/data_connection.dart';
// import 'package:provider/provider.dart';

class SignUpInTab extends StatefulWidget {
  const SignUpInTab({super.key});

  @override
  State<SignUpInTab> createState() => _SignUpInTabState();
}

class _SignUpInTabState extends State<SignUpInTab> {
  final pagesofsign = [const signUpScreen(), const SignInScreen()];
  final PageController ptr = PageController();
  int index = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ptr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: ptr,
        scrollBehavior: const MaterialScrollBehavior(),
        scrollDirection: Axis.horizontal,
        dragStartBehavior: DragStartBehavior.down,
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
        children: pagesofsign,
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 30,
          selectedItemColor: const Color.fromRGBO(204, 208, 207, 1),
          showUnselectedLabels: false,
          currentIndex: index,
          selectedFontSize: Checkbox.width,
          showSelectedLabels: true,
          onTap: (index) {
            setState(() {
              this.index = index;
              ptr.jumpToPage(index);
            });
          },
          items: const [
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.add_circle_outline),
                icon: Icon(
                  Icons.add_circle_rounded,
                ),
                label: "Sign Up"),
            BottomNavigationBarItem(
                activeIcon: Icon(Icons.draw_outlined),
                icon: Icon(
                  Icons.draw_rounded,
                ),
                label: "Sign In"),
          ]),
    );
  }
}
