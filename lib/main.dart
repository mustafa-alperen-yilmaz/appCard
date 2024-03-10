import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  String randomSentence = '';
  String selectedLanguage = window.locale.languageCode.toLowerCase();
  String newLanguage = '';
  String currentRandomSentence = '';
  bool languageChanged = false;
  String currentLanguage = '';
  List<dynamic> languages = [];
  
  @override
  void initState() {
    super.initState();
    currentLanguage = selectedLanguage;
    loadRandomSentence();
  }

 Future<void> loadRandomSentence() async {
  final jsonString = await rootBundle.loadString('assets/data.json');
  final dataMap = jsonDecode(jsonString) as Map<String, dynamic>;
  final languageData = dataMap['büyük_languages'] as List<dynamic>;

  // Find the language with the same 'id' as the current randomLanguage
  final currentId = languageData.firstWhere(
    (element) => element[currentLanguage] == currentRandomSentence,
    orElse: () => null,
  )?['id'];

  // Shuffle the list
  languageData.shuffle();

  // Find a language with the same 'id' as the current randomLanguage after shuffling
  final randomLanguage = (currentId != null)
      ? languageData.firstWhere(
          (element) => element['id'] == currentId,
          orElse: () => languageData.first,
        )
      : languageData.first;

  setState(() {
    randomSentence = randomLanguage[currentLanguage];
    currentRandomSentence = randomSentence;
  });
}


  void _flip() async {
  setState(() {
    angle = (angle + pi) % (2 * pi);
    if (isBack == true && languageChanged){
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
                title: Text('Turkish'),
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
            ],
          ),
        );
      },
    );
  }
  void _changeLanguage(String language) {
  setState(() {
    if (selectedLanguage != language) {
      // Check if the language is different
      selectedLanguage = language;
      languageChanged = true;
      currentLanguage = language;
    }
  });

  loadRandomSentence();
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
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(val),
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
                                transform: Matrix4.identity()
                                  ..rotateY(pi),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: AssetImage("assets/face.png"),
                                    ),
                                  ),
                                  child: Center(
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