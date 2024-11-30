import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' show pow, log, ln10;

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '0';
  bool isEvaluated = false;
  int decimalPlaces = 2;
  String numberFormat = 'Standard';

  @override
  void initState() {
    super.initState();
  }

  String _formatResult(double result) {
    if (numberFormat == 'Scientific') {
      return result.toStringAsExponential(decimalPlaces);
    } else if (numberFormat == 'Engineering') {
      int exp = result.abs() == 0 ? 0 : (log(result.abs()) / ln10).floor();
      int engExp = (exp / 3).floor() * 3;
      double coefficient = result / pow(10, engExp);
      return '${coefficient.toStringAsFixed(decimalPlaces)}e$engExp';
    } else {
      return result.toStringAsFixed(decimalPlaces);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(
                displayText,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(),
          buildButtons(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    List<String> buttons = [
      '7', '8', '9', '/',
      '4', '5', '6', '*',
      '1', '2', '3', '-',
      'C', '0', '=', '+',
    ];

    void onButtonPressed(String buttonText) {
      setState(() {
        if (buttonText == 'C') {
          displayText = '0';
          isEvaluated = false;
        } else if (buttonText == '=') {
          try {
            Parser parser = Parser();
            Expression exp = parser.parse(displayText);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            displayText = _formatResult(eval);
            isEvaluated = true;
          } catch (e) {
            displayText = 'Error';
          }
        } else {
          if (isEvaluated) {
            displayText = buttonText;
            isEvaluated = false;
          } else if (displayText == '0' && buttonText != '.') {
            displayText = buttonText;
          } else {
            displayText += buttonText;
          }
        }
      });
    }

    return Expanded(
      flex: 2,
      child: GridView.builder(
        itemCount: buttons.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onButtonPressed(buttons[index]),
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  buttons[index],
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
