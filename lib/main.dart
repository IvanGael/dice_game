// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:device_preview/device_preview.dart';

import 'cube_home.dart';

void main() {
  // runApp(
  //     DevicePreview(
  //       builder: (context) => const MyApp()
  //     )
  //   );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Dice Game',
    //   useInheritedMediaQuery: true,
    //   locale: DevicePreview.locale(context),
    //   builder: DevicePreview.appBuilder,
    //   theme: ThemeData.dark(
    //     useMaterial3: true,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home: const CubeHome(),
    // );
    
    return MaterialApp(
      title: 'Dice Game',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const CubeHome(),
    );
  }
}