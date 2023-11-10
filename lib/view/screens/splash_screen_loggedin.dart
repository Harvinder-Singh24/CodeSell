import 'dart:async';

import 'package:devgram/view/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreenLoggedInUser extends StatefulWidget {
  const SplashScreenLoggedInUser({Key? key}) : super(key: key);

  @override
  State<SplashScreenLoggedInUser> createState() =>
      _SplashScreenLoggedInUserState();
}

class _SplashScreenLoggedInUserState extends State<SplashScreenLoggedInUser> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/logoanimation.gif", height: 400, width: 400),
      ),
    );
  }
}
