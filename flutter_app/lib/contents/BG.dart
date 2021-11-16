import 'dart:ffi';

import 'package:flutter/material.dart';

// 라이브러리 부분
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'dart:async';

// 모듈 부분
import 'package:flutter_app/sub/data.dart';
import 'package:flutter_app/sub/connect.dart';
// import 'chartData.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  Data data = new Data(0, 0, "");

  ChartSeriesController? chartSeriesController;
  int count = 1;
  List<chartData> dataList = <chartData>[];
  Timer? timer;
  late TooltipBehavior _tooltipBehavior;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    init();
  }

  void init() async {
    // 알림용 ICON 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 알림 초기화
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      //onSelectNotification은 알림을 선택했을때 발생
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }

// 알림 발생 함수!!
  Future<void> _showNotification() async {
    // 알림 채널
    const String Id = 'id';
    // 채널 이름
    const String Name = 'channel';
    // 채널 설명

    // 안드로이드 알림 설정
    const AndroidNotificationDetails notificationAndroidSpecifics =
        AndroidNotificationDetails(
      Id,
      Name,
      importance: Importance.max,
      priority: Priority.high,
    );

    // 플랫폼별 설정 - 안드로이드만 적용됨
    const NotificationDetails notificationPlatformSpecifics =
        NotificationDetails(android: notificationAndroidSpecifics);

    // 알림 발생!
    await flutterLocalNotificationsPlugin.show(
        0, "", '현재 환자의 혈당이 위험 상태입니다', notificationPlatformSpecifics);
    // 이때는 ID를 0으로 고정시켜 새로 생성되지 않게 한다.
  }

  @override
  Widget build(BuildContext context) {
    String topic = 'connect-mqtt';
    connect(data, dataList, topic);

    timer =
        Timer.periodic(const Duration(milliseconds: 30000), _updateDataSource);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //상태 감지를 위한 getBuilder 선언
          GetBuilder<Data>(
            init: Data(data.bg, data.cgm, data.timeData),
            builder: (_) => Column(children: <Widget>[
              Text(
                  '현재 혈당: ${data.bg}, 관측 값: ${data.cgm}, 현재시간: ${data.timeData}'),
              SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                primaryXAxis: DateTimeAxis(
                    minimum: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        DateTime.now().hour,
                        DateTime.now().minute,
                        DateTime.now().second - 120),
                    maximum: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        DateTime.now().hour,
                        DateTime.now().minute,
                        DateTime.now().second),
                    rangePadding: ChartRangePadding.additional,
                    majorGridLines: MajorGridLines(width: 1),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    intervalType: DateTimeIntervalType.seconds,
                    interval: 5),
                primaryYAxis:
                    NumericAxis(minimum: 50, maximum: 300, interval: 10),
                series: <ChartSeries<chartData, DateTime>>[
                  LineSeries<chartData, DateTime>(
                    onRendererCreated: (ChartSeriesController controller) {
                      // Assigning the controller to the _chartSeriesController.
                      chartSeriesController = controller;
                    },
                    enableTooltip: true,
                    // Binding the chartData to the dataSource of the line series.
                    dataSource: dataList,
                    xValueMapper: (chartData patientdata, _) =>
                        patientdata.time,
                    yValueMapper: (chartData patientdata, _) => patientdata.cgm,
                  )
                ],
              ),
            ]),
          ),
        ],
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Cancelling the timer.
    timer?.cancel();
  }

  void _updateDataSource(Timer timer) {
    dataList.add(chartData(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
        ),
        data.cgm));

    if (data.cgm > 150.0) {
      _showNotification();
    }
    if (dataList.length == 100) {
      // Removes the last index data of data source.
      dataList.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[dataList.length - 1],
          removedDataIndexes: <int>[0]);
    } else {
      chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[dataList.length - 1],
      );
    }
    ;
  }
}

// 리스트에 넣기 위한 데이터
class chartData {
  chartData(
    this.time,
    this.cgm,
  );
  final DateTime time;
  final double cgm;
}
