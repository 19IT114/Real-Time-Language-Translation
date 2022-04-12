import 'package:flutter/material.dart';
import 'package:realtime/screens/chartScreen.dart';
import 'package:realtime/screens/speechScreen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Widget>> _selectScreen = [{}];

  int _selectIndex = 0;

  void _selectePage(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  void initState() {
    _selectScreen = const [
      {
        'pages': SpeechScreen(),
      },
      {
        'pages': ChartScreen(),
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectScreen[_selectIndex]['pages'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: _selectePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Speech',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
