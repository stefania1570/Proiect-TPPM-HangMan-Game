// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:math'; // pt random

void main() {
  runApp(HangmanGame());
}

class HangmanGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HangmanBody(),
      ),
    );
  }
}

class HangmanBody extends StatefulWidget {
  @override
  _HangmanBodyState createState() => _HangmanBodyState();
}

List<String> _wordList = [
      'exemplu','căutare','program','metodă','funcție','variabilă','bibliotecă','dezvoltare','compilator','executabil','iterație','concatenare','caracter',
      'șiruri','eficient','performanță','optimizare','arhitectură','aplicație','resursă','interfață','conversie','operator','operand','argument',
      'abstract','implementare','clasă','obiect','încapsulare','polimorfism','dezvoltator','blocuri',
      'componentă','autentificare','autorizare','configurare','instalare','validare','accesibilitate','structură','comparare','dezambiguizare',
      'dependență','declarație','programare','programator',
      'soluție','rezoluție','prototip','opțiune','factor','operațional','lucrare',
      'ciclomatic','recursivitate','eficiență','coerență','metodologie','tehnologie','instanță','compilare','semantica','instrucțiune','comentarii',
      'definiție','instanțiere','asociere','configurabil','restructurare','platformă','algoritm','analiză','interoperabilitate','documentație',
      'integrare','scalabilitate','fiabilitate','extensibilitate','compatibilitate','inspecție','redeschide','dezvăluie','limitat','orizontal',
      'sacrificare','credibilitate',
      'răspândire','vulnerabil','colaborare','amplificator','sistem','retragere','plăcut','responsabil','promovare','periculos','operațiune','cerere',
      'denumire','periclitat','adaptabil','complicație','declinare','precedent','deținut','atmosferă','emancipare','provocare','luminat','documentare',
      'detalii','consultant','agresor','consolidat','gratuit','designer','coordonator','conceput','producție'
    ];

class _HangmanBodyState extends State<HangmanBody> {
  bool gameStarted = false;
  double ycoord = 0.0;
  String selectedLetter = '';
  List<String> pressedLetters =[]; // lista unde punem literele pe care a apasat utilizatorul
  String hangmanWord = '';
  String loseMessage = '';
  String displayedWord = ''; // cuvantul ascuns prin "_"
  int lives = 6; // nr vieti = cate parti ale corpului putem desena pana pierdem
  List<String> romanianAlphabet = [
    'A','Ă','Â','B','C','D','E','F','G','H','I','Î','J','K','L','M','N','O','P','Q','R','S','Ș','T','Ț','U','V','W','X','Y','Z','-'
  ];

  @override
  void initState() {
    super.initState();
  }

  String getRandomWord() {
    final random = Random();
    var randomWord = _wordList[random.nextInt(_wordList.length)];
    print(randomWord);
    return randomWord;
  }

