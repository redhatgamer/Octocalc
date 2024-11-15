import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Advanced Calculator'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Hello! Ready to calculate?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Feature Highlights
            Text(
              'Features:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FeatureTile(icon: Icons.calculate, title: 'Advanced Calculations', description: 'Perform complex calculations with ease.'),
            FeatureTile(icon: Icons.history, title: 'Calculation History', description: 'Keep track of recent calculations.'),
            FeatureTile(icon: Icons.settings, title: 'Customizable Settings', description: 'Adjust settings to personalize your experience.'),

            // Divider
            Divider(height: 32, thickness: 2),

            // Recent Calculations
            Text(
              'Recent Calculations:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Dummy recent calculations list
            RecentCalculationTile(expression: '5 + 3 * 2', result: '11'),
            RecentCalculationTile(expression: '12 / 4 + 6', result: '9'),
            RecentCalculationTile(expression: '√49 + 8', result: '15'),

            // Settings button
            SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.settings),
                label: Text('Go to Settings'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  FeatureTile({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }
}

class RecentCalculationTile extends StatelessWidget {
  final String expression;
  final String result;

  RecentCalculationTile({required this.expression, required this.result});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.history, color: Colors.green),
      title: Text(expression),
      subtitle: Text('Result: $result'),
    );
  }
}
