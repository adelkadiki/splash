import 'package:chatapp/screens/auth.dart';
import 'package:chatapp/screens/bottom_to_top_reveal.dart';
import 'package:chatapp/screens/simple_animate.dart';
import 'package:chatapp/screens/splash_framed_reveal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.from(alpha: 255, red: 63, green: 17, blue: 177))
      ) ,
      home: SplashFramedReveal()
    );
  }
}

