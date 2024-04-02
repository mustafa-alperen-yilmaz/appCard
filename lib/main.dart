import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'Splash/splash.dart'; 

void main() {
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
  final languageData = dataMap['büyük_languages'] as List<dynamic>;

  // Rastgele bir cümle seç
  final randomIndex = Random().nextInt(languageData.length);
  final selectedSentence = languageData[randomIndex];
  currentSentenceId = selectedSentence['id'];

  final currentSentence = languageData.firstWhere(
    (sentence) => sentence['id'] == currentSentenceId,
    orElse: () => languageData.first,
  );

  setState(() {
    randomSentence = currentSentence['quotes'][selectedLanguage];
    isBack = true; // Kartı her yüklemede arka yüze çevir
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
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                backgroundImage: AssetImage('assets/flags/turkey.jpg'),
                radius: 12, // Yarıçapı 12 olarak ayarla
                  ),
                title: Text('Türkçe'),
                onTap: () {
                  _changeLanguage('tr');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  _changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Русский'),
                onTap: () {
                  _changeLanguage('ru');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Español'),
                onTap: () {
                  _changeLanguage('esp');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeLanguage(String language) {
  if (selectedLanguage != language) {
    setState(() {
      selectedLanguage = language;
      languageChanged = true;
    });
    // Sadece metni güncelle, yeni bir rastgele cümle seçme
    updateSentenceForCurrentLanguage();
  }
}
Future<void> updateSentenceForCurrentLanguage() async {
  if (currentSentenceId == null) return; // Güvenlik kontrolü

  final jsonString = await rootBundle.loadString('assets/data.json');
  final dataMap = jsonDecode(jsonString) as Map<String, dynamic>;
  final languageData = dataMap['büyük_languages'] as List<dynamic>;

  final currentSentence = languageData.firstWhere(
    (sentence) => sentence['id'] == currentSentenceId,
    orElse: () => null,
  );

  if (currentSentence != null) {
    setState(() {
      randomSentence = currentSentence['quotes'][selectedLanguage];
      // Eğer dil değişikliği yapıldıysa ve cümle güncelleniyorsa, kartın ön yüzünü göster.
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
                    if (val >= (pi / 2)) {
                      isBack = false;
                    } else {
                      isBack = true;
                    }
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(val),
                      child: Container(
                        width: 309,
                        height: 474,
                        child: isBack
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: AssetImage("assets/back.png"),
                                  ),
                                ),
                              )
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: AssetImage("assets/face.png"),
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8.0), // Sağdan ve soldan 8.0 birim margin ekler
                                      child: Text(
                                        randomSentence,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              )
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
}
