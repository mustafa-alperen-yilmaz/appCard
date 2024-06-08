import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'Splash/splash.dart'; 
//import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
          color: const Color.fromARGB(245, 245, 245, 1000), // Arka plan rengi
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), // Üst sol köşe yuvarlatma
            topRight: Radius.circular(20.0), // Üst sağ köşe yuvarlatma
          ),
        ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Gölge rengi
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Gölgenin yerleşimi
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/flags/turkey.jpg'),
                    radius: 12, // Yarıçapı 12 olarak ayarla
                  ),
                ),
                title: Text('Türkçe'),
                onTap: () {
                  _changeLanguage('tr');
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Gölge rengi
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Gölgenin yerleşimi
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/flags/england.jpg'),
                    radius: 12, // Yarıçapı 12 olarak ayarla
                  ),
                ),
                title: Text('English'),
                onTap: () {
                  _changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Gölge rengi
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Gölgenin yerleşimi
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/flags/russian.jpg'),
                    radius: 12, // Yarıçapı 12 olarak ayarla
                  ),
                ),
                title: Text('Русский'),
                onTap: () {
                  _changeLanguage('ru');
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Gölge rengi
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Gölgenin yerleşimi
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/flags/espanol.jpg'),
                    radius: 12, // Yarıçapı 12 olarak ayarla
                  ),
                ),
                title: Text('Español'),
                onTap: () {
                  _changeLanguage('esp');
                  Navigator.pop(context);
                },
              ),
            ),
          ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0), // Üst kısmı yuvarlat
      ),
    ),
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
