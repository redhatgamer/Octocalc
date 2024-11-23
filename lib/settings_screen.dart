import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeData) onThemeChanged;

  const SettingsScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _numberFormat = 'Standard';
  int _decimalPlaces = 2;
  Color _selectedColor = Colors.blue;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _numberFormat = prefs.getString('numberFormat') ?? 'Standard';
      _decimalPlaces = prefs.getInt('decimalPlaces') ?? 2;
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _selectedColor = Color(prefs.getInt('themeColor') ?? Colors.blue.value);
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('numberFormat', _numberFormat);
    await prefs.setInt('decimalPlaces', _decimalPlaces);
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setInt('themeColor', _selectedColor.value);

    ThemeData newTheme = ThemeData(
      primaryColor: _selectedColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _selectedColor,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: _selectedColor,
        foregroundColor: Colors.white,
      ),
    );
    widget.onThemeChanged(newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          elevation: 0,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      value: _isDarkMode,
                      onChanged: (bool value) {
                        setState(() {
                          _isDarkMode = value;
                          _saveSettings();
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Theme Color'),
                      trailing: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      onTap: _showColorPicker,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculator Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ListTile(
                      title: Text('Number Format'),
                      trailing: DropdownButton<String>(
                        value: _numberFormat,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _numberFormat = newValue;
                              _saveSettings();
                            });
                          }
                        },
                        items: ['Standard', 'Scientific', 'Engineering']
                            .map((String format) {
                          return DropdownMenuItem(
                            value: format,
                            child: Text(format),
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: Text('Decimal Places'),
                      subtitle: Slider(
                        value: _decimalPlaces.toDouble(),
                        min: 0,
                        max: 8,
                        divisions: 8,
                        label: _decimalPlaces.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _decimalPlaces = value.toInt();
                            _saveSettings();
                          });
                        },
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

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Theme Color'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.purple,
                Colors.orange,
                Colors.teal,
                Colors.pink,
                Colors.indigo,
              ].map((Color color) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                      _saveSettings();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}