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

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// stateful위젯을 올리기 위한 바탕 위젯
class predictBG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'predictBG_Part',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: predictBG_Page(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 변화 감지를 위한 stateful위젯
class predictBG_Page extends StatefulWidget {
  @override
  _predictBG_Page createState() => _predictBG_Page();
}

class _predictBG_Page extends State<predictBG_Page> {
  // json 파싱을 받기 위한 클래스 선언 및 초기화
  Data data = new Data(0, 0, "");

  ChartSeriesController? chartSeriesController;
  int count = 1;
  List<chartData> dataList = <chartData>[];
  Timer? timer;
  late TooltipBehavior _tooltipBehavior;

  // var _flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    // super.initState();
  }

  Future<void> onSelectNotification(String payload) async {
    debugPrint("$payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notification Payload'),
              content: Text('Payload: $payload'),
            ));
  }

  @override
  Widget build(BuildContext context) {
    initState();

    // const AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('app_icon');
    // IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    // var initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
    String topic = 'connect-mqtt-lstm';
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
                        DateTime.now().hour - 1,
                        DateTime.now().minute),
                    maximum: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        DateTime.now().hour + 1,
                        DateTime.now().minute),
                    rangePadding: ChartRangePadding.additional,
                    majorGridLines: MajorGridLines(width: 1),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    intervalType: DateTimeIntervalType.minutes,
                    interval: 10),
                primaryYAxis:
                    NumericAxis(minimum: 0, maximum: 300, interval: 50),
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

//알림을 보내기 위한 메서드
//   Future<void> _showNotification() async {
//     AndroidNotificationDetails android = AndroidNotificationDetails(
//         'your channel id', 'your channel name',
//         importance: Importance.max, priority: Priority.high, ticker: 'ticker');

//     NotificationDetails detail = NotificationDetails(android: android);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       '혈당 증가',
//       '환자의 혈당이 현재 위험 수준을 초과했습니다.',
//       detail,
//       payload: '위험 수준 혈당을 감지하였습니다.',
//     );
//   }

  @override
  void dispose() {
    super.dispose();

    // Cancelling the timer.
    timer?.cancel();
  }

  void _updateDataSource(Timer timer) {
    dataList.add(chartData(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            DateTime.now().hour, DateTime.now().minute),
        data.cgm));

    // if (data.cgm > 150.0) {
    //   _showNotification();
    // }
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
