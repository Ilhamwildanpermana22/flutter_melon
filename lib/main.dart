import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_melon/home/home.dart';
import 'package:flutter_melon/regis/regis.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          print(snapshot.data);
          if (snapshot.data != null) {
            return GetMaterialApp(
              home: HomeScreen(),
            );
          } else {
            return const GetMaterialApp(
              home: MyApp(),
            );
          }
        }
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const login_screen(),
      ));
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 23, 181, 23),
              Color.fromARGB(218, 5, 196, 56)
            ],
          )),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 340,
                ),
                Image.asset(
                  'assets/melon.png',
                  width: 100,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Melon Ku',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(login_screen());
          },
          child: Icon(Icons.arrow_circle_right),
          backgroundColor: Colors.black,
        ));
  }
}

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  RxBool isLoading = false.obs;
  final emailC = TextEditingController();
  final passC = TextEditingController();

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailC.text, password: passC.text);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (emailC.text != UserCredential) {
          Get.snackbar("Terjadi Kesalahan", "User tidak terdaftar");
        } else if (passC.text != UserCredential) {
          Get.snackbar("Terjadi Keslahan", "Password anda salah");
        }
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib di isi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 6, 190, 15),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage('assets/melon.png')),
                    ),
                    height: 190,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: emailC,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 4, 194, 36)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          label: Text('Email')),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: passC,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: Color.fromARGB(255, 4, 170, 40)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.black,
                        label: Text('Password'),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {}, child: Text('Lupa Password?'))),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        if (isLoading.isFalse) {
                          await login();
                        }
                      },
                      icon: Icon(Icons.arrow_right_rounded),
                      label: Text("Login")),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        Get.to(regis_screen());
                      },
                      icon: Icon(Icons.app_registration_rounded),
                      label: Text("Registrasi"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
