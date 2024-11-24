import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String sourceCurrency = 'USD';
  String targetCurrency = 'EUR';
  String inputAmount = '100';
  String outputAmount = '0.00';
  double exchangeRate = 1.0;
  String displayText = '0';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchExchangeRate(sourceCurrency, targetCurrency);
    updateOutputAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        title: const Text('Converter Calculator'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
            color: const Color(0xFF00C853),
            borderRadius: BorderRadius.circular(25),
          ),
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
          buildCalculatorUI(),
        ],
      ),
    );
  }

  Widget buildCurrencyConverter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildCurrencyCard(sourceCurrency, inputAmount, true),
          const SizedBox(height: 16),
          buildCurrencyCard(targetCurrency, outputAmount, false),
          const SizedBox(height: 16),
          buildConversionActions(), // Call the fixed method
          const SizedBox(height: 16),
          buildNumericPad(), // Call the fixed method
        ],
      ),
    );
  }

  Widget buildConversionActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            // Add functionality if needed
          },
          icon: const Icon(Icons.history, color: Colors.green),
          iconSize: 32,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              // Swap currencies
              String temp = sourceCurrency;
              sourceCurrency = targetCurrency;
              targetCurrency = temp;
              fetchExchangeRate(sourceCurrency, targetCurrency);
            });
          },
          icon: const Icon(Icons.swap_horiz, color: Colors.green),
          iconSize: 32,
        ),
        IconButton(
          onPressed: () {
            fetchExchangeRate(sourceCurrency, targetCurrency); // Refresh
          },
          icon: const Icon(Icons.refresh, color: Colors.green),
          iconSize: 32,
        ),
      ],
    );
  }

  Widget buildNumericPad() {
    List<String> buttons = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '.', '0', '⌫',
    ];

    return Expanded(
      child: GridView.builder(
        itemCount: buttons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                if (buttons[index] == '⌫') {
                  inputAmount = inputAmount.isNotEmpty
                      ? inputAmount.substring(0, inputAmount.length - 1)
                      : '';
                } else {
                  inputAmount += buttons[index];
                }
                updateOutputAmount(); // Update conversion
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  buttons[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCurrencyCard(String currency, String amount, bool isInput) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isInput
                    ? '1 $sourceCurrency = ${exchangeRate.toStringAsFixed(3)} $targetCurrency'
                    : '1 $targetCurrency = ${(1 / exchangeRate).toStringAsFixed(3)} $sourceCurrency',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                isInput ? '\$$amount' : '\$$amount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          DropdownButton<String>(
            value: currency,
            dropdownColor: const Color(0xFF2C2C2E),
            items: ['USD', 'EUR', 'GBP', 'JPY']
                .map(
                  (currency) => DropdownMenuItem(
                value: currency,
                child: Text(
                  currency,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() {
                if (isInput) {
                  sourceCurrency = value!;
                } else {
                  targetCurrency = value!;
                }
                fetchExchangeRate(sourceCurrency, targetCurrency);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildCalculatorUI() {
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
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Divider(color: Colors.white24),
        Expanded(
          flex: 2,
          child: GridView.builder(
            itemCount: buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onButtonPressed(buttons[index]),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      buttons[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        displayText = '0';
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
        } catch (e) {
          displayText = 'Error';
        }
      } else {
        if (displayText == '0' && buttonText != '.') {
          displayText = buttonText;
        } else {
          displayText += buttonText;
        }
      }
    });
  }

  void updateOutputAmount() {
    setState(() {
      double input = double.tryParse(inputAmount) ?? 0.0;
      double result = input * exchangeRate;
      outputAmount = result.toStringAsFixed(2);
    });
  }

  Future<void> fetchExchangeRate(String source, String target) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$source'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          exchangeRate = data['rates'][target] ?? 1.0;
          updateOutputAmount();
        });
      } else {
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
    }
  }
}
