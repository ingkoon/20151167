import 'dart:ffi';

import 'package:flutter/material.dart';

// 라이브러리 부분

// 모듈 부분

// stateful위젯을 올리기 위한 바탕 위젯
class User extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BG_Part',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: User_Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 변화 감지를 위한 stateful위젯
class User_Page extends StatefulWidget {
  @override
  _User_Page createState() => _User_Page();
}

class _User_Page extends State<User_Page> {
  // json 파싱을 받기 위한 클래스 선언 및 초기화

  @override
  void initState() {
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 0, bottom: 0),
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      spreadRadius: 0),
                ],
                color: const Color(0xffaaaaaa)),
            child: Icon(
              Icons.person,
              size: 150,
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 0),
            width: 200,
            height: 50,
            child: Text(
              'adolescent#001',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 0),
            width: 200,
            height: 100,
            child: Text(
              'Age: 15',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
