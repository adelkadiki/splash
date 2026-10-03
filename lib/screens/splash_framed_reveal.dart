import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashFramedReveal extends StatefulWidget {
  const SplashFramedReveal({super.key});

  @override
  State<SplashFramedReveal> createState() => _SplashFramedRevealState();
}

class _SplashFramedRevealState extends State<SplashFramedReveal> {
  // Boolean flag to strictly guarantee the cover is completely gone
  bool _isCoverGone = false;

  @override
  Widget build(BuildContext context) {
    const double frameWidth = 300;
    const double frameHeight = 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: frameWidth,
          height: frameHeight,
          child: Stack(
            children: [
              // 1. FIRST STACK CHILD: Column containing both images
              Positioned.fill(
                child: Column(
                  children: [
                    // Top Image: ONLY mounts and animates AFTER _isCoverGone is true
                    Expanded(
                      child: _isCoverGone
                          ? Image.asset(
                                  'assets/images/chat-image.png',
                                  fit: BoxFit.contain,
                                )
                                .animate()
                                // Step 1: Fade In immediately upon mounting
                                .fadeIn(duration: 500.ms, curve: Curves.easeIn)
                                .then()
                                // Step 2: Strong upward launch (-60px up)
                                .moveY(
                                  begin: 0,
                                  end: -60,
                                  duration: 350.ms,
                                  curve: Curves.easeOut,
                                )
                                .then()
                                // Step 3: Bounce back DOWN to rest position
                                .moveY(
                                  begin: -60,
                                  end: 0,
                                  duration: 650.ms,
                                  curve: Curves.bounceOut,
                                )
                          : const SizedBox.shrink(), // Keeps space empty while cover is sliding
                    ),

                    // Bottom Image: Fully visible underneath, revealed as cover slides up
                    Expanded(
                      child: Image.asset(
                        'assets/images/chat-image.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. SECOND STACK CHILD: White sliding container
              if (!_isCoverGone)
                Positioned.fill(
                  child: Container(color: Colors.white)
                      .animate(
                        onComplete: (controller) {
                          // Guaranteed to execute ONLY after the slide finishes 100%
                          setState(() {
                            _isCoverGone = true;
                          });
                        },
                      )
                      .slideY(
                        begin: 0.0,
                        end: -1.0,
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class SplashFramedReveal extends StatelessWidget {
//   const SplashFramedReveal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const double frameWidth = 300;
//     const double frameHeight = 400;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SizedBox(
//           width: frameWidth,
//           height: frameHeight,
//           child: Stack(
//             children: [
//               // 1. FIRST STACK CHILD: Column containing both images
//               Positioned.fill(
//                 child: Column(
//                   children: [
//                     // Top Image: Hidden initially, fades in AFTER the slide (delay 2s)
//                     Expanded(
//                       child: Image.asset(
//                         'assets/images/chat-image.png',
//                         fit: BoxFit.contain,
//                       )
//                           .animate()
//                           .fadeIn(
//                             delay: 2.seconds, // Waits for cover to slide & vanish
//                             duration: 800.ms,
//                             curve: Curves.easeIn,
//                           ),
//                     ),

//                     // Bottom Image: Fully visible underneath, revealed as cover slides up
//                     Expanded(
//                       child: Image.asset(
//                         'assets/images/chat-image.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // 2. SECOND STACK CHILD: White sliding container
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.white,
//                 )
//                     .animate()
//                     .slideY(
//                       begin: 0.0,
//                       end: -1.0,
//                       duration: 2.seconds,
//                       curve: Curves.easeInOut,
//                     )
//                     .then()
//                     // Vanishes immediately when done sliding
//                     .visibility(end: false),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
