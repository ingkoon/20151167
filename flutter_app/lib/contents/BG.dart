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
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    initState();

    connect(data, dataList);

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