  void checkWinner() {
    // daca jucatorul mai are de ghicit litere din cuvant = inca avem "_"
    if (!displayedWord.contains('_')) {
      // daca nu mai avem underline in cuvant => a castigat si afisam fereastra pop up
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('CONGRATULATIONS!'),
          content: Text('You guessed the word.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      );
    }
    // daca nu mai are vieti inseamna ca a pierdut
    else if (lives == 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('YOU LOSE!'),
          content: Text(loseMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                resetGame();
              },
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }
  }

  void resetGame() {
    // reseteaza variabilele cand dai pe try again
    setState(() {
      ycoord = 0.0;
      selectedLetter = '';
      pressedLetters.clear();
      displayedWord = '';
      lives = 6;
      hangmanWord = '';
      displayedWord = '';
      gameStarted = false;
    });
  }

 // construim displayedWord dupa ghicirea unor litere

  String replaceCharacters(String hangmanWord, List<String> pressedLetters) {
  String result = '';
  for (int i = 0; i < hangmanWord.length; i++) {
    String currentLetter = hangmanWord[i]; //luam fiecare litera din hangmanWord
    if (pressedLetters.contains(currentLetter)) {// daca litera e apasata, o pastram
      result += currentLetter; 
    } else { // daca litera nu a fost apasata, se va inlocui cu "_"
      result += '_'; 
    }
  }
  return result;
}


  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: _SliverAppBarDelegate(
            expandedHeight: gameStarted ? 100.0 : 300.0,
            title: 'HangMan Game',
          ),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: CustomPaint(
                    size: Size(200, 200),
                    painter: HangmanPainter(
                      gameStarted: gameStarted,
                      y: ycoord,
                      lives: lives,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              if (gameStarted) // afiseaza cuvantul cu "_" doar daca jocul a inceput (adica s-a dat click pe start game)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < hangmanWord.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          displayedWord[i], //afisez "_" litera cu litera prin for ul de mai sus: cate caractere are cuv de ghicit atatea _ avem
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 20),
              gameStarted 
                  ? GridView.count(
                      crossAxisCount: 6,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(6),
                      children: List.generate(romanianAlphabet.length, (index) {
                        String letter = romanianAlphabet[index];
                        bool isPressed = pressedLetters.contains(letter);
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPressed ? Colors.grey : null,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedLetter = letter;
                                if (!pressedLetters.contains(letter)) {
                                  pressedLetters.add(letter); 
                                  if (!hangmanWord.contains(letter)) {
                                    //daca litera nu se gaseste in cuv de ghicit, scade o viata
                                    lives--;
                                  }
                                  displayedWord = replaceCharacters(hangmanWord, pressedLetters);//prin asta apar literele pe ecran pe masura ce le ghicesti
                                  checkWinner();
                                }
                              });
                            },
                            child: Text(letter, textAlign: TextAlign.center),
                          ),
                        );
                      }),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          gameStarted = true;
                          ycoord = 0.9;
                          hangmanWord = getRandomWord().toUpperCase();
                          displayedWord = '_' * hangmanWord.length; 
                          print(displayedWord);
                          loseMessage = 'The word was: $hangmanWord';
                        });
                      },
                      child: Text('START'),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class HangmanPainter extends CustomPainter {
  bool gameStarted;
  double y;
  int lives;

  HangmanPainter(
      {required this.gameStarted, required this.y, required this.lives});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Linia orizontala initiala
    canvas.drawLine(Offset(20, 130 - y), Offset(180, 130 - y), paint);

    // Linia verticala in sus
    canvas.drawLine(Offset(100, 130 - y), Offset(100, 20 - y), paint);

    // Linia orizontala de sus
    canvas.drawLine(Offset(100, 20 - y), Offset(150, 20 - y), paint);

    // Linia verticala de care atarna corpul
    canvas.drawLine(Offset(150, 20 - y), Offset(150, 30 - y), paint);

    //PENTRU DESENATUL CORPULUI:
    if (lives < 6) {
      // Cercul pentru cap
      canvas.drawCircle(Offset(150, 40), 10, paint);

      if (lives < 5) {
        // Linia verticala pentru corp in jos
        canvas.drawLine(Offset(150, 50), Offset(150, 80), paint);

        if (lives < 4) {
          // Linia oblica spre stanga (mana1)
          canvas.drawLine(Offset(150, 60), Offset(140, 70), paint);

          if (lives < 3) {
            // Linia oblica spre dreapta (mana2)
            canvas.drawLine(Offset(150, 60), Offset(160, 70), paint);

            if (lives < 2) {
              // Linia oblica spre stanga 2 (picior1)
              canvas.drawLine(Offset(150, 80), Offset(140, 90), paint);

              if (lives < 1) {
                // Linia oblica spre dreapta 2 (picior2)
                canvas.drawLine(Offset(150, 80), Offset(160, 90), paint);
              }
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return gameStarted;
  }
}

//pt appbar ca sa se micsoreze cand dau pe start ca si cum am da scroll
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String title;

  _SliverAppBarDelegate({required this.expandedHeight, required this.title});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: expandedHeight - shrinkOffset,
      child: AppBar(
        title: Text(title),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/peakpx.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        title != oldDelegate.title;
  }
}
