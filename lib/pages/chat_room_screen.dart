import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_chat/controllers/function.dart';

import '../common_widgets/app_text_form_filed.dart';
import '../common_widgets/constans.dart';

import '../common_widgets/picture/cach_picture_widget.dart';
import '../constants/app_assets.dart';

import '../constants/app_colors.dart';
import '../controllers/provider/chat_controller.dart';
import '../controllers/provider/chat_room_controller.dart';
import '../controllers/provider/process_controller.dart';
import '../models/models.dart';



class ChatRoomScreen extends GetView<ChatRoomController>{


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 16,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  onTap: () async {
                    Const.loading(context);
                   var result= await controller.deleteChat(context, idChat: controller.chat?.id??'');
                    Get.back();
                    if(result['status'])
                     Get.back();
                  },
                  child: Text('Delete'),
                )
              ];
            },
          )
        ],
        title:
        GetBuilder<ProcessController>(builder:
        (ProcessController processController)=>
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading:
          ClipOval(
              child: CacheNetworkImage(
                photoUrl: // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
                '${processController.fetchLocalUser(idUser: controller.recId??'')?.photoUrl??''}',
                width: size.width / 8.5,
                height: size.width / 8.5,
                boxFit: BoxFit.fill,
                waitWidget: CircleAvatar( ),
                errorWidget: CircleAvatar( ),
              )),

          title: Text(
            '${processController.fetchLocalUser(idUser: controller.recId??'ALL Chat')?.firstName??''} ${
                processController.fetchLocalUser(idUser: controller.recId??'')?.lastName??''}',
            style: TextStyle(color: AppColors.white),
          ),
          subtitle:  Text(
            '${processController.fetchLocalUser(idUser: controller.recId??'')?.email??''}',
            style: TextStyle(color: AppColors.white),
          ),
        ))),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot>(
          //prints the messages to the screen0
          stream: controller.getChat,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Const.SHOWLOADINGINDECATOR();
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                Const.SHOWLOADINGINDECATOR();
                controller.chat?.messages.clear();
                if (snapshot.data!.docs!.length > 1) {
                  controller.chat?.messages = Messages.fromJson(snapshot.data!.docs!).listMessage;
                }
                return
                  (controller.chat?.messages?.isEmpty??true)?
                  Const.emptyWidget(context,text: "No Messages Yet"):
                  buildChat(context,controller.chat?.messages??[]);
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          })
          ,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: AppTextFormFiled(
                  controller: controller.messageController,
                  hintText: 'Type here...',
                )),
                const SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () async {
                    if (controller.messageController.text.trim().isNotEmpty) {
                   String message=controller.messageController.value.text;
                   controller.messageController.clear();
                      //ToDo: Send Review
                     await controller.sendMessage(context,
                          idChat: controller.chat?.id??'',
                          message: Message(
                              textMessage: '${message}',
                              typeMessage: TypeMessage.text.name,
                              senderId: controller.currentUserId,
                              receiveId: controller.recId??'',
                              sendingTime: DateTime.now(),
                              ));

                      Get.put(ChatController()).update();

                    }
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.send),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget buildChat(BuildContext context,List<Message> messages){
    controller.chatList=messages;
    return   controller.chatList.isEmpty
        ? Center(
          child: Text(
              'No Message Yet!',
              style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width * 0.08,
                  fontWeight: FontWeight.bold),
          ),
        )
        : Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
              controller.chatList.length,
                  (index) => controller.chatList[index].senderId==controller.currentUserId
                      ?SenderWidget(chatList: controller.chatList,index: index,)
                  :ReciveWidget(chatList: controller.chatList, index: index)),
        ),
      ),
    );
  }
}


