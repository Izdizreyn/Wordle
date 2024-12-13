import 'package:flutter/material.dart';

class TimerRecord {
  static List<Map<String, dynamic>> records = [];

  static void addRecord(String playerName, int timeInSeconds) {
    records.add({
      'name': playerName,
      'time': timeInSeconds,
    });
  }

  static List<Map<String, dynamic>> getRecords() {
    return records;
  }

  static void deleteRecord(int index) {
    records.removeAt(index);
  }
}

class TimerRecordPage extends StatefulWidget {
  @override
  _TimerRecordPageState createState() => _TimerRecordPageState();
}

class _TimerRecordPageState extends State<TimerRecordPage> {
  @override
  Widget build(BuildContext context) {
    final records = TimerRecord.getRecords();

    return Scaffold(
      appBar: AppBar(
        title: Text('Timer Records'),
        backgroundColor: Colors.blue, // Set AppBar color to blue
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Pops the current page off the navigation stack
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Swipe from left to right to delete.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white], // Add gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Dismissible(
              key: Key(record['name']),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                TimerRecord.deleteRecord(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Record deleted')),
                );
              },
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  title: Text(record['name']),
                  subtitle: Text('Time: ${record['time'] ~/ 60}:${record['time'] % 60}'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}