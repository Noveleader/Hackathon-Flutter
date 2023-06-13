/// This file contains the main code for the app, including the `MyApp` and `LoginPage` classes.
/// `MyApp` is a stateless widget that returns a `MaterialApp` widget with a `title`, `debugShowCheckedModeBanner`, `theme`, and `home` property.
/// `LoginPage` is a stateless widget that returns a `Scaffold` widget with a `backgroundColor` and a `body` property that contains a `Column` widget with a `Text` widget, an `Image` widget, and an `ElevatedButton` widget.
import 'package:flutter/material.dart';
import 'package:myapp/import.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.white,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "HealthCare",
            style: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontWeight: FontWeight.bold),
          ),
          const Text(
            "with Web3",
            style: TextStyle(
                color: Colors.white, //white70 means opacity is 70%
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20.0, //To add some space between the two texts
          ),
          Image.asset(
            'images/juicy-physician.png',
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            //Editing the login button
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ImportWallet();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(150, 50),
            ),
            child: const Text(
              "Import Wallet",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      )),
    );
  }
}