class SenderWidget extends GetView<ChatRoomController> {
   SenderWidget({
    super.key,
    required this.chatList, required this.index,
  });
  final List<Message> chatList;
  final int index;
  final ProcessController _processController = Get.put(ProcessController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final recId=controller.getIdUserOtherFromList( controller.chat?.listIdUser??[]);
    return InkWell(
      onLongPress: (){
        showAdaptiveDialog(context: context, builder: (_){
          return AlertDialog(
            title: const Text('Remove This Message'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const  Text('Are You Sure?'),
                const SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text('cancel',style: TextStyle(color: AppColors.error),)),
                    TextButton(onPressed: () async {
                      //widget.chatList.removeAt(widget.index);
                       controller.deleteMessage(context, idChat: controller.chat?.id??''
                          , message: chatList[index]);
                      Navigator.pop(context);
                       Get.put(ChatController()).update();

                      // setState(() {
                      //
                      // });
                    }, child: const Text('yes',))
                  ],
                )
              ],
            ),
          );
        });
      },
      child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            ClipOval(
            child:
              GetBuilder<ProcessController>(builder:
    (ProcessController processController)  {
    processController.fetchUserAsync(context, idUser: getCurrentUserId());
            return CacheNetworkImage(
            photoUrl: // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
            '${_processController.fetchLocalUser(idUser:getCurrentUserId()??'')?.photoUrl??''}',
        width: size.width / 8.5,
        height: size.width / 8.5,
        boxFit: BoxFit.fill,
        waitWidget: CircleAvatar( ),
        errorWidget: CircleAvatar( ),
      );})),
                const SizedBox(
                  width: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.sizeOf(context).width /
                            1.5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12)
                    )
                  ),
                  child: Text('${_processController.fetchLocalUser(idUser:getCurrentUserId()??'')}'),
                ),
              ],
            ),
          ),
    );
  }
}
class ReciveWidget extends GetView<ChatRoomController> {
   ReciveWidget({
    super.key,
    required this.chatList, required this.index,
  });

  final List<Message> chatList;
  final int index;
  final ProcessController _processController = Get.put(ProcessController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final recId=controller.getIdUserOtherFromList( controller.chat?.listIdUser??[]);
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.sizeOf(context).width /
                          1.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12)
                  )
                ),
                child: Text(chatList[index].textMessage),
              ),
              const SizedBox(
                width: 10.0,
              ),
              ClipOval(
                  child: CacheNetworkImage(
                    photoUrl: // "https://th.bing.com/th/id/R.1b3a7efcd35343f64a9ae6ad5b5f6c52?rik=HGgUvyvtG4jbAQ&riu=http%3a%2f%2fwww.riyadhpost.live%2fuploads%2f7341861f7f918c109dfc33b73d8356b2.jpg&ehk=3Z4lADOKvoivP8Tbzi2Y56dxNrCWd0r7w7CHQEvpuUg%3d&risl=&pid=ImgRaw&r=0",
                    '${_processController.fetchLocalUser(idUser: recId??'')?.photoUrl??''}',
                    width: size.width / 8.5,
                    height: size.width / 8.5,
                    boxFit: BoxFit.fill,
                    waitWidget: CircleAvatar( ),
                    errorWidget: CircleAvatar( ),
                  )),
            ],
          ),
        );
  }
}
/*
ListTile(
                  leading: CircleAvatar(),
                  title: Text('Name'),
                  subtitle: Text(chatList[index]),
                  trailing: Visibility(
                    visible: index == 2,
                    child: IconButton(
                      icon: const Icon(Icons.delete,color: AppColors.error,),
                      onPressed: (){
                        //ToDo: Delete Review
                        showAdaptiveDialog(context: context, builder: (_){
                          return AlertDialog(
                            title: const Text('Rwmove This Review'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const  Text('Are You Sure?'),
                                const SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                    }, child: const Text('cancel',style: TextStyle(color: AppColors.error),)),
                                    TextButton(onPressed: (){
                                      chatList.removeAt(index);
                                      Navigator.pop(context);
                                      setState(() {

                                      });
                                    }, child: const Text('yes',))
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                      },
                    ),
                  ),
                )
 */
