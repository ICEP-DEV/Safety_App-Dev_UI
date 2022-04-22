//IF CANNOT SEND THEN REMOVE NULLABLE ON SOCKETIO

import 'dart:io';
import 'package:adhara_socket_io/adhara_socket_io.dart';

import 'ChatMessageModel.dart';
import 'User.dart';

class SocketUtils {
  static String _serverIP =
      Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2';
  static const int SERVER_PORT = 5001;
  static String _connectUrl = '$_serverIP: $SERVER_PORT';

//Events
  static const String _ON_MESSAGE_RECEIVED = 'received_message';
  static const String _IS_USER_ONLINE = 'check_online';
  static const String SINGLE_CHAT_MESSAGE = 'single_chat_message';
  static const String USER_ONLINE = 'is_user_connected';

  //Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;

  //Tyoe of Chat

  static const String SINGLE_CHAT = 'single_chat';

  late User _fromUser;

  SocketIO? _socket;
  late SocketIOManager _manager;

  initSocket(User fromUser) async {
    this._fromUser = fromUser;
    print('Connecting...${fromUser.name}...');
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  connectToSocket() {
    if (null == _socket) {
      print('Socket is null');
      return;
    }
    _socket?.connect();
  }

  _socketOptions() {
    final Map<String, String> userMap = {
      "from": _fromUser.id.toString(),
    };
    return SocketOptions(_connectUrl,
        enableLogging: true,
        transports: [Transports.webSocket],
        query: userMap);
  }

  setOnConnectListener(Function onConnect) {
    _socket?.onConnect;
  }

  setOnConnectionTimedOutListener(Function onConnectTimeOut) {
    _socket?.onConnectTimeout;
  }

  setOnConnectErrorListener(Function onConnectionError) {
    _socket?.onReconnectError;
  }

  setOnErrorListener(Function onError) {
    _socket?.onError;
  }

  setOnDisconnectListner(Function onDisconnect) {
    _socket?.onDisconnect;
  }

  closeConnection() {
    if (null != _socket) {
      print("Closing Connection");
      _manager.clearInstance(_socket);
    }
  }

  sendSingleChatMessage(ChatMessageModel chatMessageModel) {
    if (null == _socket) {
      print('Cannot send message');
      return;
    }
    _socket?.emit(SINGLE_CHAT_MESSAGE, [chatMessageModel.toJson()]);
  }

  setOnChatMessageReceiveListener(Function onMessageReceived) {
    _socket?.on(_ON_MESSAGE_RECEIVED);
  }

  setOnlineUserStatusListener(Function onUserStatus) {
    _socket?.on(USER_ONLINE);
  }

  checkOnLine(ChatMessageModel chatMessageModel) {
    print('Checking online Id: ${chatMessageModel.to}');
    if (null == _socket) {
      print('Cannot check online');
      return;
    }
    _socket?.emit(_IS_USER_ONLINE, [chatMessageModel.toJson()]);
  }
}
