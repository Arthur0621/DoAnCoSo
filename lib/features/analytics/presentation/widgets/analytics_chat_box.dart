import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticsChatBox extends StatefulWidget {
  const AnalyticsChatBox({super.key});

  @override
  State<AnalyticsChatBox> createState() => _AnalyticsChatBoxState();
}

class _AnalyticsChatBoxState extends State<AnalyticsChatBox> {
  void _openChatSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return _ChatSheetContent(
              messages: _messages,
              controller: _controller,
              isLoading: _isLoading,
              onSend: _sendMessage,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _isLoading = true;
    });
    _controller.clear();
    try {
      final botReply = await callChatGPT(userMessage);
      setState(() {
        _messages.add({'role': 'bot', 'content': botReply});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'Lỗi: $e'});
        _isLoading = false;
      });
    }
  }

  Future<String> callChatGPT(String message) async {
    final apiKey = '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';
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ]
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Chatbot API error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          color: Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openChatSheet,
            child: Container(
              height: 52, // nhỏ hơn card biểu đồ
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.purple, size: 22),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Tư vấn chi tiêu với ChatGPT',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: const Text('Chat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _ChatSheetContent extends StatelessWidget {
  final List<Map<String, String>> messages;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;
  final ScrollController scrollController;
  const _ChatSheetContent({
    required this.messages,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 8),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Tư vấn chi tiêu với ChatGPT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.purple[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(msg['content'] ?? '', style: const TextStyle(color: Colors.black)),
                    ),
                  );
                },
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Nhập câu hỏi về chi tiêu...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.purple),
                  onPressed: isLoading ? null : onSend,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

