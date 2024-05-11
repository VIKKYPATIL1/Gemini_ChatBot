import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_ai_new/models/message.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class PreviewImages extends StatelessWidget {
  const PreviewImages({super.key, this.message});
  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      final messageToShow =
          message != null ? message!.imageUrls : chatProvider.imageFileList;
      final padding = message != null
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 8, right: 8);
      return Padding(
        padding: padding,
        child: SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: messageToShow.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(message != null
                        ? message!.imageUrls[index]
                        : chatProvider.imageFileList[index].path),
                    height: 80,
                    width: 80,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
