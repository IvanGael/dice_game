// ignore_for_file: deprecated_member_use

import 'package:dice_game/constants.dart';
import 'package:flutter/material.dart';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cube_home.dart';
import 'provider/dice_config_bloc.dart';
import 'provider/dice_config_repository.dart';

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
    // Change status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppConstants.black, // status bar color
        statusBarIconBrightness: Brightness.light, // Icon color (white or black)
      )
    );
    
    // return MaterialApp(
    //   title: 'Dice Game',
    //   useInheritedMediaQuery: true,
    //   locale: DevicePreview.locale(context),
    //   builder: DevicePreview.appBuilder,
    //   theme: ThemeData.dark(
    //     useMaterial3: true,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home: BlocProvider(
    //     create: (context) => DiceConfigBloc(diceConfigRepository: DiceConfigRepository()),
    //     child: const CubeHome(),
    //   )
    // );

    return MaterialApp(
      title: 'Dice Game',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: const CubeHome(),
      home: BlocProvider(
        create: (context) => DiceConfigBloc(diceConfigRepository: DiceConfigRepository()),
        child: const CubeHome(),
      ),
    );
  }
}