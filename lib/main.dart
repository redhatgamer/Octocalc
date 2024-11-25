import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'calculator_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';

void main() async {
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('credentialsBox'); // Open a box for storing credentials
  await dotenv.load(fileName: ".env"); // Default is ".env"
  runApp(AdvancedCalculatorApp());
}

class AdvancedCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('credentialsBox');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box box, _) {
        final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);

        return MaterialApp(
          title: 'Advanced Calculator',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFF1E1E1E),
            primaryColor: const Color(0xFF007ACC),
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF007ACC),
              secondary: const Color(0xFF444444),
            ),
            cardColor: const Color(0xFF252526),
            dividerColor: const Color(0xFF444444),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                fontFamily: 'monospace',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              bodyLarge: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                color: Colors.white70,
              ),
              bodyMedium: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF252526),
              titleTextStyle: TextStyle(
                fontFamily: 'monospace',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color(0xFF252526),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF444444)),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF007ACC)),
              ),
              labelStyle: TextStyle(
                color: Colors.white70,
                fontFamily: 'monospace',
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF252526),
              selectedItemColor: Color(0xFF007ACC),
              unselectedItemColor: Colors.white70,
            ),
          ),
          home: isLoggedIn ? MainScreen() : HomeScreen(),
        );
      },
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
    SearchScreen(),
    CalculatorScreen(),
    SettingsScreen(),
  ];

  void logout(BuildContext context) {
    final box = Hive.box('credentialsBox');
    box.put('isLoggedIn', false); // Update Hive state
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
    ); // Navigate to HomeScreen and clear stack
  }



  @override
  void initState() {
    super.initState();
    _currentIndex = 0; // Reset index when MainScreen is recreated
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
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
