import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController _quoteController;
  TextEditingController _numbersController;

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
    _setWords(_quoteController.text);
    _setNumbers(_numbersController.text);

    Map lOccurrences = _getFirstLetterOccurrences();
    print(lOccurrences);

    for (int i = 0; i < _words.length; i++) {
      print(_words[i][0]);
    }

    matchNumbersLength(lOccurrences);
  }

  Map _getFirstLetterOccurrences() {
    Map occurrences = Map();

    _words.forEach((word) {
      if (!occurrences.containsKey(word[0])) {
        occurrences[word[0]] = 1;
      } else {
        occurrences[word[0]] += 1;
      }
    });

    return occurrences;
  }

  bool matchNumbersLength(Map occurrences) {
    int nbPairs = 0;
    // TODO: check if possible to insert numbers if more than two occurrences
    occurrences.forEach((letter, nbOccurrences) {
      if (nbOccurrences > 2) print("d");
    });
  }

  void initState() {
    super.initState();
    _quoteController = TextEditingController();
    _numbersController = TextEditingController();
  }

  void dispose() {
    _quoteController.dispose();
    _numbersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_quoteController.text),
              Text("Accents and punctuation will be filtered. Keep it simple."),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _quoteController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quote',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _numbersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numbers',
                ),
                maxLength: 4,
                maxLengthEnforced: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                onSubmitted: (String digitText) {
                  _setNumbers(digitText);
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Minimum password size: $_minPswdSize"),
                  NumberPicker.integer(
                      infiniteLoop: true,
                      initialValue: _minPswdSize,
                      minValue: 0,
                      maxValue: 20,
                      onChanged: (newValue) =>
                          setState(() => _minPswdSize = newValue)),
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
