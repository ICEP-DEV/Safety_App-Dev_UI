// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);

import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) =>
    ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) =>
    json.encode(data.toJson());

class ChatMessageModel {
  ChatMessageModel(
      {required this.chatId,
      required this.to,
      required this.from,
      required this.message,
      required this.chatType,
      required this.toUserOnlineStatus,
      required this.isFromMe,
      required this.dateTime});

  int chatId;
  int to;
  int from;
  String message;
  String chatType;
  bool toUserOnlineStatus;
  //String dateTime
  bool isFromMe;
  String dateTime;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageModel(
        chatId: json["chat_id"],
        to: json["to"],
        from: json["from"],
        message: json["message"],
        chatType: json["chat_type"],
        toUserOnlineStatus: json["to_user_online_status"],
        isFromMe: json["is_from_me"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "to": to,
        "from": from,
        "message": message,
        "chat_type": chatType,
        "to_user_online_status": toUserOnlineStatus,
      };
}
