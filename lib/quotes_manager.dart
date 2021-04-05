import 'package:ciphatron/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class QuotesMngr with ChangeNotifier {
  List<String> _quotes;
  bool isCurrentFavorite = false;
  String fileName = "quotes.txt";

  QuotesMngr() {
    _quotes = [];
    readQuotes().then((List<String> value) {
      print("Quotes read:");
      print(value);
      _quotes = value;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> writeQuotes() async {
    final file = await _localFile;
    String allQuotes = "";
    for (int i = 0; i < _quotes.length; i++) {
      if (_quotes[i] != "") allQuotes += _quotes[i];
      // write /n only between quotes
      if (i < _quotes.length - 1) allQuotes += "\n";
    }
    // Write the file.
    return file.writeAsString(allQuotes);
  }

  Future<List<String>> readQuotes() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();
      List<String> quotesList = contents.split("\n");
      for (int i = 0; i < quotesList.length; i++) {
        if (quotesList[i] == "") quotesList.removeAt(i);
      }
      return quotesList;
    } catch (e) {
      // If encountering an error, return 0.
      return ["An error occured while reading file"];
    }
  }

  void _add(String newQuote) {
    _quotes.add(getFilteredQuote(newQuote));
    isCurrentFavorite = true;
  }

  void _removeAt(int index) {
    _quotes.removeAt(index);
    isCurrentFavorite = false;
  }

  int size() {
    return _quotes.length;
  }

  String get(int index) {
    return _quotes[index];
  }

  void onCurrentQuoteChanged(String newQuote) {
    isCurrentFavorite = _quotes.contains(getFilteredQuote(newQuote));
    notifyListeners();
  }

  void onFavoriteClicked(String quote) {
    if (_quotes.contains(getFilteredQuote(quote))) {
      _removeAt(_quotes.indexOf(quote));
    } else {
      _add(quote);
    }
    writeQuotes();
    notifyListeners();
  }

  void onUserDismiss(int index) {
    _removeAt(index);
    writeQuotes();
    notifyListeners();
  }

  void onUserLoad() {
    isCurrentFavorite = true;
    notifyListeners();
  }

  bool isEmpty() {
    return (_quotes.length == 0) ? true : false;
  }
}
