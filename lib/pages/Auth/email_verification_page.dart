import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../firebase_constants.dart';
import '../../service/google_auth.dart';
import '../OCR/OCRHome.dart';

class EmailVerificationScreen extends StatefulWidget {
  EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  AuthClass authClass = AuthClass();
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 2), (_) => checkEmailVerified());
  }

  myToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, textColor: Colors.black87, backgroundColor: Colors.white);
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification

      // print("emain is verified");
      await authClass.storeTokenAndData("myMSG");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ocrText()),
      );
      myToast("Email Successfully Verified");
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(25, 23, 32, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Check your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'We have sent you a Email on',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                '${auth.currentUser?.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  // fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              // CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              // ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  try {
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  } catch (e) {
                    print(" hello " + '$e');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 15, bottom: 15),
                  child: Text(
                    'Resend Verification Email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(25, 23, 32, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
