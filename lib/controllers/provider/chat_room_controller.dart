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


class ChatRoomController extends GetxController{
  Chat? chat = Get.arguments?["chat"] ?? '';
  final messageController = TextEditingController();
  List<Message> chatList = [];
  var getChat;
  late  String currentUserId;
  String? recId;
  @override
  void onInit() {
    currentUserId=getCurrentUserId();
    recId=getIdUserOtherFromList( chat?.listIdUser??[]);
    getChatFun();
    super.onInit();
    }

  getChatFun() async {
    getChat =_fetchChatStream(idChat: chat?.id??'');
    return getChat;
  }
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  _fetchChatStream({required String idChat}) {
    final result= FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
        .collection(AppConstants.collectionMessage)
        .orderBy("sendingTime")
        .snapshots();
    return result;

  }

  getIdUserOtherFromList(List<String> idUsers){
    String currentUserId=getCurrentUserId();
    for(String id in idUsers)
      if(id!=currentUserId)
        return id;
  }
  deleteChat(context,{required String idChat}) async{
    var result =await FirebaseFun
        .deleteChat(idChat: idChat);
    Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
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
  deleteMessage(context,{required String idChat,required Message message}) async{
    var result =await FirebaseFun
        .deleteMessage(idChat: idChat,
        message:message);
    result['status']??Const.TOAST(context,textToast: FirebaseFun.findTextToast(result['message'].toString()));
    return result;
  }

}
