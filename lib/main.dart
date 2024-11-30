import 'package:flutter/material.dart';
import 'calculator_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(AdvancedCalculatorApp());
}

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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
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
      SettingsScreen(),
    ];
  }

  Future<void> _handleCameraButtonPress() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing gallery')),
      );
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) { // Camera button index
      _handleCameraButtonPress();
    } else {
      setState(() {
        _currentIndex = index < 2 ? index : index - 1; // Adjust index for camera button
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex < 2 ? _currentIndex : _currentIndex + 1,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
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
