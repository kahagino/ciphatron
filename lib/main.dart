import 'package:flutter/cupertino.dart';
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

  void _generate() async {
    _setWords(_quoteController.text);
    _setNumbers(_numbersController.text);

    Map lOccurrences = _getFirstLetterOccurrences();
    print(lOccurrences);

    List<String> letterPairs = _getPairs(lOccurrences);
    String pswd = _getCustomPassword(letterPairs);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pswd),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: pswd));
                  Navigator.pop(context); // hide current dialog
                },
              )
            ],
          ),
        );
      },
    );
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

  List<String> _getPairs(Map occurrences) {
    List<String> pairs = [];
    occurrences.forEach((letter, nbOccurrences) {
      if (nbOccurrences >= 2) pairs.add(letter);
    });

    return pairs;
  }

  String _getCustomPassword(List<String> letterPairs) {
    String pswd = "";
    int insertNumber = 0;
    bool nextIsUpper = false; // first letter is lower case
    for (int i = 0; i < _words.length; i++) {
      String letter = _words[i][0];
      pswd += nextIsUpper ? letter.toUpperCase() : letter;
      nextIsUpper = false;
      if (letterPairs.contains(letter) && insertNumber < _numbers.length) {
        pswd += _numbers[insertNumber];
        insertNumber++;
        nextIsUpper = true;
      }
    }

    return pswd;
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
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Enter your favorite quote and number"),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                minLines: 1,
                maxLines: 4,
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
                  labelText: 'Number',
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
              ElevatedButton(
                onPressed: () {
                  _generate();
                },
                child: Text("Generate password"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: restart with fresh ui
        },
        tooltip: 'New',
        child: Icon(Icons.fiber_new),
      ),
    );
  }
}
