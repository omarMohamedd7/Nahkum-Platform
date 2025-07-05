class SendMessageModel {
  final String? message;
  final int receiverId;
  SendMessageModel({
    required this.receiverId,
    this.message,
  });
  Map<String, dynamic> toJson() {
    var map = {
      'receiver_id': receiverId,
      'message': message,
    };

    return map;
  }
}
