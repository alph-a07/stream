import 'package:flutter/material.dart';

import '../resources/colors.dart';
import 'feed.dart';
import 'go_live.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static var route = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  List<Widget> pages = [
    const Feed(),
    const GoLive(),
    const Center(
      child: Text('Browser'),
    ),
  ];

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        unselectedFontSize: 12,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_rounded,
            ),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.copy,
            ),
            label: 'Browse',
          ),
        ],
      ),
      body: pages[_page],
    );
  }
}
