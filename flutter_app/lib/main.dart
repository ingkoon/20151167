import 'package:flutter/material.dart';
import 'package:flutter_app/UI.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'BGSTATE'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  List<dynamic> patientsList = [
    'adolescent#001',
    'adolescent#002',
    'adolescent#003',
    'adolescent#004',
    'adolescent#005',
    'adolescent#006',
    'adolescent#007',
    'adolescent#008',
    'adolescent#009',
    'adolescent#010',
    'adolescent#011',
    'adolescent#012',
  ];
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 15));

    return Scaffold(
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(6),
              itemCount: patientsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 30,
                  child: Container(
                      child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 90),
                        child: Text('환자명: ${patientsList[index]}'),
                      ),
                      ElevatedButton(
                          style: style,
                          child: const Text('연결 실행'),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => UI()));
                          }),
                    ],
                  )),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ],
        ),
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
