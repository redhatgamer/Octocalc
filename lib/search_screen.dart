import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv for secure API key handling

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<Map<String, String>> _messages = []; // To store user inputs and AI responses

  // Function to interact with Google Gemini API
  Future<void> _solveMathProblemWithGoogleGemini(String input) async {
    final String apiKey = dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? ''; // Fetch API key from .env
    final String apiUrl = 'https://api.google.com/v1/gemini/solve'; // Update with Gemini endpoint

    if (apiKey.isEmpty) {
      setState(() {
        _messages.add({
          "user": input,
          "solution": "API key is missing. Please configure your .env file."
        });
      });
      return;
    }

    try {
      // Construct the API request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'query': input,
          'mode': 'step-by-step', // Assuming Gemini supports step-by-step mode
          'max_tokens': 500, // Adjust as needed
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String explanation = data['steps']?.join("\n") ??
            "Sorry, I couldn't find a step-by-step solution for this problem.";

        setState(() {
          _messages.add({"user": input, "solution": explanation}); // Add to chat
        });
      } else {
        setState(() {
          _messages.add({
            "user": input,
            "solution": "Sorry, I couldn't process your request. Please try again."
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "user": input,
          "solution": "An error occurred. Please check your internet connection."
        });
      });
    }

    _inputController.clear(); // Clear input field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background for chat style
      appBar: AppBar(
        backgroundColor: const Color(0xFF252526),
        title: const Text('Your Math Helper'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Input
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message["user"]!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Solution
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message["solution"]!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Input Area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF252526),
                      hintText: "Type your math problem...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_inputController.text.isNotEmpty) {
                      _solveMathProblemWithGoogleGemini(_inputController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
