import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class Kontrol extends StatefulWidget {
  const Kontrol({Key? key});

  @override
  State<Kontrol> createState() => _KontrolState();
}

class _KontrolState extends State<Kontrol> {
  bool isLEDOn = false;
  bool isAutomaticModeOn = false;

  final databaseReference = FirebaseDatabase.instance.reference();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      startTimer();
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (isAutomaticModeOn) {
        checkTimeAndToggleLED();
      }
    });
  }

  void checkTimeAndToggleLED() async {
    final now = DateTime.now();
    print('Current time: ${now.hour}:${now.minute}:${now.second}');

    // Check if it's time to turn on the LED
    if ((now.hour == 12 ||
            now.hour == 14 ||
            now.hour == 15 ||
            now.hour == 16) &&
        now.minute == 0 &&
        now.second == 0) {
      print('Turning on the LED');
      setState(() {
        isLEDOn = true;
        toggleLEDLocally(isLEDOn);
      });

      // Wait for 10 seconds
      await Future.delayed(Duration(seconds: 60));

      // Turn off the LED
      setState(() {
        isLEDOn = false;
        toggleLEDLocally(isLEDOn);
      });
      print('LED turned off after  60 seconds');
    }
  }

  void toggleLED() {
    setState(() {
      isLEDOn = !isLEDOn;
      toggleLEDLocally(isLEDOn);
    });
  }

  void toggleAutomaticMode() {
    setState(() {
      isAutomaticModeOn = !isAutomaticModeOn;
    });
  }

  void toggleLEDLocally(bool value) {
    databaseReference.child('control').update({'led': value}).then((_) {
      print('LED status updated to $value');
    }).catchError((error) {
      print('Failed to update LED status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kontrol Sistem"),
        backgroundColor: Color.fromARGB(255, 12, 221, 9),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Mode: ${isAutomaticModeOn ? 'Otomatis' : 'Manual'}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Kontrol Valve',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Status: ${isLEDOn ? 'Aktif' : 'Nonaktif'}',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: toggleLED,
              child: Text('${isLEDOn ? 'Matikan' : 'Hidupkan'}'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: toggleAutomaticMode,
              child: Text(
                  '${isAutomaticModeOn ? 'Matikan' : 'Hidupkan'} Mode Otomatis'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Info: Va;ve akan menyala setiap hari pukul 02:00 AM selama 60 detik ktika mode otomatis di nyalakan.',
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
