import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiKey =
      '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';
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> getChatResponse(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': userInput},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('Failed to get response from ChatGPT');
      }
    } catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }
}
