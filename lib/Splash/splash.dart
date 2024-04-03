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
                enableInfiniteScroll: false,
                scrollPhysics: NeverScrollableScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
            itemBuilder: (context, index, realIndex) {
              return Card(
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
                  _currentIndex < splashTexts.length - 1 ? 'Next  ' : 'Are you ready?',
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
