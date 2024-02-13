import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<String?> fetchPrediction(String url) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/process_url'), // Your Flask server URL
      body: {'url': "https://firebasestorage.googleapis.com/v0/b/imageit-c93a9.appspot.com/o/images%2F1000268201_693b08cb0e.jpg?alt=media&token=4bf1f673-89eb-449a-9f4a-12c2d5f5a153"}, // Data to send in the body of the request
    );

    if (response.statusCode == 200) {
      // If the server returns a successful response, return the prediction
      return jsonDecode(response.body);
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load prediction');
    }
  } catch (e) {
    // Handle any exceptions
    print('Error fetching prediction: $e');
    return null;
  }
}

Future<String?> fetchPredictionget() async {
  // try {
  //   final response = await http.get(
  //     Uri.parse('http://127.0.0.1:3000/hello'), // Your Flask server URL
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // If the server returns a successful response, return the prediction
  //     return jsonDecode(response.body);
  //   } else {
  //     // If the server returns an error response, throw an exception
  //     throw Exception('Failed to load prediction');
  //   }
  // } catch (e) {
  //   // Handle any exceptions
  //   print('Error fetching prediction: $e');
  //   return null;
  // }

  print("started\n\n\n");
  try {
    final response = await http.get(Uri.parse('http://192.168.89.249:3000/hello?ival=20'));
    if (response.statusCode == 200) {
      print(response.body);
      // setState(() {
      //   _responseText = response.body;
      // });
    } else {
      // setState(() {
      //   _responseText = 'Failed to load data: ${response.statusCode}';
      // });
    }
    print("ended\n\n\n");
  } catch (e) {
    // setState(() {
    //   _responseText = 'Error: $e';
    // });
    print(e.toString());
    print("catch\n\n\n");
  }
}