import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:wordle_app/lists.dart';
import 'package:wordle_app/mainScreen.dart'; // Ensure TimerRecordPage is properly implemented and imported.

class WordleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordle Game',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        primarySwatch: Colors.blue,
      ),
      home: WordleHomePage(),
    );
  }
}

class WordleHomePage extends StatefulWidget {
  @override
  _WordleHomePageState createState() => _WordleHomePageState();
}

class _WordleHomePageState extends State<WordleHomePage> {
  final int wordLength = 5;
  final int maxAttempts = 6;
  final List<String> wordList = [
    'apple', 'bless', 'brick', 'brush', 'burst',
    'chess', 'clear', 'cloud', 'cream', 'crane',
    'dance', 'drain', 'fence', 'flame', 'flute',
    'frown', 'grape', 'green', 'grief', 'grasp',
    'habit', 'hello', 'heart', 'judge', 'jumpy',
    'liver', 'limes', 'mango', 'night', 'ocean',
    'pearl', 'piano', 'plaza', 'pouch', 'roast',
    'slate', 'stone', 'swing', 'swear', 'table',
    'tiger', 'vivid', 'water', 'whale', 'watch',
  ];

  late String targetWord;
  List<String> attempts = [];
  String currentGuess = '';
  late Timer _timer;
  int _remainingTime = 300; // Timer duration in seconds (5 minutes)
  bool isGameOver = false;
  String playerName = '';

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      targetWord = wordList[Random().nextInt(wordList.length)];
      attempts = [];
      currentGuess = '';
      isGameOver = false;
      _remainingTime = 300;
      playerName = '';
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !isGameOver) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  void checkGuess() {
    if (currentGuess.length == wordLength) {
      setState(() {
        attempts.add(currentGuess);
        currentGuess = '';
      });
      if (attempts.last == targetWord) {
        _onWin();
      } else if (attempts.length == maxAttempts) {
        _onLose();
      }
    }
  }

  void _onWin() {
    stopTimer();
    setState(() {
      isGameOver = true;
    });
    _showRecordDialog();
  }

  void _onLose() {
    stopTimer();
    setState(() {
      isGameOver = true;
    });
  }

  void _showRecordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You guessed the word correctly. Add your time to the record list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showNameDialog();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _showNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter your name'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                playerName = value;
              });
            },
            decoration: InputDecoration(hintText: 'Enter your name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (playerName.isNotEmpty) {
                  TimerRecord.addRecord(playerName, 300 - _remainingTime);
                }
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TimerRecordPage(),
                ));
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Color getLetterColor(String letter, int index) {
    if (targetWord[index] == letter) {
      return Colors.green;
    } else if (targetWord.contains(letter)) {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wordle Game', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TimerRecordPage()));
          },
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'List of Words',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: wordList.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    color: Colors.blue.shade100,
                    child: Text(wordList[index], style: TextStyle(fontSize: 16)),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Restart Game'),
              onTap: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timer Display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Time Left: ${_remainingTime ~/ 60}:${_remainingTime % 60}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Attempts Grid
            for (var i = 0; i < maxAttempts; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  wordLength,
                      (index) => Container(
                    margin: EdgeInsets.all(4),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: i < attempts.length ? getLetterColor(attempts[i][index], index) : Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        i < attempts.length ? attempts[i][index].toUpperCase() : '',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            // Input Section
            if (attempts.length < maxAttempts && !isGameOver)
              Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: TextField(
                        maxLength: wordLength,
                        onChanged: (value) {
                          if (value.length <= wordLength) {
                            setState(() {
                              currentGuess = value.toLowerCase();
                            });
                          }
                        },
                        onSubmitted: (value) => checkGuess(),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter your guess',
                          counterText: '',
                          filled: true, // Enable fill color
                          fillColor: Colors.blue.shade100, // Set fill color to a light blue
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (currentGuess.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter a valid guess!')),
                        );
                      } else {
                        checkGuess();
                      }
                    },
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, // Set background color to blue
                      foregroundColor: Colors.white, // Set text color to white
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
            // Game Over/Win Display
            if (isGameOver)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      attempts.last == targetWord ? 'You Win! 🎉' : 'Game Over! The word was $targetWord.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: resetGame,
                    child: Text('Restart Game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}