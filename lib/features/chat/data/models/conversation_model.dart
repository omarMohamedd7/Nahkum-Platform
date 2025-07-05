import 'package:intl/intl.dart';

class ConversationModel {
  final List<Message> messages;

  ConversationModel({required this.messages});

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    var list = json['data']['data'] as List;
    List<Message> messagesList = list.map((i) => Message.fromJson(i)).toList();

    return ConversationModel(messages: messagesList);
  }
}

class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final bool isSender;
  final String message;
  final DateTime date;
  bool isSending;

  String formattedDate() {
    final Duration duration = date.difference(DateTime.now());
    if (duration > (Duration(days: 1))) {
      return DateFormat('dd-MM-yyyy hh:mm a').format(date);
    }

    return DateFormat('hh:mm a').format(date);
  }

  Message({
    this.id = 0,
    this.isSender = true,
    this.isSending = false,
    this.senderId = 0,
    required this.receiverId,
    required this.message,
    required this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      receiverId: int.parse(json['receiverId'].toString()),
      senderId: int.parse(json['senderId'].toString()),
      isSender: json['isSender'] ?? false,
      message: json['message'],
      date: DateTime.parse(json['createdAt'].toString()),
    );
  }

  factory Message.sendFromJson(Map<String, dynamic> map) {
    var json = map['data']['data'];
    var createdAt = DateTime.parse(json['createdAt'].toString());

    return Message(
      id: json['id'] ?? 0,
      receiverId: int.parse(json['receiverId'].toString()),
      senderId: int.parse(json['senderId'].toString()),
      isSender: json['isSender'] ?? false,
      message: json['message'],
      date: createdAt,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
    };
  }
}
