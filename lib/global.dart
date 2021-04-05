import 'package:ciphatron/quotes_manager.dart';

class Global {
  QuotesMngr quotesMngr;

  Global() {
    quotesMngr = QuotesMngr();
  }
}

Global global = Global();
