import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AssistantMessage extends StatelessWidget {
  const AssistantMessage({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Color.fromRGBO(238, 227, 203, 1)),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          child: message.isEmpty
              ? SizedBox(
                  width: 50,
                  child: SpinKitSpinningLines(
                    itemCount: 20,
                    lineWidth: 2,
                    color: Colors.blue.shade400,
                    size: 30,
                  ),
                )
              : MarkdownBody(
                  selectable: true,
                  data: message,
                ),
        ));
  }
}
