import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/app_constant.dart';
import '../models/models.dart';


class FirebaseFun{
  static var rest;

  static Duration timeOut =Duration(seconds: 30);
  static createUser( {required UserModel user}) async {
     final result= await FirebaseFirestore.instance.collection(AppConstants.collectionUser).add(
       user.toJson()
     ).then((value){
       user.id=value.id;
         return {
           'status':true,
           'message':'Account successfully created',
           'body': {
             'id':value.id
           }
      };
     }).catchError(onError);
       return result;
   }
   
  static fetchUser( {required String uid,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('uid',isEqualTo: uid)
        .get()
        .then((onValueFetchUser))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchUserId( {required String id,required String typeUser})  async {
    final result=await FirebaseFirestore.instance.collection(typeUser)
        .where('id',isEqualTo: id)
        .get()
        .then((onValueFetchUserId))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
  //  print("${id} ${result}");
    return result;
  }
  static fetchUsers()  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionUser)
        .get()
        .then((onValueFetchUsers))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

 
  
  ///Chat
  static addChat( {required Chat chat}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionChat).add(
        chat.toJson()
    ).then(onValueAddChat).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static deleteChat( {required String idChat}) async {
    final result =await FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
       .delete().then(onValueDeleteChat)
        .catchError(onError);
    return result;
  }
  static updateChat( {required Chat chat}) async {
    final result= await FirebaseFirestore.instance.collection(AppConstants.collectionChat).doc(
        chat.id
    ).update(chat.toJson()).then(onValueUpdateChat).catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchChatsByIdUser({required List listIdUser})  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionChat)
        .where('listIdUser',arrayContains: listIdUser)
        .get()
        .then((onValueFetchChats))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }
  static fetchChatsByListIdUser({required List listIdUser})  async {
    final database = await FirebaseFirestore.instance.collection(AppConstants.collectionChat);
    Query<Map<String, dynamic>> ref = database;

    listIdUser.forEach( (val) => {
      ref = database.where('listIdUser' ,arrayContains: val)
    });
    final result=
    ref
        .get()
        .then((onValueFetchChats))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }

  static addMessage( {required Message message,required String idChat}) async {
    final result =await FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
        .collection(AppConstants.collectionMessage).add(
        message.toJson()
    ).then(onValueAddMessage)
        .catchError(onError);
    return result;
  }
  static deleteMessage( {required Message message,required String idChat}) async {
    final result =await FirebaseFirestore.instance
        .collection(AppConstants.collectionChat)
        .doc(idChat)
        .collection(AppConstants.collectionMessage).doc(
        message.id
    ).delete().then(onValueDeleteMessage)
        .catchError(onError);
    return result;
  }
  static fetchLastMessage({required String idChat})  async {
    final result=await FirebaseFirestore.instance.collection(AppConstants.collectionChat)
        .doc(idChat).collection(AppConstants.collectionMessage).orderBy('sendingTime',descending: true).get()
        .then((onValueFetchLastMessage))
        .catchError(onError).timeout(timeOut,onTimeout: onTimeOut);
    return result;
  }




  static Future<Map<String,dynamic>>  onError(error) async {
    return {
      'status':false,
      'message':error,
      //'body':""
    };
  }
  static Future<Map<String,dynamic>>  onTimeOut() async {
    return {
      'status':false,
      'message':'time out',
      //'body':""
    };
  }

  static Future<Map<String,dynamic>>  errorUser(String messageError) async {
    print(false);
    print(messageError);
    return {
      'status':false,
      'message':messageError,
      //'body':""
    };
  }


  
  static Future<Map<String,dynamic>> onValueFetchUser(value) async{
   // print(true);
    print('uid ${await (value.docs.length>0)?value.docs[0]['uid']:null}');
    print("user : ${(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null}");
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUserId(value) async{
    return {
      'status':true,
      'message':'Account successfully logged',
      'body':(value.docs.length>0)?UserModel.fromJson(value.docs[0]).toJson():null
    };
  }
  static Future<Map<String,dynamic>> onValueFetchUsers(value) async{
    print("Users count : ${value.docs.length}");

    return {
      'status':true,
      'message':'Users successfully fetch',
      'body':value.docs
    };
  }



  static Future<Map<String,dynamic>>onValueAddChat(value) async{
    return {
      'status':true,
      'message':'Chat successfully add',
      'body':{'id':value.id}
    };
  }
  static Future<Map<String,dynamic>>onValueUpdateChat(value) async{
    return {
      'status':true,
      'message':'Chat successfully update',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchChats(value) async{
    return {
      'status':true,
      'message':'Chats successfully fetch',
      'body':value.docs
    };
  }
  static Future<Map<String,dynamic>>onValueAddMessage(value) async{
    return {
      'status':true,
      'message':'Message successfully add',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteChat(value) async{
    return {
      'status':true,
      'message':'Chat successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>>onValueDeleteMessage(value) async{
    return {
      'status':true,
      'message':'Message successfully delete',
      'body':{}
    };
  }
  static Future<Map<String,dynamic>> onValueFetchLastMessage(value) async{
    return {
      'status':true,
      'message':'Last message successfully fetch',
      'body':value.docs
    };
  }




  static String findTextToast(String text){
     // if(text.contains("Password should be at least 6 characters")){
     //   return tr(LocaleKeys.toast_short_password);
     // }else if(text.contains("The email address is already in use by another account")){
     //   return tr(LocaleKeys.toast_email_already_use);
     // }
     // else if(text.contains("Account Unsuccessfully created")){
     //   return tr(LocaleKeys.toast_Unsuccessfully_created);
     // }
     // else if(text.contains("Account successfully created")){
     //    return tr(LocaleKeys.toast_successfully_created);
     // }
     // else if(text.contains("The password is invalid or the user does not have a password")){
     //    return tr(LocaleKeys.toast_password_invalid);
     // }
     // else if(text.contains("There is no user record corresponding to this identifier")){
     //    return tr(LocaleKeys.toast_email_invalid);
     // }
     // else if(text.contains("The email address is badly formatted")){
     //   return tr(LocaleKeys.toast_email_invalid);
     // }
     // else if(text.contains("Account successfully logged")){
     //     return tr(LocaleKeys.toast_successfully_logged);
     // }
     // else if(text.contains("A network error")){
     //    return tr(LocaleKeys.toast_network_error);
     // }
     // else if(text.contains("An internal error has occurred")){
     //   return tr(LocaleKeys.toast_network_error);
     // }else if(text.contains("field does not exist within the DocumentSnapshotPlatform")){
     //   return tr(LocaleKeys.toast_Bad_data_fetch);
     // }else if(text.contains("Given String is empty or null")){
     //   return tr(LocaleKeys.toast_given_empty);
     // }
     // else if(text.contains("time out")){
     //   return tr(LocaleKeys.toast_time_out);
     // }
     // else if(text.contains("Account successfully logged")){
     //   return tr(LocaleKeys.toast);
     // }
     // else if(text.contains("Account not Active")){
     //   return tr(LocaleKeys.toast_account_not_active);
     // }

     return text;
  }
  static int compareDateWithDateNowToDay({required DateTime dateTime}){
     int year=dateTime.year-DateTime.now().year;
     int month=dateTime.year-DateTime.now().month;
     int day=dateTime.year-DateTime.now().day;
     return (year*365+
            month*30+
            day);
  }


}