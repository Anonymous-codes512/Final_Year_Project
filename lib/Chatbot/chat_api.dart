import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApi {
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent";
  static const String _apiKey = "AIzaSyBZqqKa5CnYkQf4mNZIj7L7yMa_2v5ed8s"; // Replace with your actual API key

  static Future<String> sendMessage(String message) async {
    try {
      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      });

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Debugging: print the entire response to understand the structure
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Debugging: print parsed data
        print('Parsed Data: $data');

        // Update the parsing to match the new response structure
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          // Return the text from the first candidate's response
          return data['candidates'][0]['content']['parts'][0]['text'] ?? "No response from server";
        } else {
          return "No response from server";
        }
      } else {
        return "Error: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
