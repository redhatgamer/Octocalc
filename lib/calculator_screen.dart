import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String displayText = '0';
  bool isEvaluated = false;
  double exchangeRate = 1.0;
  String targetCurrency = 'EUR';
  String sourceCurrency = 'USD';
  String currencyInput = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchExchangeRate(sourceCurrency, targetCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Converter'),
            Tab(text: 'Calculator'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildCurrencyConverter(),
          buildCalculator(),
        ],
      ),
    );
  }

  Widget buildCurrencyConverter() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Enter Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      currencyInput = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: sourceCurrency,
                items: ['USD', 'EUR', 'GBP', 'JPY']
                    .map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    sourceCurrency = value!;
                    fetchExchangeRate(sourceCurrency, targetCurrency);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Converted Amount: ${(double.tryParse(currencyInput) ?? 0) * exchangeRate}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: targetCurrency,
                items: ['USD', 'EUR', 'GBP', 'JPY']
                    .map((currency) => DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    targetCurrency = value!;
                    fetchExchangeRate(sourceCurrency, targetCurrency);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCalculator() {
    List<String> buttons = [
      'C', '(', ')', '⌫',
      '7', '8', '9', '/',
      '4', '5', '6', '*',
      '1', '2', '3', '-',
      '.', '0', '=', '+',
    ];

    return Column(
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
        Expanded(
          flex: 2,
          child: GridView.builder(
            itemCount: buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
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
        ),
      ],
    );
  }

  Future<void> fetchExchangeRate(String source, String target) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.exchangerate-api.com/v4/latest/$source')); // Replace with your API
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          exchangeRate = data['rates'][target] ?? 1.0;
        });
      } else {
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
    }
  }

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
