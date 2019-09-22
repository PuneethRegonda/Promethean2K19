import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/screens/authScreen.dart';
import 'package:promethean_2k19/screens/home_screen.dart';
import 'package:promethean_2k19/screens/profile_form.dart';
import 'package:promethean_2k19/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (BuildContext context) => SplashScreen(),
        "/homeScreen" : (BuildContext context)=> HomeScreen(),
        "/authScreen" : (BuildContext context)=> AuthScreen(),
        "/userProfileForm" : (BuildContext context) => UserProfileForm()
      },
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: "Promethean2K19",
//      home: SplashScreen(),
    );
  }
}

