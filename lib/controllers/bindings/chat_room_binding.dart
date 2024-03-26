import 'package:get/get.dart';
import '../provider/chat_controller.dart';
import '../provider/chat_room_controller.dart';

class ChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRoomController>(
      () => ChatRoomController(),
    );
  }
}
