import 'package:app/model/constants.dart';
import 'package:app/ui/all_notes.dart';
import 'package:app/ui/settings.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int initialPosition;

  AppBottomNavigationBar(
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
        if (_currentIndex != value) {
          switch (value) {
            case Constants.appBarHomePosition:
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          const AllNotes(starredFragment: false)));
              break;
            case Constants.appBarSettingsPosition:
              Navigator.pushReplacement(context,
                  PageRouteBuilder(pageBuilder: (_, __, ___) => Settings()));
              break;
            default:
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          const AllNotes(starredFragment: true)));
              break;
          }
        }
        setState(() => _currentIndex = value);
      },
      items: const [
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.stars),
          label: 'Feed',
          icon: Icon(Icons.stars_outlined),
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.search),
          label: 'Search',
          icon: Icon(Icons.search_outlined),
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
          icon: Icon(Icons.chat_bubble_outline),
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
          icon: Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
