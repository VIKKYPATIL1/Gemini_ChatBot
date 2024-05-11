import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gemini_ai_new/provider/chat_provider.dart';
import 'package:gemini_ai_new/utility/show_dialog_box.dart';
import 'package:gemini_ai_new/widgets/preview_Images.dart';
import 'package:image_picker/image_picker.dart';

class ChatField extends StatefulWidget {
  const ChatField({super.key, required this.chatProvider});
  final ChatProvider chatProvider;
  @override
  State<ChatField> createState() {
    return _ChatField();
  }
}

class _ChatField extends State<ChatField> {
  final TextEditingController _msgctr = TextEditingController();
  final FocusNode textFieldFocas = FocusNode();
  final ImagePicker imagePicker = ImagePicker();
  @override
  void dispose() {
    _msgctr.dispose();
    super.dispose();
  }

  Future<void> sendMessage(
      {required String message,
      required ChatProvider chatProvider,
      required bool isTextOnly}) async {
    try {
      await chatProvider.sendMessage(message: message, isTextOnly: isTextOnly);
    } catch (err) {
      print("errors is $err");
    } finally {
      _msgctr.clear();
      widget.chatProvider.setFileList(FileList: []);

      textFieldFocas.unfocus();
    }
  }

  void pickImages() async {
    try {
      final pickedImages = await imagePicker.pickMultiImage(
          imageQuality: 95, maxHeight: 800, maxWidth: 800);
      widget.chatProvider.setFileList(FileList: pickedImages);
    } catch (err) {
      print("Image Picker Error :  $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImage = widget.chatProvider.imageFileList.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(204, 208, 207, 1),
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            if (hasImage) const PreviewImages(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (hasImage) {
                      showDialogBox(
                          context: context,
                          content: "Are you really want to remove image",
                          title: "Delete Image",
                          actionText: "Delete",
                          onActionPressed: (value) {
                            if (value) {
                              widget.chatProvider.setFileList(FileList: []);
                            }
                          });
                    } else {
                      pickImages();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                        hasImage ? Icons.delete_forever : Icons.image_rounded),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    cursorOpacityAnimates: true,
                    autofocus: true,
                    focusNode: textFieldFocas,
                    decoration: const InputDecoration.collapsed(
                        hintText: "Enter prompt here..."),
                    clipBehavior: Clip.hardEdge,
                    enableSuggestions: true,
                    controller: _msgctr,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: widget.chatProvider.isLoading
                      ? null
                      : () {
                          if (_msgctr.text.trim().isNotEmpty) {
                            sendMessage(
                                message: _msgctr.text,
                                chatProvider: widget.chatProvider,
                                isTextOnly: hasImage ? false : true);
                          }
                        },
                  child: Card(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 5,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(size: 30, Icons.arrow_upward_outlined),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
