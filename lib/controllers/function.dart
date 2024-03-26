import 'dart:math';

import 'package:test_chat/models/models.dart';

import '../repo/firebase.dart';

String getCurrentUserId(){
  return 'dQvlD7eNTGwWc7RzkdVx';
}

Future<void> generateDummyUsers() async {
  List<String?> photos=[
    'https://images.unsplash.com/photo-1711336763708-0e3d60e1a9d0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxNHx8fGVufDB8fHx8fA%3D%3D',
    'https://unsplash.com/photos/the-sun-shines-through-the-water-in-a-cave-wEgMlQ8DL6s',
    'https://plus.unsplash.com/premium_photo-1709311441238-1c83ef3b8d04?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    null
  ];
  List<UserModel> users=[];
  for(int i=0;i<10;i++)

    users.add(UserModel(firstName: 'first',lastName: 'last${i}',email: 'email${i}@gamil.com',phoneNumber: '+96393795499${i}',photoUrl:
    photos[Random().nextInt(3)]))
  ;
  users.forEach((element) async {
    final result =await FirebaseFun.createUser(user: element);
    print(result);
  });


}