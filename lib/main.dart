import 'package:chat_vocab/config/theme.dart';
import 'package:chat_vocab/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: .dark,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: backGronudColor,
            primarySwatch: Colors.blue,
          ),
          home: HomeScreen(),
        );
      },
    );
  }
}
