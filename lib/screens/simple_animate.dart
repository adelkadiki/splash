import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';


class SimpleAnimate extends StatelessWidget {
  const SimpleAnimate({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/images/chat-image.png')
            .animate()
            .custom(
              duration: 2.seconds,
              curve: Curves.linear,
              builder: (context, value, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: value, // Expands clip box upward
                    child: Align(
                      // Locks child image to the bottom so it never shifts
                      alignment: Alignment.bottomCenter, 
                      heightFactor: 1.0, 
                      child: child,
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}