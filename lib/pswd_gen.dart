/* a class to generate password from quote and number */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ciphatron/utils.dart';

class PswdGen {
  List<String> _words; // base words to generate the password letters
  List<String> _numbers; // user numbers to insert in the final password
  TextEditingController _quoteController;
  TextEditingController get quoteController => _quoteController;
  TextEditingController _numbersController;
  TextEditingController get numbersController => _numbersController;

  PswdGen() {
    _quoteController = TextEditingController();
    _numbersController = TextEditingController();
  }

  dispose() {
    _quoteController.dispose();
    _numbersController.dispose();
  }

  void _setWords(String quote) {
    _words = getFilteredQuote(quote).split(" ");
    print("words set to: $_words");
  }

  void _setNumbers(String rawNumbers) {
    _numbers = rawNumbers.split("");
    print("numbers set to: $_numbers");
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

  String getCurrentQuote() {
    return _quoteController.text;
  }

  void generate(final BuildContext context) async {
    _setWords(_quoteController.text);
    _setNumbers(_numbersController.text);

    Map lOccurrences = _getFirstLetterOccurrences();
    print(lOccurrences);

    List<String> letterPairs = _getPairs(lOccurrences);
    String pswd = _getCustomPassword(letterPairs);

    // show the generated password with a copy to clipboard button
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(pswd)),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: pswd));
                  Navigator.pop(context); // hide current dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
