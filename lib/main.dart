import 'package:flutter/material.dart';
import 'package:watch_out_weather/screens/home_screen.dart';
void main(){
  runApp(mainApp());
}
class mainApp extends StatelessWidget {
  const mainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Watch Out Weather",
      home: HomeScreen(),
    );
  }
}
