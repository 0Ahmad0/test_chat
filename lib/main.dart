import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:test_chat/pages/chats_screen.dart';
import 'package:test_chat/routes/app_pages.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Chat App',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      //home: PatientScreen(),
    );
  }
}
