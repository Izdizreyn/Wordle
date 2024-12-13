import 'package:flutter/material.dart';
import 'package:wordle_app/game.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreenHome(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueAccent,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreenHome extends StatefulWidget {
  @override
  State<MainScreenHome> createState() => _MainScreenHomeState();
}

class _MainScreenHomeState extends State<MainScreenHome> {
  bool _isLoading = false;

  void _startAction() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => WordleGame(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Text(
              'Wordle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 70,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 35),
            CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 115,
                backgroundImage: AssetImage('assets/images/ic_launcher.png'),
              ),
            ),
            const SizedBox(height: 50),
            _isLoading
                ? CircularProgressIndicator(
                    color: const Color(0xFFAACCFF),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAACCFF),
                      ),
                      onPressed: _startAction,
                      child: Text(
                        'Start',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
