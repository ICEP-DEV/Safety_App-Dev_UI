import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

class ChatMessageModel {
  int chatId;
  int to;
  int from;
  String description;
  String chatType;
  bool toUserOnlineStatus;
  String dateTime;

  ChatMessageModel({
    required this.chatId,
    required this.to,
    required this.from,
    required this.description,
    required this.chatType,
    required this.toUserOnlineStatus,
    required this.dateTime,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        chatId: json["chat_id"],
        to: json["to"],
        from: json["from"],
        description: json["description"],
        chatType: json["chat_type"],
        toUserOnlineStatus: json['to_user_online_status'],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "to": to,
        "from": from,
        "description": description,
        "chat_type": chatType,
        "dateTime": dateTime,
      };
}
