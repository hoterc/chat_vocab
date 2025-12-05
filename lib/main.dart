import 'package:chat_vocab/config/theme.dart';
import 'package:chat_vocab/core/storage/app_perfs.dart';
import 'package:chat_vocab/screens/home_screen/home_screen.dart';
import 'package:chat_vocab/screens/practice_screen/practice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();

  // Save first open date if not set yet
  await AppPrefs.saveFirstOpenDateIfNeeded();
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
          home: PracticeScreen(),
        );
      },
    );
  }
}
