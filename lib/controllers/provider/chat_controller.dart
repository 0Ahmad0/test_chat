import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';



import '../../common_widgets/constans.dart';
import '../../constants/app_constant.dart';
import '../../models/models.dart';
import '../../repo/firebase.dart';
import '../function.dart';


class ChatController extends GetxController{
  Chats chats=Chats(listChat: []);
  Chat chat=Chat.init();
  Chat chatSend=Chat.init();
  UserModel user=UserModel.init();

  ///add controller
  var getUsers;
  Users users=Users(users: []);
  _getUsersFun() async {
    getUsers = FirebaseFirestore.instance
        .collection(AppConstants.collectionUser)
        .snapshots();
    return getUsers;
  }
  ///
  var getChats;
  late  String currentUserId;
  @override
  void onInit() {
    currentUserId=getCurrentUserId();
    _getChatsFun();
    _getUsersFun();
    super.onInit();
  }
  _getChatsFun() async {
    getChats = fetchChatsStream(currentUserId);

    return getChats;
  }
  @override
  void dispose() {
    super.dispose();
  }

  createChat({required List<String> listIdUser}) async {
    var result=await fetchChatsByListIdUser(listIdUser: listIdUser);
    if(result['status']){
      if(result['body'].length<=0){
        result=await FirebaseFun.addChat(chat:
        Chat(messages: [], listIdUser: listIdUser, date: DateTime.now()));
        if(result['status'])
          await FirebaseFun.addMessage(message: Message.init(),idChat:result['body']['id'] );
      }
      else
        result=FirebaseFun.errorUser("Chat already found");
    }
    return result;
  }


  fetchUserById({required String id}) async {
    user=UserModel.init();
    var result=await FirebaseFun.fetchUserId(id: id, typeUser: AppConstants.collectionUser);
    if(result['status']&&result['body']!=null){
      user =UserModel.fromJson(result['body']);
    }else{
      var result=await FirebaseFun.fetchUserId(id: id, typeUser: AppConstants.collectionUser);
      if(result['status']&&result['body']!=null){
        user =UserModel.fromJson(result['body']);
      }else{
        var result=await FirebaseFun.fetchUserId(id: id, typeUser: AppConstants.collectionUser);
        if(result['status']&&result['body']!=null){
          user =UserModel.fromJson(result['body']);
        }
      }
    }
    return result;
  }
  fetchChatByListIdUser({required List<String> listIdUser}) async {
    var result=await createChat( listIdUser: listIdUser);
     result=await FirebaseFun.fetchChatsByListIdUser(listIdUser: listIdUser);
     if(result['status']){
       Chats chats=Chats.fromJson(result['body']);
       List<Chat> listTemp=[];
       for(var element in chats.listChat){
         bool check=true;
         for(String id in listIdUser){
           if(!element.listIdUser.contains(id))
             check=false;
         }
         for(String id in element.listIdUser){
           if(!listIdUser.contains(id))
             check=false;
         }
         if(check)
           listTemp.add(element);
       }
       chats.listChat=listTemp;
       result['body']=chats.toJson()['listChat'];
       if(chats.listChat.length>0)
       chat=chats.listChat.first;
       if(chatSend.id!=chat.id){
         chatSend=chat;
         chatSend.messages.clear();
       }
     }

    return result;
  }
  fetchChatsByListIdUser({required List listIdUser}) async {
    var result=await FirebaseFun.fetchChatsByListIdUser(listIdUser: listIdUser);
    Chats chats=Chats.fromJson(result['body']);
    List<Chat> listTemp=[];
    for(var element in chats.listChat){
      bool check=true;

      for(String id in listIdUser){
        // print(id);
        if(!element.listIdUser.contains(id))
          check=false;
      }
      // print(check);

      if(check)
        listTemp.add(element);
    }
    chats.listChat=listTemp;
    // print(chats.toJson());
    // print('---------------------------');
    result['body']=chats.toJson()['listChat'];
    return result;
  }
  fetchLastMessage(context,{required String idChat}) async{
    final result=await FirebaseFun.fetchLastMessage(idChat: idChat);
    Message message=Message.init();
    if(result['status']){
      message=Message.fromJson(result['body'][0]);
    }
    return message.toJson();
  }
  widgetLastMessage(context,{required String idChat}){
    return FutureBuilder(
      future: fetchLastMessage(
          context,
          idChat: idChat),
      builder: (
          context,
          snapshot,
          ) {
        print(snapshot
            .error);
        if (snapshot
            .connectionState ==
            ConnectionState
                .waiting) {
          return  Text('loading ...');
          // return  Text(tr(LocaleKeys.loading));
          //Const.CIRCLE(context);
        } else if (snapshot
            .connectionState ==
            ConnectionState
                .done) {
          if (snapshot
              .hasError) {
            return const Text(
                'Error');
          } else if (snapshot
              .hasData) {

            Message message =Message.fromJson(snapshot.data);
            // Map<String,dynamic> data=snapshot.data as Map<String,dynamic>;
            //homeProvider.sessions=Sessions.fromJson(data['body']);
            return Text(
                '${message.textMessage}'
            );
          } else {
            return const Text(
                'Empty data');
          }
        } else {
          return Text(
              'State: ${snapshot.connectionState}');
        }
      },
    );
  }

  fetchChatsStream(String idUser) {
    final result= FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .where('listIdUser',arrayContains: idUser)
    //    .orderBy("date")
        .snapshots();
    return result;

  }
  addMessage(context,{required String idChat,required Message message}) async{
    message.sendingTime=DateTime.now();
    var result =await FirebaseFun
        .addMessage(idChat: idChat,
        message:message);
    //print(result);
    result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  deleteMessage(context,{required String idChat,required Message message}) async{
    var result =await FirebaseFun
        .deleteMessage(idChat: idChat,
        message:message);
    result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }
  sendMessage(context,{required String idChat,required Message message}) async{
    var result;
    if(message.typeMessage.contains(TypeMessage.text.name)){
      await FirebaseFun
          .addMessage(idChat: idChat,
          message:message);
    }else{
      if(result==null){
        result =await FirebaseFun
            .addMessage(idChat: idChat,
            message:message);
      }

    }
    return result;
  }
  checkUsersIsAdd(){
    for(UserModel userModel in users.users){
     if(_checkUserIsAddChats(chats.listChat,userModel.id))
        userModel.isAdd=true;
    }
  }
  removeCurrentUser(){
    users.users.removeWhere((element) => element.id==getCurrentUserId());

  }
  bool _checkUserIsAddChats(List<Chat> chats,String? idUSer){
    for (Chat chat in chats)
      if(chat.listIdUser.contains(idUSer))
        return true;
    return false;
  }
  onError(error){
    return {
      'status':false,
      'message':error,
      //'body':""
    };
  }
}
