import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_chat/routes/app_pages.dart';


import '../common_widgets/constans.dart';
import '../common_widgets/picture/cach_picture_widget.dart';
import '../constants/app_colors.dart';
import '../constants/app_constant.dart';

import '../controllers/provider/chat_controller.dart';
import '../models/models.dart' as models;
import '../models/models.dart';
import 'chat_room_screen.dart';



class AddChatScreen extends GetView<ChatController>{


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Chat'),
      ),
      body:
      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: controller.getUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return
                Const.SHOWLOADINGINDECATOR();

            }
            else if (snapshot.connectionState ==
                ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                if(snapshot.data!.docs!.length>0){
                  controller.users=Users.fromJson(snapshot.data!.docs!);
                  controller.checkUsersIsAdd();
                  controller.removeCurrentUser();
                }

                return
                  controller.users.users.isEmpty?
                  Const.emptyWidget(context,text: "No Users Yet"):
                  buildListDoctors(context,controller.users.users);
                /// }));
              } else {
                return const Text('Empty data');
              }
            }
            else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),

    );
  }
  Widget buildListDoctors(BuildContext context,List<UserModel> users){
    final size = MediaQuery.sizeOf(context);
    return  ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemBuilder: (ctx,index)=>Card(
          child: ListTile(
            leading:   ClipOval(
                child: CacheNetworkImage(
                  photoUrl:  '${users[index].photoUrl??''}',
                  width: size.width / 8.5,
                  height: size.width / 8.5,
                  boxFit: BoxFit.fill,
                  waitWidget: CircleAvatar( ),
                  errorWidget: CircleAvatar( ),
                )),
            title: Text('${users[index].firstName} ${users[index].lastName}'),
            subtitle: Text(users[index]?.email??''),
            trailing: Visibility(
              child: IconButton(
                onPressed: () async {
                  Const.loading(context);
                  var result=await controller.createChat(listIdUser: [controller.currentUserId,users[index]?.id??'']);
                 //TODO dd notification
                  // if(result['status'])
                  //   context.read<NotificationProvider>().addNotification(context, notification: models.Notification(idUser: users[index].id, subtitle: AppConstants.notificationSubTitleNewChat+' '+(profileProvider?.user?.firstName??''), dateTime: DateTime.now(), title: AppConstants.notificationTitleNewChat, message: ''));
                  await controller.fetchChatByListIdUser(listIdUser: [controller.currentUserId,users[index]?.id??'']);
                  Get.back();
                  Get.back();
                  Get.toNamed(Routes.CHAT_ROOM,arguments: {'chat':controller.chat});

                },
                icon: Icon(users[index].isAdd?Icons.chat:Icons.add,color: AppColors.primary,),
              ),
            ),
          ),
        ),
        itemCount: users.length
    );
  }
}
