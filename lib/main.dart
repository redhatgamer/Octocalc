import 'package:flutter/material.dart';
import 'caculator_screen.dart';

void main() {
  runApp(AdvancedCalculatorApp());
}



class AdvancedCalculatorApp() extends StatelessWidget {
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Advanced Calculator',
      theme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}


