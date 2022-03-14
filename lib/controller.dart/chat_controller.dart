import 'package:completereport/models/message_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chatMessages = <Message>[].obs;
  var connectedUser = 0.obs;
}
