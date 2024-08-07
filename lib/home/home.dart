import 'package:cloud_firestore/cloud_firestore.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(227, 3, 135, 31),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/melon.png")
                      // Ganti dengan URL foto profil Anda
                      ),
                  SizedBox(height: 10),
                  Text(
                    "Buah Melon",
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 235, 107),
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "IoT",
                    style: TextStyle(
                      color: Color.fromARGB(255, 90, 238, 132),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.monitor),
              title: Text('Monitoring'),
              onTap: () {
                Get.to(Monitoring());
              },
            ),
            ListTile(
              leading: Icon(Icons.control_point),
              title: Text('Kontrol'),
              onTap: () {
                Get.to(Kontrol());
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Smart Greenhouse!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
