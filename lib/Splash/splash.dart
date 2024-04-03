import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../main.dart'; // MyApp sınıfınızın bulunduğu dosyanın yolu

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<String> splashTexts = [
    "Empty Your Mind",
    "Focus Your Feelings",
    "Leave The Rest To Us",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            carouselController: _controller,
            itemCount: splashTexts.length,
            options: CarouselOptions(
              height: 400.0,
              autoPlay: false,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              scrollPhysics: NeverScrollableScrollPhysics(),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }
            ),
            itemBuilder: (context, index, realIndex) {
              return CustomPaint(
                painter: BorderPainter(_animation.value),
                child: Card(
                  elevation: 8.0,
                  color: Color.fromARGB(255, 81, 74, 190).withOpacity(0.1),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        splashTexts[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_currentIndex < splashTexts.length - 1) {
                _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentIndex < splashTexts.length - 1 ? 'Next  ' : 'Are You Ready ?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_currentIndex < splashTexts.length - 1)
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 89, 95, 194),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double progress;
  BorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Start color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    // Use the drawArc method to rotate the gradient around the center
    paint.shader = SweepGradient(
      colors: [Colors.white, Color.fromARGB(255, 70, 21, 150), Colors.white], // Color transition
      startAngle: 0.0,
      endAngle: math.pi * 2,
      transform: GradientRotation(progress),
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create a circular path that represents the border
    var path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
