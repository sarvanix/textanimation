import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;
  bool _isVisible = true;
  bool _showFrame = false;
  Color _textColor = Colors.black;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleFade() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pick a Text Color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _textColor,
            onColorChanged: (color) {
              setState(() {
                _textColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text("Done"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Animation App"),
        actions: [
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: pickColor,
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
        color: isDarkMode ? Colors.black87 : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: _showFrame
                      ? BoxDecoration(
                          border: Border.all(color: _textColor, width: 3),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : null,
                  child: Text(
                    "Hello, Flutter! 🌞🌙",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: toggleFade,
                child: Text("Fade In/Out"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Show Frame"),
                  Switch(
                    value: _showFrame,
                    onChanged: (value) {
                      setState(() {
                        _showFrame = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Swipe Left ➡️ for Next Animation"),
            ],
          ),
        ),
      ),
    );
  }
}
