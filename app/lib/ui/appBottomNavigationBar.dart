import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  int initialPosition = HOME_POSITION;
  static int HOME_POSITION = 0;
  static int SEARCH_POSITION = 1;
  static int STARRED_POSITION = 2;
  static int SETTINGS_POSITION = 3;

  AppBottomNavigationBar({Key? key, this.initialPosition = 0})
      : super(key: key);

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    // initialize _currentIndex
    if (_currentIndex == -1) {
         _currentIndex = widget.initialPosition;
    }
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (value) {
        // Respond to item press.
        setState(() => _currentIndex = value);
      },
      items: const [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          title: Text('Search'),
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          title: Text('Starred'),
          icon: Icon(Icons.star),
        ),
        BottomNavigationBarItem(
          title: Text('Settings'),
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
