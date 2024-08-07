import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_melon/kontrol/kontrol.dart';
import 'package:flutter_melon/monitoring/monitor.dart';
import 'package:get/get.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Monitoring(),
    Kontrol(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang'),
        backgroundColor: Color.fromARGB(255, 12, 221, 9),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Get.to(profile());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              if (isLoading.isFalse) {
                isLoading.value = true;
                await FirebaseAuth.instance.signOut();
                isLoading.value = false;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ));
              }
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'Monitoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.control_point),
            label: 'Kontrol',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
