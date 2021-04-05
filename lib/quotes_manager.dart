import 'package:ciphatron/utils.dart';
import 'package:flutter/cupertino.dart';

class QuotesMngr with ChangeNotifier {
  List<String> _quotes;
  bool isCurrentFavorite = false;

  QuotesMngr() {
    _quotes = [];
    //TODO: load quotes
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
    notifyListeners();
  }

  void onUserDismiss(int index) {
    _removeAt(index);
    notifyListeners();
  }

  void onUserLoad() {
    isCurrentFavorite = true;
    notifyListeners();
  }
}
