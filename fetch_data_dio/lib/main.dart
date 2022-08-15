//? CodeWithFlexz on Instagram

//* AmirBayat0 on Github
//! Programming with Flexz on Youtube


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'Flutter Fetch Data using Dio',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}





























