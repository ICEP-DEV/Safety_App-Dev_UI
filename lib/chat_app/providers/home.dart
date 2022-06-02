import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  final List<Message> _descriptions = [];

  List<Message> get description => _descriptions;

  addNewMessage(Message description) {
    _descriptions.add(description);
    notifyListeners();
  }
}
