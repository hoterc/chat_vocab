import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  static const List<BottomBarItem> _navigationItems = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffAEADB2), width: 0.3)),
        ),
        child: SafeArea(
          child: BottomBar(
            selectedIndex: navigationShell.currentIndex,
            items: _navigationItems,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}
