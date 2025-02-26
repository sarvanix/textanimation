import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}
//sharuuu
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
  bool _isVisible = true;
  bool _showFrame = false;
  bool _isImageVisible = false;
  bool _isRotating = false;
  Color _textColor = Colors.black;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isImageVisible = true; // Image fades in after half a second
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleFade() {
    controller.forward().then(() {
      _controller.reverse();
      setState(() {
        _isVisible = !_isVisible;
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
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
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
              GestureDetector(
                onTap: toggleRotation,
                child: AnimatedOpacity(
                  opacity: _isImageVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  child: RotationTransition(
                    turns: _controller,
                    child: Image.network(
                      "https://flutter.dev/assets/homepage/carousel/slide_1-bg-4552f8db7f17aa90d36bc2a5b07695bbd79c4e07a28fcd9a17ed8b7bffb19763.jpg",
                      width: 200,
                      height: 150,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                    "Hello, Flutter! 🎭✨",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _textColor),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: toggleFade,
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
              Text("Swipe Left ➡ for Next Animation"),
            ],
          ),
        ),
      ),
    );
  }
}