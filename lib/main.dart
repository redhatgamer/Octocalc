import 'package:flutter/material.dart';
import 'calculator_screen.dart';

void main() {
  runApp(AdvancedCalculatorApp());
}

class AdvancedCalculatorApp extends StatelessWidget { // Removed parentheses here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Calculator',
      theme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}
