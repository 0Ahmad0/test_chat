import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_chat/constants/app_colors.dart';

import '../common_widgets/constans.dart';
import '../common_widgets/picture/cach_picture_widget.dart';
import '../constants/app_assets.dart';
import '../controllers/function.dart';
import '../controllers/provider/chat_controller.dart';
import '../controllers/provider/process_controller.dart';
import '../models/models.dart';
import '../routes/app_pages.dart';
import 'chat_room_screen.dart';



class ChatScreen extends GetView<ChatController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Chat'),
      //TODO add back button or put title in center
      //  leading: const BackButton(color: AppColors.black,),
      ),
      floatingActionButton: IconButton(
        onPressed: () async {

           await Get.toNamed(Routes.ADD_CHAT);
        },
        icon: CircleAvatar(
          child: Icon(Icons.add),
        ),
      ),
      body:

      StreamBuilder<QuerySnapshot>(
        //prints the messages to the screen0
          stream: controller.getChats,
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
                  controller.chats=Chats.fromJson(snapshot.data!.docs!);
                }

                return  GetBuilder<ChatController>(builder:
                (ChatController controller) =>
                  (controller.chats.listChat.isEmpty)
                      ? Center(
                        child: Text(
                          'No Message Yet!',
                          style: TextStyle(
                              fontSize: MediaQuery.sizeOf(context).width * 0.08,
                              fontWeight: FontWeight.bold),
                        ),
                      ):
                  ListView.separated(
                  itemCount: controller.chats.listChat.length,
                  itemBuilder: (ctx,index)=> ChatItem(
                    index: index,
                    name: (controller.currentUserId.contains(controller.chats.listChat[index].listIdUser[0]))
                        ?controller.chats.listChat[index].listIdUser[1]
                        :controller.chats.listChat[index].listIdUser[0],//"${index+10*2/3} Alwaseem",
                    img: AppAssets.logoIMG,
                    lastMSG: controller.chats.listChat[index].id,//'last message',
                  ),
                  separatorBuilder: (BuildContext context, int index)=>Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                ));
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
}

class ChatItem extends GetView<ChatController>{
  final String? img;
  final String name;
  final String lastMSG;
  final int index;
  final ProcessController _processController = Get.put(ProcessController());
   ChatItem({super.key, this.img, required this.name, required this.index, required this.lastMSG});
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.sizeOf(context);
    return ListTile(
      onTap: () async {
        controller.chat= controller.chats.listChat[index];

        Const.loading(context);
        await  controller.fetchChatByListIdUser(listIdUser: controller.chat.listIdUser);
        Get.back();
        Get.toNamed(Routes.CHAT_ROOM,arguments: {'chat':controller.chat});

        },
      leading:
      GetBuilder<ProcessController>(builder:
      (ProcessController processController)  {
        processController.fetchUserAsync(context, idUser: name);
        UserModel? user=processController.fetchLocalUser(idUser: name);
     return
       user?.photoUrl!=null?
       ClipOval(
           child: CacheNetworkImage(
             photoUrl:  '${user?.photoUrl??''}',
             width: size.width / 8.5,
             height: size.width / 8.5,
             boxFit: BoxFit.fill,
             waitWidget: CircleAvatar( ),
             errorWidget: CircleAvatar( ),
           )):
       CircleAvatar(
       );

     },

      ),
      title: fetchName(context,name),
      subtitle: fetchLastMessage(context,lastMSG),
    );
  }
  fetchName(BuildContext context,String idUser){
    return _processController.widgetNameUser(context, idUser: idUser);
  }
  fetchLocalUser(BuildContext context,String idUser){
    return _processController.fetchUser(context, idUser: idUser);
  }
  fetchLastMessage(BuildContext context,String idChat){
    return controller.widgetLastMessage(context, idChat: idChat);
  }
}

