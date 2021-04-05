import 'package:ciphatron/quotes_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Global {
  QuotesMngr quotesMngr;

  Global() {
    quotesMngr = QuotesMngr();
  }
}

Global global = Global();
