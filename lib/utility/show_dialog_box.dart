import 'package:flutter/material.dart';

void showDialogBox(
    {required BuildContext context,
    required String content,
    required String title,
    required String actionText,
    required Function(bool) onActionPressed}) async {
  showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.1, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: Color.fromRGBO(215, 192, 174, 1),
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                    onPressed: () {
                      onActionPressed(false);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      onActionPressed(true);
                      Navigator.of(context).pop();
                    },
                    child: Text(actionText))
              ],
            ),
          ),
        );
      });
}
