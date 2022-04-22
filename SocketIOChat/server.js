var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io'|| server);


//Reserved Events
let On_CONNECTION = 'connection';
let On_DISCONNECTION = 'disconnection';


//Main Events

let IS_USER_ONLINE = 'check_online';
let SINGLE_CHAT_MESSAGE = 'single_chat_message';



//Sub Events;

let RECEIVE_MESSAGE = 'received_message';
let USER_CONNECTED = 'is_user_connected';



  //Status
let STATUS_MESSAGE_NOT_SENT = 10001;
let  STATUS_MESSAGE_SENT = 10002;

let listen_port = 5001;

server.listen(listen_port);

const userMap = new  Map();

io.sockets.on(On_CONNECTION,function(socket){
 onEachUserConnection(socket);
});


function onEachUserConnection(socket){
 print('====================');
 print('Connected => Socket ID: '+ socket.id + ', User: '+ stringfyToJson(socket.handshake.query));
 var from_user_id = socket.handshake.query.from;
 let userMapVal = {socket_id:socket.id};
 addUserToMap(from_user_id , userMapVal);
 print(userMap);
 printOnlineUsers();

 onMessage(socket);  //sending messages to each other
 checkOnline(socket);

 onDisconnect(socket);
}

function onMessage(socket){
    socket.on(SINGLE_CHAT_MESSAGE , function (chat_message){
        singleChatHandler(socket, chat_message);
    });
}

function checkOnline(socket){
    socket.on(IS_USER_ONLINE , function (chat_user_details){
        onlineCheckHandler(socket ,chat_user_details);
    });

}

function onlineCheckHandler(socket ,chat_user_details){
 let to_user_id = chat_user_details.to;
 print('Checking Online User => ' + to_user_id);
 let to_user_socket_id= getSocketIDFromMapForThisUser(to_user_id);
 print('Online Socket ID:' + to_user_socket_id);
 let isOnline = undefined != to_user_socket_id;
 chat_user_details.to_user_online_status = isOnline;
 sendBackClient(socket, USER_CONNECTED , chat_user_details);
}


function singleChatHandler(socket ,chat_message){
    print('onMessage' + stringfyToJson(chat_message));
    let to_user_id = chat_message.to;
    let from_user_id = chat_message.from;
    print(from_user_id + "=>" + to_user_id);
    let to_user_socket_id = getSocketIDFromMapForThisUser(to_user_id);
    if(to_user_socket_id == undefined){
        print('Chat User not Connected');
        chat_message.to_user_online_status = false;
        return;
    }

    chat_message.to_user_online_status = true;
    sendToConnectedSocket(socket, to_user_socket_id , RECEIVE_MESSAGE,chat_message);
}


function sendBackClient(socket, RECEIVE_MESSAGE,chat_message) {
    socket.emit(RECEIVE_MESSAGE , stringfyToJson(chat_message) );
}


function sendToConnectedSocket(socket, to_user_socket_id , RECEIVE_MESSAGE,chat_message){
 socket.to(`${to_user_socket_id}`).emit(RECEIVE_MESSAGE ,stringfyToJson(chat_message));
}

function getSocketIDFromMapForThisUser(to_user_id){
    let userMapVal = userMap.get(`${to_user_id}`);
    if(undefined == userMapVal){
        return undefined;
    }
    return userMapVal.socket_id;

}

function removeUserWithSocketIDFromMap(socket_id){
 print('Deleting User: ' + socket_id);
 let toDeleteUser;
 for(key of userMap){
 let userMapVal = key[1];
 if(userMapVal.socket_id == socket_id){
    toDeleteUser = key[0];
 }
 }
 print('Deleting user: ' + toDeleteUser);
 if(undefined!= toDeleteUser){
     userMap.delete(toDeleteUser);
 }

 print(userMap);
 printOnlineUsers();
}


function onDisconnect(socket){
  socket.on(On_DISCONNECTION, function(){
    print('Disconnected '+ socket.id);
    removeUserWithSocketIDFromMap(socket_id);
    socket.removeAllListeners(On_DISCONNECTION);
    socket.removeAllListeners(RECEIVE_MESSAGE);
    socket.removeAllListeners(USER_CONNECTED);
  });
}

function addUserToMap(key_user_id , socket_id){
 userMap.set(key_user_id , socket_id);
}

function printOnlineUsers(){
    print('Online users' + userMap.size);


function print(txt){
    console.log(txt);
}

function stringfyToJson(data){
return JSON.stringify(data) ;
}
}