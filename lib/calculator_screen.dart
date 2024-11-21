import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive/hive.dart'; // Import Hive
import 'home_screen.dart'; // Import HomeScreen

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = '0';
  bool isEvaluated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final box = Hive.box('credentialsBox');
              box.put('isLoggedIn', false); // Reset the login state

              // Navigate back to the HomeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                displayText,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Divider(),
          buildButtons(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    List<String> buttons = [
      'C', '(', ')', '⌫',
      '7', '8', '9', '/',
      '4', '5', '6', '*',
      '1', '2', '3', '-',
      '.', '0', '=', '+',
    ];

    void onButtonPressed(String buttonText) {
      setState(() {
        if (buttonText == 'C') {
          displayText = '0';
          isEvaluated = false;
        } else if (buttonText == '⌫') {
          if (displayText.length > 1) {
            displayText = displayText.substring(0, displayText.length - 1);
          } else {
            displayText = '0';
          }
        } else if (buttonText == '=') {
          try {
            Parser parser = Parser();
            Expression exp = parser.parse(displayText);
            ContextModel cm = ContextModel();
            double eval = exp.evaluate(EvaluationType.REAL, cm);
            displayText = eval.toString();
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
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onButtonPressed(buttons[index]),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: getButtonColor(buttons[index]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  buttons[index],
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color getButtonColor(String button) {
    if (button == 'C' || button == '⌫') {
      return Colors.redAccent;
    } else if (['/', '*', '-', '+', '='].contains(button)) {
      return Colors.orange;
    } else {
      return Colors.grey[800]!;
    }
  }
}
