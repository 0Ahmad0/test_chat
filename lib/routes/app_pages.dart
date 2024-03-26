import 'package:get/get.dart';
import 'package:test_chat/controllers/bindings/chat_binding.dart';
import 'package:test_chat/controllers/bindings/chat_room_binding.dart';
import 'package:test_chat/controllers/bindings/process_binding.dart';
import 'package:test_chat/pages/add_chat_screen.dart';
import 'package:test_chat/pages/chat_room_screen.dart';
import 'package:test_chat/pages/chats_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CHAT;

  static final routes = [
    GetPage(
      name: _Paths.CHAT,
      page: () =>  ChatScreen(),
      bindings: [ChatBinding(),ProcessBinding()],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () =>  ChatRoomScreen(),
      bindings:  [ChatRoomBinding()],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.ADD_CHAT,
      page: () =>  AddChatScreen(),
      bindings:  [ChatBinding(),ProcessBinding()],
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),

  ];
}
