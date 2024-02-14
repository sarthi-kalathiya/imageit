import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/google_auth.dart';
import 'HomePage.dart';

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
  // int elapsedTime = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 2), (_) => checkEmailVerified());
  }

  // void initState() {
  //   super.initState();
  //   FirebaseAuth.instance.currentUser?.sendEmailVerification();
  //
  //   // Start a timer to check email verification status every 2 seconds
  //   timer = Timer.periodic(const Duration(seconds: 2), (timer) {
  //     elapsedTime += 2;
  //     checkEmailVerified();
  //
  //     // Check if 20 seconds have passed, and the email is still not verified
  //     if (elapsedTime >= 20 && !isEmailVerified) {
  //       deleteUser();
  //       timer.cancel(); // Stop the timer
  //     }
  //   });
  // }

  // deleteUser() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser?.delete();
  //     // Optionally, you can also delete the user data from Firestore
  //     // await FirebaseFirestore.instance.collection('users').doc(widget.uid).delete();
  //   } catch (e) {
  //     print("Error deleting user: $e");
  //   }
  // }

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
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       backgroundColor: Color.fromRGBO(25, 23, 32, 1),
  //       body: Center(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               'Check your Email',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Center(
  //               child: Text(
  //                 'We have sent you a Email on  ${auth.currentUser?.email}',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 30,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               // ),
  //             ),
  //             const SizedBox(height: 16),
  //             // const Center(child: CircularProgressIndicator()),
  //             const SizedBox(height: 8),
  //             Center(
  //               child: Text(
  //                 'Verifying email....',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 30,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //                 // ),
  //               ),
  //             ),
  //             const SizedBox(height: 150),
  //             Container(
  //               width: MediaQuery.of(context).size.width - 90,
  //               height: 55,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: Colors.white, // Choose your desired button color
  //               ),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   try {
  //                     FirebaseAuth.instance.currentUser
  //                         ?.sendEmailVerification();
  //                   } catch (e) {
  //                     debugPrint('$e');
  //                   }
  //                 },
  //                 style: ButtonStyle(
  //                   backgroundColor:
  //                       MaterialStateProperty.all<Color>(Colors.transparent),
  //                   elevation: MaterialStateProperty.all<double>(0),
  //                   shape: MaterialStateProperty.all<OutlinedBorder>(
  //                     RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                   ),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Resend',
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color.fromRGBO(25, 23, 32, 1),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
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
