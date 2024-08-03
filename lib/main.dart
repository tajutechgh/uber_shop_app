import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/controllers/category_controller.dart';
import 'package:uber_shop_app/views/screens/auth/welcome_screens/welcome_register_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBmK2G9eiOpdXrNmCYwQfqAzVOn8n2KQzQ",
        appId: "1:228019481774:android:ebadd32d66387228dc913f",
        messagingSenderId: "228019481774",
        projectId: "uber-shop-app-c3ca9",
        storageBucket: "uber-shop-app-c3ca9.appspot.com",
      )
  ):await Firebase.initializeApp();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: WelcomeRegisterScreen(),
      initialBinding: BindingsBuilder((){
        Get.put<CategoryController>(CategoryController());
      }),
    );
  }
}