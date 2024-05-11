// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String msgID;
  String chatID;
  Role role;
  StringBuffer message;
  List<String> imageUrls;
  DateTime time;

  Message({
    required this.msgID,
    required this.chatID,
    required this.role,
    required this.message,
    required this.imageUrls,
    required this.time,
  });

  Map<String, dynamic> toMap() => {
        'msgID': msgID,
        'chatID': chatID,
        'role': role.index,
        'message': message.toString(),
        'imageUrls': imageUrls,
        'time': time.toIso8601String(),
      };
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      msgID: map['msgID'],
      chatID: map['chatID'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imageUrls: List<String>.from(map['imageUrls']),
      time: DateTime.parse(map['time']),
    );
  }
  // factory Message.fromMap(Map<String, dynamic> map) {
  //   return Message(
  //     msgID: map['msgID'],
  //     chatID: map['chatID'],
  //     role: Role.values[map['role']],
  //     message: StringBuffer(map['message']),
  //     imageUrls: List<String>.from(map['imageUrls']),
  //     time: DateTime.fromMillisecondsSinceEpoch(map['time'] * 1000),
  //   );
  // }

  Message copyWith(
      {String? msgID,
      String? chatID,
      Role? role,
      StringBuffer? message,
      List<String>? imageUrls,
      DateTime? time}) {
    return Message(
        msgID: msgID ?? this.msgID,
        chatID: chatID ?? this.chatID,
        role: role ?? this.role,
        message: message ?? this.message,
        imageUrls: imageUrls ?? this.imageUrls,
        time: time ?? this.time);
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.msgID == msgID;
  }

  @override
  int get hashCode {
    return msgID.hashCode;
  }
}

enum Role { user, assistant }
