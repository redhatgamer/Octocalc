import 'package:advancedcalculator/calculator_screen.dart';
import 'package:advancedcalculator/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Default selected tab
  final box = Hive.box('credentialsBox');

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = box.get('isLoggedIn', defaultValue: false);
    final String userName = box.get('username', defaultValue: 'User'); // Default username

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // "Menu bar" at the top
            Container(
              color: const Color(0xFF252526),
              height: 40,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                  const Text(
                    "Octocalc - Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            // Main body
            Expanded(
              child: Center(
                child: isLoggedIn
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, $userName!',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Logout logic
                        box.put('isLoggedIn', false); // Reset login state
                        box.delete('username'); // Optionally delete username

                        // Refresh the screen by replacing the current route
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Login Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Create Account Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateAccountScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.person_add, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF252526),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Handle navigation logic based on the selected tab
          if (index == 0) {
            // Home tab (do nothing, already here)
          } else if (index == 1) {
            // Navigate to Calculator Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalculatorScreen()),
            );
          } else if (index == 2) {
            // Navigate to Settings Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()), // Replace with your SettingsScreen class
            );
          }
        },
        selectedItemColor: const Color(0xFF007ACC),
        unselectedItemColor: Colors.white70,
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









class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login or Create Account'),
        backgroundColor: const Color(0xFF252526),
      ),
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF252526), // Dark field background
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            // Password Field
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF252526),
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            // Login Button
            ElevatedButton(
              onPressed: () async {
                final box = Hive.box('credentialsBox');
                final storedEmail = box.get('email');
                final storedPassword = box.get('password');

                if (emailController.text == storedEmail &&
                    passwordController.text == storedPassword) {
                  // Save login state and username
                  box.put('isLoggedIn', true);
                  box.put('username', storedEmail); // Store the email as the username

                  // Navigate to the HomeScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Credentials')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007ACC), // Blue login button
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Create Account Button
            ElevatedButton(
              onPressed: () {
                // Call the create account method from HomeScreen
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Create Account'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final box = Hive.box('credentialsBox');
                          box.put('email', emailController.text);
                          box.put('password', passwordController.text);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account Created Successfully')),
                          );

                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333), // Grey button
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CreateAccountScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final box = Hive.box('credentialsBox');
                box.put('email', emailController.text);
                box.put('password', passwordController.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account Created Successfully')),
                );
                Navigator.pop(context); // Go back to Login
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}


