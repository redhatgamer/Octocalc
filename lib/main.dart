import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'calculator_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('credentialsBox'); // Open a box for storing credentials
  runApp(AdvancedCalculatorApp());
}

class AdvancedCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('credentialsBox');
    final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false); // Correctly get boolean

    return MaterialApp(
      title: 'Advanced Calculator',
      theme: ThemeData(
        // Background colors for dark theme
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Dark grey background
        primaryColor: const Color(0xFF007ACC), // VS Code blue
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF007ACC), // Blue accents
          secondary: const Color(0xFF444444), // Grey accents
        ),
        cardColor: const Color(0xFF252526), // Darker grey for cards or sections
        dividerColor: const Color(0xFF444444), // Grey divider

        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF333333), // Button background
            foregroundColor: Colors.white, // Button text/icon color
            textStyle: const TextStyle(
              fontFamily: 'monospace', // Monospace font for IDE look
            ),
          ),
        ),

        // Text themes
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'monospace',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Title color
          ),
          bodyLarge: TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            color: Colors.white70, // Subtle text color
          ),
          bodyMedium: TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
            color: Colors.white70,
          ),
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF252526), // IDE-like app bar
          titleTextStyle: TextStyle(
            fontFamily: 'monospace',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Input decoration (TextField)
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF252526), // Dark input background
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF444444)), // Border color
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF007ACC)), // Blue border when focused
          ),
          labelStyle: TextStyle(
            color: Colors.white70, // Text color for labels
            fontFamily: 'monospace',
          ),
        ),

        // Bottom navigation bar theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF252526), // Dark bar background
          selectedItemColor: Color(0xFF007ACC), // Blue for selected item
          unselectedItemColor: Colors.white70, // Subtle white for unselected items
        ),
      ),

      // Navigate to HomeScreen if not logged in, MainScreen if logged in
      home: isLoggedIn ? HomeScreen() : LoginScreen(),
    );

  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    CalculatorScreen(),
    SettingsScreen(),
  ];

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
        items: const [
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
