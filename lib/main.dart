import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciphatron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ciphatron'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _words; // base words to generate the password letters
  List<String> _numbers; // user numbers to insert in the final password
  int _minPswdSize = 0;

  void _setWords(String quote) {
    String filteredQuote = quote.replaceAll(RegExp(r"[^\s\w]"), "");
    _words = filteredQuote.toLowerCase().split(" ");
    print("words set to: $_words");
  }

  void _setNumbers(String rawNumbers) {
    _numbers = rawNumbers.split("");
    print("numbers set to: $_numbers");
  }

  void _generate() {
    for (int i = 0; i < _words.length; i++) {
      print(_words[i][0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Accents and punctuation will be filtered. Keep it simple."),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quote',
                ),
                onSubmitted: (String text) {
                  _setWords(text);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numbers',
                ),
                onSubmitted: (String digitText) {
                  _setNumbers(digitText);
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  NumberPicker.integer(
                      initialValue: _minPswdSize,
                      minValue: 0,
                      maxValue: 100,
                      onChanged: (newValue) =>
                          setState(() => _minPswdSize = newValue)),
                  Text("Minimum password size: $_minPswdSize"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _generate();
                },
                child: Text("Generate"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New',
        child: Icon(Icons.fiber_new),
      ),
    );
  }
}
