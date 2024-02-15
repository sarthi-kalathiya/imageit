import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<String?> fetchPrediction(String url) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/process_url'), // Your Flask server URL
      body: {
        'url':
            "https://firebasestorage.googleapis.com/v0/b/imageit-c93a9.appspot.com/o/images%2F1001773457_577c3a7d70.jpg?alt=media&token=c7dc8050-e727-4bc9-a732-276fdcdbb522"
      }, // Data to send in the body of the request
    );

    if (response.statusCode == 200) {

      // If the server returns a successful response, parse the JSON response
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Extract the prediction from the JSON object
      final String prediction = data['prediction'];
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
