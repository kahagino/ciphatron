String getFilteredQuote(String quote) {
  String filteredQuote = quote.replaceAll(RegExp(r"[^\s\w]"), "");
  return filteredQuote.toLowerCase();
}
