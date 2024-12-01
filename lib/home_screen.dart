import 'package:advancedcalculator/main.dart';
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
                      'Welcome to OctoCalc!',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF61AFEF), // Light blue for header text
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The advanced calculator for precise and effortless calculations.',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF98C379), // Soft green for subheading text
                        fontFamily: 'sans-serif',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

// Gamification: Achievement Display
                    Text(
                      '🎉 Achievements Unlocked:',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFD19A66), // Light orange for emphasis
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        Chip(
                          label: const Text(
                            'First Calculation 🎯',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xFF282C34), // Dark background for chip
                        ),
                        Chip(
                          label: const Text(
                            'Daily Challenge Completed 🏆',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xFF282C34),
                        ),
                        Chip(
                          label: const Text(
                            'Solved a Complex Equation 🧠',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xFF282C34),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

// Gamification: Daily Challenge
                    Text(
                      '🎯 Daily Challenge: Simplify 3x^2 + 5x - 2 = 0',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFE06C75), // Light red for challenge text
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the challenge mode
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF61AFEF), // Light blue for button
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Solve Now',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 20),

// Gamification: Points System
                    Text(
                      '🌟 Your Points: 1200',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF98C379), // Soft green for points text
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Earn more points by solving challenges and using OctoCalc!',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFABB2BF), // Gray for secondary text
                      ),
                      textAlign: TextAlign.center,
                    ),


                    const SizedBox(height: 20),

// Call to Action: Leaderboard
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to the leaderboard screen
                      },
                      icon: const Icon(
                        Icons.leaderboard,
                        color: Color(0xFF61AFEF), // Light blue icon for VS Code theme
                      ),
                      label: const Text(
                        'View Leaderboard',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text for readability
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF282C34), // Dark gray background for button
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(
                          color: Color(0xFF61AFEF), // Light blue border for emphasis
                          width: 2.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Logout logic
                        final box = Hive.box('credentialsBox');
                        box.put('isLoggedIn', false); // Reset login state
                        box.delete('username'); // Optionally delete username

                        // Clear the navigation stack and navigate to HomeScreen
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false, // Removes all routes from the stack
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
        title: const Text('Welcome to Octocalc'),
        backgroundColor: const Color(0xFF252526),
      ),
      backgroundColor: const Color(0xFF1E1E1E), // Dark theme background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Welcome to Octocalc',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 30),
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
            // Sign In Button
            ElevatedButton(
              onPressed: () async {
                final box = Hive.box('credentialsBox');
                final storedEmail = box.get('email');
                final storedPassword = box.get('password');

                // Check if credentials match
                if (emailController.text == storedEmail &&
                    passwordController.text == storedPassword) {
                  // Save login state and username
                  box.put('isLoggedIn', true);
                  box.put('username', storedEmail); // Store the email as the username

                  // Navigate to the MainScreen and clear navigation stack
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainScreen()),
                        (route) => false, // Clear all previous routes
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Create Account Button
            ElevatedButton(
              onPressed: () {
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
                  borderRadius: BorderRadius.circular(10),
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
            const SizedBox(height: 40),
            // Footer text
            const Text(
              'Your go-to advanced calculator app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontFamily: 'monospace',
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


