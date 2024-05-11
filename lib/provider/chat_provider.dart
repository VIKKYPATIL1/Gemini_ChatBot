// import 'dart:ffi';
import 'dart:typed_data';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini_ai_new/api/api_service.dart';
import 'package:gemini_ai_new/constants.dart';
import 'package:gemini_ai_new/hive/boxes.dart';
import 'package:gemini_ai_new/hive/chat_history.dart';
import 'package:gemini_ai_new/hive/setting.dart';
import 'package:gemini_ai_new/hive/user_model.dart';
import 'package:gemini_ai_new/models/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _inChatMsg = [];

  final PageController _pagectr = PageController();

  List<XFile> _imageFileList = [];

  int _currentIndex = 0;

  String _currentChatID = '';

  // Models
  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;

  //Current Model
  String _modelType = 'gemini-pro';
  //Is loding indicator
  bool _isLoading = false;

// Getters
  List<Message> get inChatMsg => _inChatMsg;

  PageController get pagectr => _pagectr;

  List<XFile> get imageFileList => _imageFileList;

  int get currentIndex => _currentIndex;

  String get currentChatID => _currentChatID;

  GenerativeModel? get model => _model;

  GenerativeModel? get textModel => _textModel;

  GenerativeModel? get visionModel => _visionModel;

  String get modelType => _modelType;

  bool get isLoading => _isLoading;

  //Setting inChatMessage from database
  Future<void> setInChatMsg({required String chatID}) async {
    final messageFromDb = await loadMsgFromDb(chatID: chatID);
    for (var message in messageFromDb) {
      if (_inChatMsg.contains(message)) {
        // print(message);
        continue;
      }
      _inChatMsg.add(message);
    }
    notifyListeners();
  }

  // Load data from Hive Database
  Future<List<Message>> loadMsgFromDb({required String chatID}) async {
    await Hive.openBox('${Constants.chatIdbox}$chatID');
    final messageBox = Hive.box('${Constants.chatIdbox}$chatID');
    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      final messageData = Message.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();
    notifyListeners();
    return newData;
  }

  Future<void> deleteMsgDB({required String chatId}) async {
    if (!Hive.isBoxOpen("${Constants.chatIdbox}$chatId")) {
      await Hive.openBox("${Constants.chatIdbox}$chatId");
      await Hive.box("${Constants.chatIdbox}$chatId").clear();
      await Hive.box("${Constants.chatIdbox}$chatId").close();
    } else {
      await Hive.box("${Constants.chatIdbox}$chatId").clear();
      await Hive.box("${Constants.chatIdbox}$chatId").close();
    }
    if (currentChatID.isNotEmpty) {
      if (currentChatID == chatId) {
        _inChatMsg.clear();
        notifyListeners();
      }
    }
  }

  // Prepare Chat Room
  Future<void> prepareChatRoom({
    required String chatID,
    required bool isNewChat,
  }) async {
    print("${chatID} this is chat id in prepare chat room");
    if (!isNewChat) {
      // 1. Load Message from DB

      final chatHistory = await loadMsgFromDb(chatID: chatID);
      // 2. Clear the InChat Message Data
      _inChatMsg.clear();
      // print(chatHistory.length);
      for (var msg in chatHistory) {
        _inChatMsg.add(msg);
        print("$msg hello");
      }
      // print(_inChatMsg.length);
      setCurrentChatId(chatID: chatID);
    } else {
      _inChatMsg.clear();
      setCurrentChatId(chatID: chatID);
    }
  }

  // Here set Image file list
  // ignore: non_constant_identifier_names
  void setFileList({required List<XFile> FileList}) {
    _imageFileList = FileList;
    notifyListeners();
  }

  // Here We will set the Model type
  String setGenerativeModel({required String model}) {
    _modelType = model;
    notifyListeners();
    return _modelType;
  }

  //Function to set model based on the textonly boolean value
  Future<void> setModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _model = _textModel ??
          GenerativeModel(
              model: setGenerativeModel(model: 'gemini-pro'),
              apiKey: ApiService.apiKey);
    } else {
      _model = _visionModel ??
          GenerativeModel(
              model: setGenerativeModel(model: 'gemini-pro-vision'),
              apiKey: ApiService.apiKey);
    }
    notifyListeners();
  }

  // Setter for current page index
  void setCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }

  // Setter for Current Chat ID
  void setCurrentChatId({required String chatID}) {
    _currentChatID = chatID;
    notifyListeners();
  }

  // setter for loading
  void setLoading({required bool newloading}) {
    _isLoading = newloading;
    notifyListeners();
  }

  // Send Message to Gemini and get String response
  Future<void> sendMessage(
      {required String message, required bool isTextOnly}) async {
    await setModel(isTextOnly: isTextOnly);
    // set Loading to true
    setLoading(newloading: true);

    // Getting the current Chat ID
    String chatID = getChatID();
    // List of message history
    List<Content> history = [];
    // Get Chat History
    history = await getHistory(chatID: chatID);

    // get Image Urls
    List<String> imageUrls = getImageUrls(isTextOnly: isTextOnly);
    //Creating msg id
    // final userMsgId = const Uuid().v4();
    final messageBox = await Hive.openBox('${Constants.chatIdbox}$chatID');

    // Get Last user msg ID
    final userMsgID = messageBox.keys.length;
    // Assistant msgID
    final assistantMsgID = messageBox.keys.length + 1;
    //user message
    final userMessage = Message(
        msgID: userMsgID.toString(),
        chatID: chatID,
        role: Role.user,
        message: StringBuffer(message),
        imageUrls: imageUrls,
        time: DateTime.now());

    // Add this message to in chat message
    _inChatMsg.add(userMessage);
    notifyListeners();
    // checking current chat id is empty or not
    if (currentChatID.isEmpty) {
      setCurrentChatId(chatID: chatID);
    }

    // Send message and wait for response to model
    await sendMessageAndWaitResponse(
      message: message,
      chatID: chatID,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
      modelMessageID: assistantMsgID.toString(),
      messageBox: messageBox,
    );
  }

  // Creating method to send message to model and wait for response
  Future<void> sendMessageAndWaitResponse(
      {required String message,
      required String chatID,
      required bool isTextOnly,
      required List<Content> history,
      required Message userMessage,
      required String modelMessageID,
      required Box messageBox}) async {
    // here we will start chat session
    final chatSession = _model!
        .startChat(history: history.isEmpty || !isTextOnly ? null : history);
    // here we will get content
    final content = await getContent(message: message, isTextOnly: isTextOnly);
    // Creating assistant message id
    // final modelMsgId = const Uuid().v4();
    // assistant message
    final assistantMessage = userMessage.copyWith(
      msgID: modelMessageID,
      role: Role.assistant,
      message: StringBuffer(),
      time: DateTime.now(),
    );
    //add this message to the list in inchatmessage
    _inChatMsg.add(assistantMessage);
    notifyListeners();
    //sending message to the model

    chatSession.sendMessageStream(content).asyncMap((event) => event).listen(
        (event) {
      _inChatMsg
          .firstWhere((element) =>
              element.msgID == assistantMessage.msgID &&
              element.role.name == Role.assistant.name)
          .message
          .write(event.text);
      notifyListeners();
    }, onDone: () async {
      // Store to hive database and set load to false
      await saveMessageToDB(
          chatID: chatID,
          userMessage: userMessage,
          assistantMessage: assistantMessage,
          messageBox: messageBox);
      // Onloading to false
      setLoading(newloading: false);
    }).onError((err, stackTrace) {
      setLoading(newloading: false);
    });
  }

  // Creating method to save message data to hive data Base
  Future<void> saveMessageToDB(
      {required String chatID,
      required Message userMessage,
      required Message assistantMessage,
      required Box messageBox}) async {
    // final messageBox = await Hive.openBox('$chatID');
    // print(chatID);
    // Saving User Message to DB
    await messageBox.add(userMessage.toMap());
    // Saving assistant Message to DB
    await messageBox.add(assistantMessage.toMap());

    // Create a Chat History box if their update otherwise create

    final chatHistoryBox = Boxes.getChatHistory();

    final chatHistory = ChatHistory(
        chatId: chatID,
        prompt: userMessage.message.toString(),
        response: assistantMessage.message.toString(),
        imageUrls: userMessage.imageUrls,
        timestamp: DateTime.now());

    await chatHistoryBox.put(chatID, chatHistory);
    // print(chatHistoryBox.containsKey("chatId"));
    // Closing the Hive Box
    // chatHistoryBox.close();
    await messageBox.close();
  }

  // Creating method to get content
  Future<Content> getContent(
      {required String message, required bool isTextOnly}) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = _imageFileList
          .map((imagefile) => imagefile.readAsBytes())
          .toList(growable: false);
      final imageByte = await Future.wait(imageFutures);
      final prompt = TextPart(message);
      final imagePart = imageByte
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();
      return Content.multi([prompt, ...imagePart]);
    }
  }

  // get the Image URLS
  List<String> getImageUrls({required bool isTextOnly}) {
    List<String> imageUrls = [];
    if (!isTextOnly && imageFileList.isNotEmpty) {
      for (var img in imageFileList) {
        imageUrls.add(img.path);
      }
    }
    return imageUrls;
  }

  Future<List<Content>> getHistory({required String chatID}) async {
    List<Content> history = [];
    if (currentChatID.isNotEmpty) {
      await setInChatMsg(chatID: chatID);
      // print("${chatID} this is chat id in get History");
      for (var message in inChatMsg) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }
    return history;
  }

  // Get the current Chat ID
  String getChatID() {
    if (currentChatID.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatID;
    }
  }

  // Hive Initialization
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDb);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());

      await Hive.openBox<ChatHistory>(Constants.chatHistory);
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());

      await Hive.openBox<UserModel>(Constants.userModel);
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());

      await Hive.openBox<Settings>(Constants.settings);
    }
  }
}
