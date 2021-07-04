import 'package:flutter/material.dart';
//import 'package:flutter_app/main.dart';

class UI extends StatelessWidget {
  const UI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UI_Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UI_Page extends StatefulWidget {
  const UI_Page({Key? key}) : super(key: key);

  @override
  _UI_Page createState() => _UI_Page();
}

class _UI_Page extends State<UI_Page> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      '현재 혈당',
      style: optionStyle,
    ),
    Text(
      '예측 혈당',
      style: optionStyle,
    ),
    Text(
      '혈당 관리 정보',
      style: optionStyle,
    ),
    Text(
      '사용자 정보',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'BG',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype_outlined),
            label: 'Predict BG',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
