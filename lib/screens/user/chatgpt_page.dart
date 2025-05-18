import 'package:flutter/material.dart';
import 'package:go_perak/services/chatgpt_service.dart';

class ChatgptPage extends StatefulWidget {
  @override
  _ChatgptPageState createState() => _ChatgptPageState();
}

class _ChatgptPageState extends State<ChatgptPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatGPTService _chatGPTService = ChatGPTService();
  String _chatResponse = '';

  void _sendMessage() async {
    final userInput = _controller.text;
    if (userInput.isNotEmpty) {
      final response = await _chatGPTService.getChatResponse(userInput);
      setState(() {
        _chatResponse = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with GPT')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: Text(_chatResponse))),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
