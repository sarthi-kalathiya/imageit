import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imageit/pages/Auth/signin.dart';
import 'package:imageit/pages/mainutil.dart';
import '../service/google_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignInPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = mainutil();
      });
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home:currentPage,
      debugShowCheckedModeBanner: false,
    );
  }
}
