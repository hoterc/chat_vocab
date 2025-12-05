// custom_keyboard.dart
// A single-file Flutter custom keyboard (letters + apostrophe) without space.

import 'package:flutter/material.dart';

typedef TextInputCallback = void Function(String text);

class CustomKeyboard extends StatefulWidget {
  final TextInputCallback onTextInput;
  final VoidCallback onBackspace;
  final bool startUpperCase;

  const CustomKeyboard({
    super.key,
    required this.onTextInput,
    required this.onBackspace,
    this.startUpperCase = false,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  bool _isUpper = false;
  static const List<String> _letters = [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
  ];

  @override
  void initState() {
    super.initState();
    _isUpper = widget.startUpperCase;
  }

  void _textInputHandler(String text) => widget.onTextInput(text);
  void _backspaceHandler() => widget.onBackspace();

  Widget _buildKey(String label, {double flex = 1}) {
    final display = _isUpper ? label.toUpperCase() : label;
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
          ),
          onPressed: () => _textInputHandler(display),
          child: Text(display, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _nonCharKey(
    Widget child, {
    required VoidCallback onPressed,
    double flex = 1,
  }) {
    return Expanded(
      flex: (flex * 1000).toInt(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black,
          ),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final row1 = _letters.sublist(0, 10);
    final row2 = _letters.sublist(10, 19);
    final row3 = _letters.sublist(19, 26);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 6),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: row1.map((c) => _buildKey(c)).toList()),
            Row(
              children: [
                const Spacer(flex: 1),
                ...row2.map((c) => _buildKey(c)),
                const Spacer(flex: 1),
              ],
            ),
            Row(
              children: [
                _nonCharKey(
                  Icon(
                    _isUpper ? Icons.arrow_upward : Icons.arrow_upward_outlined,
                  ),
                  onPressed: () => setState(() => _isUpper = !_isUpper),
                  flex: 2,
                ),
                ...row3.map((c) => _buildKey(c)),
                _nonCharKey(
                  Icon(Icons.backspace),
                  onPressed: _backspaceHandler,
                  flex: 2,
                ),
              ],
            ),
            Row(
              children: [
                _buildKey("'", flex: 3),
                _nonCharKey(
                  const Text('Done'),
                  onPressed: () => FocusScope.of(context).unfocus(),
                  flex: 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
