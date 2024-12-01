import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

// ThemeNotifier to manage light/dark theme
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double decimalPlaces = 2;
  String numberFormat = 'Engineering';
  Color selectedColor = Colors.purple;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: selectedColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Appearance Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dark Mode'),
                      Switch(
                        value: themeNotifier.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeNotifier.toggleTheme(value);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Theme Color'),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedColor = selectedColor == Colors.purple
                                ? Colors.blue
                                : Colors.purple;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: selectedColor,
                          radius: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Calculator Settings Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculator Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number Format'),
                      DropdownButton<String>(
                        value: numberFormat,
                        items: ['Engineering', 'Scientific', 'Decimal']
                            .map((format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            numberFormat = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Decimal Places'),
                  Slider(
                    value: decimalPlaces,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: decimalPlaces.toString(),
                    onChanged: (value) {
                      setState(() {
                        decimalPlaces = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
