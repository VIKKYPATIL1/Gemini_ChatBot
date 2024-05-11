import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_splash_screen/flutter_splash_screen.dart';
// import 'package:gemini_ai_new/screens/home_screen.dart';
import 'package:gemini_ai_new/screens/wait.dart';
// import 'package:splashscreen/splashscreen.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SplashScreen1())));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Wait(),
    );
  }
}
