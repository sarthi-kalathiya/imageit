import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/google_auth.dart';
import 'email_verification_page.dart';
import 'signin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(25, 23, 32, 1),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  buildInputField(
                      controller: _emailController,
                      labelText: 'E-mail',
                      validator: validateEmail,
                      kb: TextInputType.emailAddress,
                      obscureText: false),
                  SizedBox(height: 20),
                  buildInputField(
                    controller: _phoneNumberController,
                    labelText: 'Phone Number',
                    validator: validatePhoneNumber,
                    kb: TextInputType.phone,
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  buildInputField(
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: validatePassword,
                    kb: TextInputType.visiblePassword,
                    obscureText: !_isPasswordVisible,
                    isPassword: true,
                  ),
                  SizedBox(height: 20),
                  buildInputField(
                    controller: _companyNameController,
                    labelText: 'Company Name',
                    validator: validateCompanyName,
                    kb: TextInputType.text,
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  signUpButton(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 5),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => SignInPage()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 150),
                ],
              ),
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

  Widget signUpButton() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () async {
        setState(() {
          circular = true;
        });

        if (_emailController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _phoneNumberController.text.isEmpty ||
            _companyNameController.text.isEmpty) {
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

        // Validate phone number
        if (_phoneNumberController.text.length != 10 ||
            !_phoneNumberController.text.characters
                .every((element) => element.contains(RegExp(r'[0-9]')))) {
          myToast("Please enter a valid 10-digit phone number.");
          setState(() {
            circular = false;
          });
          return;
        }

        // Validate other fields

        // Validate password length
        if (_passwordController.text.length < 8) {
          myToast("Password must be at least 8 characters long.");
          setState(() {
            circular = false;
          });
          return;
        }

        try {
          // Hashing the password using bcrypt
          String hashedPassword =
              BCrypt.hashpw(_passwordController.text, BCrypt.gensalt());
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);

          // Storing additional user details in Firebase
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'email': _emailController.text,
            'phoneNumber': _phoneNumberController.text,
            'companyName': _companyNameController.text,
            'password': _passwordController.text
          });
          // print(userCredential.user!.email);
          setState(() {
            circular = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (builder) => EmailVerificationScreen()),
              (route) => false);
        } catch (e) {
          if (e.toString().contains("email-already-in-use")) {
            myToast("Email address already in use.");
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
                  "Register",
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

  bool _validateForm() {
    return Form.of(context)!.validate();
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

  String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Phone Number is required';
    }
    if (!value.characters
        .every((element) => element.contains(RegExp(r'[0-9]')))) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateCompanyName(String? value) {
    if (value!.isEmpty) {
      return 'Company Name is required';
    }
    return null;
  }
}
