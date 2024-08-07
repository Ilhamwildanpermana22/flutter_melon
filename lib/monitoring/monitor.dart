import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Monitoring extends StatefulWidget {
  const Monitoring({super.key});

  @override
  State<Monitoring> createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  String tds = '0';
  String mos = '0';

  late DatabaseReference _sensorRef;

  @override
  void initState() {
    super.initState();
    _sensorRef = FirebaseDatabase.instance.ref().child('sensor');
    _sensorRef.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        var child = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          tds = child['tds'].toString();
          mos = child['mos'].toString();
        });
      }
    });
  }

  double _getPercentage(String value, double max) {
    double val = double.tryParse(value) ?? 0.0;
    return (val / max).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildCircularIndicator('Tds', tds, 14.0),
              SizedBox(height: 20),
              _buildCircularIndicator('Kelembapan', mos, 100.0),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularIndicator(String title, String value, double max) {
    double percentage = _getPercentage(value, max);
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$title: $value',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 10.0,
              percent: percentage,
              center: Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              progressColor: Colors.green,
              backgroundColor: Color.fromARGB(255, 184, 117, 117),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
            ),
          ],
        ),
      ),
    );
  }
}
