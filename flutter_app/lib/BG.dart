import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';

import 'data.dart';
import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:get/get.dart';

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
  final client = MqttServerClient.withPort("192.168.1.101", "orlando", 1883);

  int BG_Value = 0;
  int CGM_value = 0;

  var data;

  // Map<String, dynamic> jsonData = flutter ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(onPressed: connect, child: const Text('테스트')),
          Text(this.BG_Value.toString()),
          Text(this.CGM_value.toString())
        ],
      )),
    );
  }

  Future<int> connect() async {
    // mqtt연결 설정 지정
    client.logging(on: true);

    //연결 지속 시간 지정(초단위)
    client.keepAlivePeriod = 60;
    // client.onDisconnected = onDisconnected();
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('connect-mqtt')
        .withWillTopic('connect-mqtt')
        // If you set this you must set a will message
        .withWillMessage('orlando')
        .startClean()
        // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      // Raised by the client when connection fails.

      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    print('EXAMPLE::Subscribing to the connect-mqtt topic');
    const topic = 'connect-mqtt'; // Not a wildcard topic
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;

      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      Map tmp = jsonDecode(pt);
      print(tmp);

      /// The above may seem a little convoluted for Datas only interested in the
      /// payload, some Datas however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });

    client.published!.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    print('EXAMPLE::Sleeping....');
    await MqttUtilities.asyncSleep(120);

    /// Finally, unsubscribe and exit gracefully
    // print('EXAMPLE::Unsubscribing');
    // client.unsubscribe(topic);

    /// Wait for the unsubscribe message from the broker if you wish.
    await MqttUtilities.asyncSleep(2);
    // print('EXAMPLE::Disconnecting');
    // client.disconnect();

    return 0;
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    exit(-1);
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }
}
