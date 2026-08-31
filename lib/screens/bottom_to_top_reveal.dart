import 'package:flutter/material.dart';

class BottomToTopReveal extends StatefulWidget {
  const BottomToTopReveal({super.key});

  @override
  State<BottomToTopReveal> createState() => _BottomToTopRevealState();
}

class _BottomToTopRevealState extends State<BottomToTopReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Define the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // 2. Define the Tween for the vertical offset
    // begin: Offset(0, 1) means the image is shifted down by 100% of its height
    // end: Offset.zero means the image returns to its original position
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          // Set a fixed height for the clipping area
          height: 300,
          width: 300,
          child: ClipRect(
            child: SlideTransition(
              position: _offsetAnimation,
              child: Image.asset(
                'assets/images/chat-image.png', // Replace with your image path
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}