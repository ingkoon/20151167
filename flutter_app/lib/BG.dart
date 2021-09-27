import 'dart:ffi';

import 'package:flutter/material.dart';

// 라이브러리 부분
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'dart:math';

// 모듈 부분
import 'data.dart';
import 'connect.dart';
import 'chartData.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// stateful위젯을 올리기 위한 바탕 위젯
class BG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BG_Part',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: BG_Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 변화 감지를 위한 stateful위젯
class BG_Page extends StatefulWidget {
  @override
  _BG_Page createState() => _BG_Page();
}

class _BG_Page extends State<BG_Page> {
  // json 파싱을 받기 위한 클래스 선언 및 초기화
  Data data = new Data(0, 0);

  @override
  Widget build(BuildContext context) {
    connect(data);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GetBuilder<Data>(
            init: Data(data.bg, data.cgm),
            builder: (_) => Text('현재 혈당: ${data.bg}, 관측 값: ${data.cgm}'),
          ),
          // SfCartesianChart(
          //   series: <LineSeries<LiveData, double>>[
          //     LineSeries<LiveData, double>(
          //       dataSource: chartData,
          //       color: const Color.fromRGBO(192, 108, 132, 1),
          //       xValueMapper:
          //       yValueMapper:
          //     )
          //   ]
          // )
        ],
      )),
    );
  }
}
