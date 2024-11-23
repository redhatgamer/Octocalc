import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

void main() {
  runApp(AdvancedCalculatorApp());
}

// Changed from StatelessWidget to StatefulWidget to support theme changes
class AdvancedCalculatorApp extends StatefulWidget {
  @override
  _AdvancedCalculatorAppState createState() => _AdvancedCalculatorAppState();
}

class _AdvancedCalculatorAppState extends State<AdvancedCalculatorApp> {
  ThemeData _theme = ThemeData(
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  void _updateTheme(ThemeData newTheme) {
    setState(() {
      _theme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Calculator',
      theme: _theme,
      home: MainScreen(onThemeChanged: _updateTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(ThemeData) onThemeChanged;

  const MainScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(),
      CalculatorScreen(),
      SettingsScreen(onThemeChanged: widget.onThemeChanged),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
