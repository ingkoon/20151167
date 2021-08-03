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
        children: <Widget>[
          ElevatedButton(onPressed: transfer, child: const Text('테스트'))
        ],
      )),
    );
  }

  void transfer() async {
    // mqtt연결 설정 지정
    ConnectionSettings settings = new ConnectionSettings(
      host: "192.168.1.101",
      port: 5672,
      virtualHost: 'master',
      authProvider: const AmqPlainAuthenticator('master', 'cucumber52'),
    );

    // mq client 생성
    Client client = Client(settings: settings);
    Channel channel = await client.channel();
    Queue queue = await channel.queue('test_mq', durable: true);
    Consumer consumer = await queue.consume();

    print("Connection Success!");
    print(" [*] Waiting for messages. To exit, press CTRL+C");
    // String data;
    consumer.listen((message) {
      print(" [x] Received ${message.payloadAsString}");
      // data = message.payloadAsString;
    });
  }
}
