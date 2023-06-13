import 'package:flutter/material.dart';
// import 'package:myapp/home_page.dart';
import 'package:myapp/import.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        // primarySwatch: Colors.green,
      ),
      home: //defines the home page of the application
          const LoginPage(), //If it is a constant the flutter will know it doesn't need to refresh the thing
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //Widget start with capital letter
      //Just the Scaffold widget is constant but with the appbar it isn't the constant, so we need to remove constant keyword.
      // appBar: AppBar(
      //   title: const Text("Blog App"),
      //   centerTitle: true,
      // ),
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
            height: 20.0, //To add some space between the two texts
          ),
          ElevatedButton(
            //Editing the login button
            onPressed: () {
              //This takes a function which is another file, here const homepage is another dart file, when we click on login, app will take us to HomePage of the app
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

      //To put this above text at center we first use the Text widget under body widget and then we use the Center widget under the Text widget.
      //This is available when you right click on Text and then refactor and then extract widget.
    );
  }
}
