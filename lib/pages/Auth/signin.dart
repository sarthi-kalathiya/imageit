import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imageit/pages/mainutil.dart';

import '../../service/google_auth.dart';
import 'email_verification_page.dart';
import 'signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.black,
        backgroundColor: Color.fromRGBO(25, 23, 32, 1),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                buildInputField(
                    controller: _emailController,
                    labelText: 'E-mail',
                    validator: validateEmail,
                    kb: TextInputType.emailAddress,
                    obscureText: false),
                SizedBox(
                  height: 20,
                ),
                buildInputField(
                  controller: _passwordController,
                  labelText: 'Password',
                  validator: validatePassword,
                  kb: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                  isPassword: true,
                ),
                SizedBox(height: 20),
                signInButton(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an Account?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignUpPage()),
                            (route) => false);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    required TextInputType kb,
    bool obscureText = false,
    bool isPassword = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width - 90,
      height: 55,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            keyboardType: kb,
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            style: TextStyle(color: Colors.white),
            // Text color
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: labelText,
              labelStyle: GoogleFonts.roboto(
                color: Colors.white, // Label text color
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
        ],
      ),
    );
  }

  myToast(String msg) {
    Fluttertoast.showToast(
        msg: msg, textColor: Colors.black87, backgroundColor: Colors.white);
  }

  Widget signInButton() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        setState(() {
          circular = true;
        });

        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          myToast(
            "Please fill in all fields.",
          );
          setState(() {
            circular = false;
          });
          return;
        }

        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text)) {
          myToast("Please enter a valid email address.");
          setState(() {
            circular = false;
          });
          return;
        }
        if (_passwordController.text.length < 8) {
          myToast("Password must be at least 8 characters long.");
          setState(() {
            circular = false;
          });
          return;
        }

        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);

          if (userCredential.user != null &&
              userCredential.user!.emailVerified) {
            // User is logged in and email is verified
            print(userCredential.user!.email);
            setState(() {
              circular = false;
            });

            // ignore: use_build_context_synchronously
            await authClass.storeTokenAndData("myMSG");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => mainutil()),
                (route) => false);
          } else {
            // Email is not verified, show an error or take appropriate action
            setState(() {
              circular = false;
            });
            // You may want to show an error message or navigate to a page prompting email verification
            // For example, you can redirect the user to the EmailVerificationScreen:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (builder) => EmailVerificationScreen(),
              ),
              (route) => false,
            );
          }
        } catch (e) {
          if (e.toString().contains("INVALID_LOGIN_CREDENTIALS")) {
            myToast("Please enter a valid email and password.");
          } else {
            myToast(e.toString());
          }
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 55,
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "Sign In",
                  style: TextStyle(
                      color: Color.fromRGBO(25, 23, 32, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'E-mail is required';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    //password must be alphanumeric
    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
        .hasMatch(value)) {
      return 'Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter and one number';
    }
    return null;
  }
}
