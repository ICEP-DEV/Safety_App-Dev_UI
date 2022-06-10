import 'package:flutter/foundation.dart';
import 'package:completereport/chat_app/model/message.dart';

class HomeProvider extends ChangeNotifier {
  final List<Message> _descriptions = [];

  List<Message> get description => _descriptions;

  addNewMessage(Message description) {
    _descriptions.add(description);
    notifyListeners();
  }
}
