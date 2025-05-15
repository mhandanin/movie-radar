import 'package:flutter/material.dart';
import 'dart:async';

import 'package:movie_rada_n/screen/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();


    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
