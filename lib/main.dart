import 'package:flutter/material.dart';
import 'package:eindopdracht5/screens/home_screen.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _signedIn = false;

  void setSignedIn(bool signedIn) {
    setState(() {
      _signedIn = signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_signedIn);
    return MaterialApp(
      home: _signedIn
          ? HomeScreen(setSignedIn: setSignedIn)
          : LoginPage(setSignedIn: setSignedIn),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}