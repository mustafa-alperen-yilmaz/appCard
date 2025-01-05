import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'Splash/splash.dart'; 
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Ads/ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isBack = true;
  double angle = 0;
  int? currentSentenceId;
  String randomSentence = '';
  String selectedLanguage = window.locale.languageCode.toLowerCase();
  bool languageChanged = false;

  @override
  void initState() {
    super.initState();
    loadRandomSentence();
  }

  Future<void> loadRandomSentence() async {
    final jsonString = await rootBundle.loadString('assets/data.json');
    final dataMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final languageData = dataMap['big_languages'] as List<dynamic>;

    final randomIndex = Random().nextInt(languageData.length);
    final selectedSentence = languageData[randomIndex];
    currentSentenceId = selectedSentence['id'];

    final currentSentence = languageData.firstWhere(
      (sentence) => sentence['id'] == currentSentenceId,
      orElse: () => languageData.first,
    );

    setState(() {
      randomSentence = currentSentence['quotes'][selectedLanguage];
      isBack = true;
    });
  }

  void _flip() async {
    setState(() {
      angle = (angle + pi) % (2 * pi);
      if (isBack == true){
        loadRandomSentence();
      }
    });
  }

  void _showLanguageMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(245, 245, 245, 1000),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _languageTile('assets/flags/turkey.jpg', 'Türkçe', 'tr'),
              _languageTile('assets/flags/england.jpg', 'English', 'en'),
              _languageTile('assets/flags/russian.jpg', 'Русский', 'ru'),
              _languageTile('assets/flags/espanol.jpg', 'Español', 'esp'),
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
    );
  }

  Widget _languageTile(String imagePath, String languageName, String languageCode) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 12,
        ),
        title: Text(languageName),
        onTap: () {
          _changeLanguage(languageCode);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _changeLanguage(String language) {
    if (selectedLanguage != language) {
      setState(() {
        selectedLanguage = language;
        languageChanged = true;
      });
      updateSentenceForCurrentLanguage();
    }
  }

  Future<void> updateSentenceForCurrentLanguage() async {
    if (currentSentenceId == null) return;

    final jsonString = await rootBundle.loadString('assets/data.json');
    final dataMap = jsonDecode(jsonString) as Map<String, dynamic>;
    final languageData = dataMap['big_languages'] as List<dynamic>;

    final currentSentence = languageData.firstWhere(
      (sentence) => sentence['id'] == currentSentenceId,
      orElse: () => null,
    );

    if (currentSentence != null) {
      setState(() {
        randomSentence = currentSentence['quotes'][selectedLanguage];
        isBack = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF292a3e),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _flip,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: angle),
                  duration: Duration(seconds: 1),
                  builder: (BuildContext context, double val, __) {
                    isBack = val < (pi / 2);
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(val),
                      child: Container(
                        width: 309,
                        height: 474,
                        child: isBack
                            ? _buildCard('assets/back.png')
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: _buildCard('assets/face.png', child: Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      randomSentence,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              AdWidgetContainer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showLanguageMenu,
        child: Icon(Icons.language),
      ),
    );
  }

  Widget _buildCard(String imagePath, {Widget? child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
        ),
      ),
      child: child ?? SizedBox.shrink(),
    );
  }
}
