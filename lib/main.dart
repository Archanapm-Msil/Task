import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MethodChannel _channel = MethodChannel('sim_card_reader');
  Map<String, String> simCardInfo = {};

  @override
  void initState() {
    super.initState();
    getSimCardInfo();
  }

  Future<void> getSimCardInfo() async {
    try {
      final Map<String, String> result =
          await _channel.invokeMethod('getSimCardInfo');
      setState(() {
        simCardInfo = result;
      });
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIM Card Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Phone Number: ${simCardInfo["phoneNumber"] ?? "N/A"}'),
            Text('Carrier Name: ${simCardInfo["carrierName"] ?? "N/A"}'),
          ],
        ),
      ),
    );
  }
}
