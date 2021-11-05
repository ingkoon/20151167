import 'package:flutter/material.dart';
import 'package:flutter_app/contents/BG.dart';
// import 'package:flutter_app/contents/predictBG.dart';
// import 'package:flutter_app/contents/information.dart';
// import 'package:flutter_app/contents/user.dart';

//기본 배경의 역할을 하는 stateless위젯
class UI extends StatelessWidget {
  const UI({Key? key}) : super(key: key);

  // 빌드 단계
  @override
  Widget build(BuildContext context) {
    // 머티리얼 앱 반환
    return MaterialApp(
      // 타이틀 지정
      title: 'UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 메인이 될 페이지 지정
      home: UI_Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//메인 페이지 지정
class UI_Page extends StatefulWidget {
  const UI_Page({Key? key}) : super(key: key);

  //동적 페이지 생성
  @override
  _UI_Page createState() => _UI_Page();
}

//메인 페이지
class _UI_Page extends State<UI_Page> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    BG(),
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
      appBar: AppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),

      // Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
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
            icon: Icon(Icons.menu_book),
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
