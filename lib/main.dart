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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isDarkMode = false;
  bool _isTextVisible = true;
  bool _showFrame = false;
  bool _isRotating = false;
  Color _textColor = Colors.black;
  late AnimationController _rotationController;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    // Rotation controller for the image
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Bounce effect for button
    _buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.1,
    );

    _buttonScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleTextFade() {
    _buttonController.forward().then((_) {
      _buttonController.reverse();
      setState(() {
        _isTextVisible = !_isTextVisible;
      });
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

  void toggleRotation() {
    setState(() {
      _isRotating = !_isRotating;
      if (_isRotating) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Animation App"),
        actions: [
          IconButton(icon: Icon(Icons.palette), onPressed: pickColor),
          IconButton(icon: Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny), onPressed: toggleTheme),
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
              GestureDetector(
                onTap: toggleRotation,
                child: RotationTransition(
                  turns: _rotationController,
                  child: Image.network(
                    "https://flutter.dev/assets/homepage/carousel/slide_1-bg-4552f8db7f17aa90d36bc2a5b07695bbd79c4e07a28fcd9a17ed8b7bffb19763.jpg",
                    width: 200,
                    height: 150,
                  ),
                ),
              ),
              SizedBox(height: 20),
              AnimatedOpacity(
                opacity: _isTextVisible ? 1.0 : 0.0,
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
                    "Hello, Flutter! 🚀✨",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ScaleTransition(
                scale: _buttonScale,
                child: ElevatedButton(
                  onPressed: toggleTextFade,
                  child: Text("Bounce & Fade In/Out"),
                ),
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
              Text("Tap Image to Rotate! ⬆️"),
            ],
          ),
        ),
      ),
    );
  }
}
