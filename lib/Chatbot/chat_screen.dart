import 'package:flutter/material.dart';
import 'package:final_year_project/Chatbot/chat_api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'user': message});
      _isLoading = true;
    });

    _controller.clear();
    final response = await ChatApi.sendMessage(message);
    setState(() {
      _messages.add({'bot': response});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
        backgroundColor: const Color(0xFF373E37), // Black
        foregroundColor: Colors.white, // White text
      ),
      body: Container(
        color: const Color(0xFFFAF9F6), // Off-white background
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.containsKey('user');

                  // Styling for message bubbles
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFFFFDE59) // Yellow for user
                          : const Color(0xFF373E37), // Black for bot
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isUser
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                        bottomRight: isUser
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Text(
                      isUser ? message['user']! : message['bot']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: isUser
                            ? Colors.black87 // Dark text for user
                            : Colors.white, // White text for bot
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Color(0xFF373E37), // Black for loader
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF), // White input field
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_controller.text),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFF373E37), // Black send button
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
