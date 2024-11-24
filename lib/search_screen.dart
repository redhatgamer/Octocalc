import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _solution = "";

  void _solveMathProblem(String input) {
    try {
      Parser parser = Parser();
      Expression expression = parser.parse(input);
      ContextModel cm = ContextModel();
      double result = expression.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _solution = result.toString();
      });
    } catch (e) {
      setState(() {
        _solution = "Invalid input. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solve Math Problems'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter a math problem (e.g., 2+2, sin(45), 3^2):",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: "Math Problem",
                hintText: "Type your problem here...",
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _solveMathProblem(_inputController.text),
              child: const Text("Solve"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Solution:",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              _solution,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
