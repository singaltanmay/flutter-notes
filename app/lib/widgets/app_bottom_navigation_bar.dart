import 'package:app/model/constants.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int initialPosition;

  const AppBottomNavigationBar(
      {Key? key, this.initialPosition = Constants.appBarHomePosition})
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
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Search',
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: 'Starred',
          icon: Icon(Icons.star),
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}
