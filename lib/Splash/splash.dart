import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../main.dart'; 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController(); 

  List<String> splashTexts = [
    "Empty Your Mind",
    "Focus Your Feelings",
    "Leave The Rest To Us",
  ];

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
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
            itemBuilder: (context, index, realIndex) {
              return Container(
                child: Center(
                  child: Text(
                    splashTexts[index],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
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
            child: Text(
              _currentIndex < splashTexts.length - 1 ? 'Next' : 'Are you ready?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 89, 95, 194),
            ),
          ),
        ],
      ),
    );
  }
}
