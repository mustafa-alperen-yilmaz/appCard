import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../main.dart'; // Ana sayfanızın olduğu dosyaya doğru path'i kullanın

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController(); // CarouselController eklendi

  List<String> splashTexts = [
    "A",
    "B",
    "C", // Carousel içinde gösterilecek metinler
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e), // Arka plan rengini ayarlar
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            carouselController: _controller, // CarouselController buraya atanıyor
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
                      color: Colors.white, // Yazı rengini ayarlar
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20), // Buton ile Carousel arasında boşluk bırakır
          ElevatedButton(
            onPressed: () {
              if (_currentIndex < splashTexts.length - 1) {
                _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
              } else {
                // Carousel'in son sayfasındaysa, ana sayfaya git
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              }
            },
            child: Text(
              _currentIndex < splashTexts.length - 1 ? 'Next' : 'Are you ready?',
              style: TextStyle(
                color: Colors.white, // Buton metni rengi, buton stilinde ayarlanmalıdır.
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF292a3e), // Butonun arka plan rengi
            ),
          ),
        ],
      ),
    );
  }
}
