import 'package:bottom_bar/bottom_bar.dart';
import 'package:chat_vocab/screens/home_screen/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tabs/tab_import.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  final List<Widget> _screens = const [
    HomeTab(),
    WordListTab(),
    ProfileTab(),
    SettingsTab(),
  ];

  final List<BottomBarItem> _navigationItems = const [
    BottomBarItem(
      icon: Icon(Icons.home, size: 30),
      title: Text('Home'),
      activeColor: Colors.blue,
    ),
    BottomBarItem(
      icon: Icon(Icons.list_alt),
      title: Text('Word Lists'),
      activeColor: Colors.blue,
    ),
    BottomBarItem(
      icon: Icon(Icons.person),
      title: Text('Profile'),
      activeColor: Colors.blue,
    ),
    BottomBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
      activeColor: Colors.blue,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navigationProvider);

    return Scaffold(
      body: _screens[index],

      // ref.read(navigationProvider.notifier).setIndex(value);
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            // Specifies borders for individual sides
            top: BorderSide(color: Color(0xffAEADB2), width: 0.3),
          ),
        ),
        child: SafeArea(
          child: BottomBar(
            selectedIndex: index,
            items: _navigationItems,
            onTap: (value) {
              ref.read(navigationProvider.notifier).setIndex(value);
            },
          ),
        ),
      ),
    );
  }
}
