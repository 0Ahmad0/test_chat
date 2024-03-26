

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


import '../../common_widgets/constans.dart';
import '../../constants/app_constant.dart';

import '../../models/models.dart';
import '../../repo/firebase.dart';


class ProcessController extends GetxController{
  Map<String,dynamic> cacheNameUser=Map<String,dynamic>();
  Map<String,dynamic> cacheUser=Map<String,dynamic>();

  fetchLocalNameUser({required String idUser}) {
    //  print(cacheUser[idUser]);
    if(cacheNameUser.containsKey(idUser)) return cacheNameUser[idUser];
    return "......";
  }

  fetchNameUser(context,{required String idUser}) async{

    if(cacheNameUser.containsKey(idUser)) return cacheNameUser[idUser];
    var result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionUser);
    cacheNameUser[idUser]=(result['status'])?UserModel.fromJson(result['body']).name:"user";
    update();
    return cacheNameUser[idUser];
  }
  UserModel? fetchLocalUser({required String idUser}) {
    if(cacheUser.containsKey(idUser)) return cacheUser[idUser];
    return null;
  }
  Future<UserModel?> fetchUser(context,{required String idUser}) async{
    if(cacheUser.containsKey(idUser)&&cacheUser[idUser]!=null) return cacheUser[idUser];
    var result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionUser);
    cacheUser[idUser]=(result['status'])?UserModel.fromJson(result['body']):null;
    update();
    return cacheUser[idUser];
  }
  void fetchUserAsync(context,{required String idUser}) async{
      if(cacheUser.containsKey(idUser)&&cacheUser[idUser]!=null) return cacheUser[idUser];
    var result =await FirebaseFun.fetchUserId(id: idUser,typeUser: AppConstants.collectionUser);
    cacheUser[idUser]=(result['status'])?UserModel.fromJson(result['body']):null;
    update();
    return cacheUser[idUser];
  }
  fetchUsers(context,{required List<String> idUsers}) async{
    for(String idUser in idUsers)
       fetchUser(context, idUser: idUser);
   // notifyListeners();
  }
  widgetNameUser(context,{required String idUser}){

    return FutureBuilder(
      future: fetchNameUser(
          context,
          idUser: idUser),
      builder: (context, snapshot,) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Const.SHOWLOADINGINDECATOR();
        } else if (snapshot
            .connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            // Map<String,dynamic> data=snapshot.data as Map<String,dynamic>;
            //homeProvider.sessions=Sessions.fromJson(data['body']);
            return Text(
        '${cacheNameUser[idUser]}'
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




}