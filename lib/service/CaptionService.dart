import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<String?> fetchPrediction(String url) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/process_url'),
      body: {
        'url':
            url
      }, // Data to send in the body of the request
    );

    if (response.statusCode == 200) {

      // If the server returns a successful response, parse the JSON response
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Extract the prediction from the JSON object
      final String prediction = data['prediction'];
      print(prediction);
      return prediction;

      // If the server returns a successful response, return the prediction
      // return jsonDecode(response.body);
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