import 'dart:async';
import 'package:flutter/material.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  int secondsLeft = 5;
  bool showAfterText = false;

  Timer? timer;

  late AnimationController _controller;
  late Animation<double> _scale;
  void restartTimer() {
    setState(() {
      secondsLeft = 5; // reset countdown
      showAfterText = false;
    });

    _controller.reset(); // reset animation
    _controller.forward(); // play pop-in again

    // restart timer
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft == 1) {
        t.cancel();
        setState(() => secondsLeft = 0);

        _controller.reverse().then((_) {
          setState(() => showAfterText = true);
        });
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft == 1) {
        t.cancel();
        setState(() => secondsLeft = 0);

        _controller.reverse().then((_) {
          setState(() => showAfterText = true);
        });
      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showAfterText) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text(
                "Timer Finished!",
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(onPressed: restartTimer, child: Text('Replay')),
            ],
          ),
        ),
      );
    }

    double progress = secondsLeft / 3;

    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: SizedBox(
            width: 260,
            height: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ⭐ FORCE THE CIRCLE TO BE BIG
                Transform.scale(
                  scale: 3.0, // ★ MAKE CIRCLE MUCH BIGGER
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                  ),
                ),

                // Number in the middle
                Text(
                  secondsLeft.toString(),
                  style: const TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';

// class PracticeScreen extends StatefulWidget {
//   const PracticeScreen({super.key});

//   @override
//   State<PracticeScreen> createState() => _PracticeScreenState();
// }

// class _PracticeScreenState extends State<PracticeScreen>
//     with TickerProviderStateMixin {
//   final List<String> words = [
//     'Apple',
//     'Banana',
//     'Cherry',
//     'Dragon',
//     'Elephant',
//     'Flower',
//     'Guitar',
//   ];

//   late AnimationController _circleController;
//   late AnimationController _wordFadeController;

//   String currentWord = '';
//   String typedWord = '';
//   bool showInput = false;
//   bool showKeyboard = false;

//   @override
//   void initState() {
//     super.initState();

//     _circleController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//     );

//     _wordFadeController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );

//     startNewWord();
//   }

//   @override
//   void dispose() {
//     _circleController.dispose();
//     _wordFadeController.dispose();
//     super.dispose();
//   }

//   void startNewWord() {
//     typedWord = '';
//     showInput = false;
//     showKeyboard = false;

//     currentWord = words[Random().nextInt(words.length)];

//     _wordFadeController.forward(from: 0);

//     _circleController.forward(from: 0).whenComplete(() {
//       setState(() {
//         showInput = true;
//         showKeyboard = true;
//       });
//     });
//   }

//   void onKeyTap(String key) {
//     setState(() {
//       if (typedWord.isEmpty) {
//         typedWord += key.toUpperCase();
//       } else {
//         typedWord += key.toLowerCase();
//       }

//       if (typedWord.toLowerCase() == currentWord.toLowerCase()) {
//         _wordFadeController.reverse(from: 1).whenComplete(() {
//           startNewWord();
//         });
//       }
//     });
//   }

//   void onBackspace() {
//     setState(() {
//       if (typedWord.isNotEmpty) {
//         typedWord = typedWord.substring(0, typedWord.length - 1);
//       }
//     });
//   }

//   Widget buildCustomKeyboard() {
//     bool firstLetterNotTyped = typedWord.isEmpty;

//     final keys = [
//       'A',
//       'B',
//       'C',
//       'D',
//       'E',
//       'F',
//       'G',
//       'H',
//       'I',
//       'J',
//       'K',
//       'L',
//       'M',
//       'N',
//       'O',
//       'P',
//       'Q',
//       'R',
//       'S',
//       'T',
//       'U',
//       'V',
//       'W',
//       'X',
//       'Y',
//       'Z',
//       "'",
//     ];

//     return Container(
//       color: Colors.black87,
//       padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           for (int row = 0; row < 3; row++)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 2),
//               child: Row(
//                 children: keys.skip(row * 9).take(9).map((key) {
//                   String displayKey = firstLetterNotTyped
//                       ? key.toUpperCase()
//                       : key.toLowerCase();
//                   return Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 2),
//                       child: ElevatedButton(
//                         onPressed: () => onKeyTap(key),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.grey[900],
//                           minimumSize: Size(0, 50),
//                           padding: EdgeInsets.zero,
//                         ),
//                         child: Center(
//                           child: Text(
//                             displayKey,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           SizedBox(height: 6),
//           Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: onBackspace,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     minimumSize: Size(0, 50),
//                   ),
//                   child: Icon(Icons.backspace, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCustomInput() {
//     List<Widget> letters = [];
//     for (int i = 0; i < currentWord.length; i++) {
//       Color color;
//       if (i < typedWord.length) {
//         color = typedWord[i].toLowerCase() == currentWord[i].toLowerCase()
//             ? Colors.greenAccent
//             : Colors.redAccent;
//       } else {
//         color = Colors.white24;
//       }

//       letters.add(
//         Column(
//           children: [
//             SizedBox(height: 4),
//             Container(
//               width: 30,
//               alignment: Alignment.center,
//               child: Text(
//                 i < typedWord.length ? typedWord[i] : '',
//                 style: TextStyle(
//                   fontSize: 32,
//                   color: color,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2,
//                 ),
//               ),
//             ),
//             SizedBox(height: 6),
//             Container(height: 2, width: 30, color: Colors.white38),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: [
//         Text(
//           "Type the word you saw",
//           style: TextStyle(
//             color: Colors.blueAccent,
//             fontSize: 20,
//             letterSpacing: 1.5,
//           ),
//         ),
//         SizedBox(height: 16),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: letters),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black87,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     if (!showInput)
//                       FadeTransition(
//                         opacity: _wordFadeController,
//                         child: Text(
//                           currentWord,
//                           style: TextStyle(
//                             fontSize: 40,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                       ),
//                     if (!showInput) SizedBox(height: 30),
//                     if (!showInput)
//                       SizedBox(
//                         width: 80,
//                         height: 80,
//                         child: AnimatedBuilder(
//                           animation: _circleController,
//                           builder: (context, child) {
//                             return CircularProgressIndicator(
//                               value: _circleController.value,
//                               strokeWidth: 6,
//                               color: Colors.blueAccent,
//                               backgroundColor: Colors.white12,
//                             );
//                           },
//                         ),
//                       ),
//                     if (!showInput) SizedBox(height: 30),
//                     if (showInput) buildCustomInput(),
//                   ],
//                 ),
//               ),
//             ),

//             if (showKeyboard) Flexible(flex: 2, child: buildCustomKeyboard()),
//           ],
//         ),
//       ),
//     );
//   }
// }
