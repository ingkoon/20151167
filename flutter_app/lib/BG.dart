import 'dart:html';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dart_amqp/dart_amqp.dart';

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

class BG_Page extends StatefulWidget {
  @override
  _BG_Page createState() => _BG_Page();
}

class _BG_Page extends State<BG_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[],
      )),
    );
  }

  void transfer() async {
    Client client = Client();

    Channel channel = await client.channel();
    Queue queue = await channel.queue('test_mq');
    Consumer consumer = await queue.consume();
    consumer.listen((AmqpMessage message) {
      print("$message.payload");
    });
  }
}
