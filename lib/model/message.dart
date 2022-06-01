class Message {
  final String description;
  final String senderUsername;
  final DateTime sentAt;

  Message({
    required this.description,
    required this.senderUsername,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> description) {
    return Message(
      description: description['description'],
      senderUsername: description['senderUsername'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(description['sentAt'] * 1000),
    );
  }
}
