import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_ai_new/models/message.dart';
import 'package:gemini_ai_new/widgets/preview_Images.dart';

class MyMessage extends StatelessWidget {
  const MyMessage({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Color.fromRGBO(224, 200, 181, 1)),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (message.imageUrls.isNotEmpty)
                PreviewImages(
                  message: message,
                ),
              MarkdownBody(
                selectable: true,
                data: message.message.toString(),
              ),
            ],
          ),
        ));
  }
}
