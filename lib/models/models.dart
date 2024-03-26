import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




//UserModel
class UserModel {
  String? id;
  String? uid;
  String? name;
  String? firstName;
  String? lastName;
  String? photoUrl;
  String? email;
  String? phoneNumber;
  bool isAdd=false;
  UserModel({


     this.id,
     this.uid,
     this.name,
     this.firstName='',
     this.lastName='',
     this.email,
     this.phoneNumber,
     this.photoUrl,
  });

  factory UserModel.fromJson(json) {
    var data;

    if(Map<String,dynamic>().runtimeType!=json.runtimeType)
       data=json.data();
    else
      data=json;
    String name=json["name"]??'${json["firstName"]??''} ${json["lastName"]??''}';
    return UserModel(
        id: json['id'],
        uid: json["uid"],
        name: name,
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        photoUrl: json["photoUrl"],
    );
  }
  factory UserModel.init(){
    return UserModel(id: "", uid: '', name: '', email: '', phoneNumber: '',);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'name': name,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phoneNumber': phoneNumber,
    'photoUrl': photoUrl,


  };
}
//users
class Users {
  List<UserModel> users;

  //DateTime date;

  Users({required this.users});

  factory Users.fromJson(json) {
    List<UserModel> tempUsers = [];

    for (int i = 0; i < json.length; i++) {
      UserModel tempUser = UserModel.fromJson(json[i]);
      tempUser.id = json[i].id;
      tempUsers.add(tempUser);
    }
    return Users(users: tempUsers);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tempUsers = [];
    for (UserModel user in users) {
      tempUsers.add(user.toJson());
    }
    return {
      'users': tempUsers,
    };
  }


}







//Message
class Message {
  String id;
   bool checkSend;
   num statSend;
   int index;
  String textMessage;
   int sizeFile;
   String url;
  // String urlTempPhoto;
   String localUrl;
   String typeMessage;
  String senderId;
  String receiveId;
  // String replayId;
  DateTime sendingTime;
  // List deleteUserMessage;
  Message(
      {this.id="",
         this.index=-1,
         this.sizeFile=0,
         this.checkSend=true,
         this.statSend=0,
        required this.textMessage,
         this.url="",
        // this.urlTempPhoto="",
         this.localUrl="",
        // required this.replayId,
         required this.typeMessage,
        required this.senderId,
        required this.receiveId,
        // required this.deleteUserMessage,
        required this.sendingTime});
  factory Message.fromJson( json){
    // List<String> tempDeleteUserMessage = [];
    // for(String user in json["deleteUserMessage"]){
    //   tempDeleteUserMessage.add(user);
    // }
     String tempUrl="";
     if(!json["typeMessage"].contains('text')){
       tempUrl=json["url"];
     }
     String tempLocalUrl="";
     tempLocalUrl=json["localUrl"];
     // if(json.containsKey("localUrl")){
     //   tempLocalUrl=json["localUrl"];
     // }
     int tempSizeFile=0;
     tempSizeFile=json["sizeFile"];
     // if(json.containsKey("sizeFile")){
     //   tempSizeFile=json["sizeFile"];
     // }
    // String tempUrlTempPhoto="";
    // if(json.data().containsKey("urlTempPhoto")){
    //   tempUrlTempPhoto=json["urlTempPhoto"];
    // }
    return Message(
       url: tempUrl,
       localUrl: tempLocalUrl,
      textMessage: json["textMessage"],
       typeMessage: json["typeMessage"],
      sendingTime: json["sendingTime"].toDate(),
      senderId: json["senderId"],
      receiveId: json["receiveId"],

      index: json["index"],
      // deleteUserMessage: tempDeleteUserMessage,
      // urlTempPhoto: tempUrlTempPhoto,
       sizeFile: tempSizeFile,
      // replayId: json["replayId"]
    );
  }
  Map<String,dynamic> toJson() {
    // List tempDeleteUserMessage = [];
    // for(String user in deleteUserMessage){
    //   tempDeleteUserMessage.add(user);
    // }

    return {
      'textMessage': textMessage,
        'typeMessage': typeMessage,
      'senderId': senderId,
      'receiveId': receiveId,
      'sendingTime': Timestamp.fromDate(sendingTime),
      'index': index,
      // 'deleteUserMessage': tempDeleteUserMessage,
      // 'urlTempPhoto': urlTempPhoto,
       'sizeFile': sizeFile,
      // 'replayId': replayId,
       'url': url,
       'localUrl': localUrl,
    };
  }
  factory Message.init(){
    return Message(textMessage: '', senderId: '', receiveId: '', sendingTime: DateTime.now(), typeMessage: 'text');
  }
}
//Messages
class Messages {
  List<Message> listMessage;



  Messages({required this.listMessage});

  factory Messages.fromJson(json) {
    List<Message> temp = [];
    for (int i = 1; i < json.length; i++) {
      Message tempElement = Message.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Messages(listMessage: temp);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> temp = [];
    for (var element in listMessage) {
      temp.add(element.toJson());
    }
    return {
      'listMessage': temp,
    };
  }
}
//Chat
class Chat {
  String id;
  List<Message> messages;
  List<String> listIdUser;
  DateTime date;

  Chat({
    this.id='',
    required this.messages,
    required this.listIdUser,
    required this.date,
  });
  factory Chat.fromJson( json){
    List<Message> listTemp = [];
    // for(int i=1;i<json['messages'].length;i++){
    //   Message tempMessage=Message.fromJson(json['messages'][i]);
    //   tempMessage.id=json['messages'][i].id;
    //   listTemp.add(tempMessage);
    // }
    List<String> listTemp2=[];
    for(String temp in json['listIdUser'])
      listTemp2.add(temp);
    return Chat(
      id: json['id'],
      listIdUser: listTemp2,
      messages: listTemp,//json["messages"],
      date: json["date"].toDate(),
    );
  }

  Map<String,dynamic> toJson(){
    List<Map<String,dynamic>> listTemp = [];
    for(Message message in messages){
      listTemp.add(message.toJson());
    }
    return {
      'id':id,
      'date':date,
      // 'messages':listTemp,
      'listIdUser':listIdUser,
    };
  }
  factory Chat.init(){
    return Chat(messages: [], listIdUser: [], date: DateTime.now());
  }
}

//Chats
class Chats {
  List<Chat> listChat;

  //DateTime date;

  Chats({required this.listChat});

  factory Chats.fromJson(json) {
    List<Chat> temp = [];
    for (int i = 0; i < json.length; i++) {
      Chat tempElement = Chat.fromJson(json[i]);
      tempElement.id = json[i].id;
      temp.add(tempElement);
    }
    return Chats(listChat: temp);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> temp = [];
    for (var element in listChat) {
      temp.add(element.toJson());
    }
    return {
      'listChat': temp,
    };
  }
}
enum TypeMessage{
  text,
  image,
  file,
}
enum StateStream{
Wait,
  Empty,
  Error
}
