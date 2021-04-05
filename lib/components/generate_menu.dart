import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ciphatron/global.dart';
import 'package:ciphatron/pswd_gen.dart';

class GenerateMenu extends StatefulWidget {
  const GenerateMenu({
    Key key,
    @required this.pGen,
  }) : super(key: key);

  final PswdGen pGen;

  @override
  _GenerateMenuState createState() => _GenerateMenuState();
}

class _GenerateMenuState extends State<GenerateMenu> {
  bool isFavorite = false;

  initState() {
    super.initState();
    global.quotesMngr.addListener(_onQuoteChanged);
  }

  void _onQuoteChanged() {
    setState(() {
      isFavorite = global.quotesMngr.isCurrentFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Enter your favorite quote and number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Repetitive patterns work best:\nTo Be or not To Be",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 34.0,
            ),
            TextField(
              textInputAction: TextInputAction.next,
              minLines: 1,
              maxLines: 4,
              controller: widget.pGen.quoteController,
              onChanged: (String text) {
                global.quotesMngr.onCurrentQuoteChanged(text);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quote',
              ),
            ),
            SizedBox(
              height: 14.0,
            ),
            TextField(
              controller: widget.pGen.numbersController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
              ),
              maxLength: 4,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    widget.pGen.generate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      "Generate",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () {
                      global.quotesMngr
                          .onFavoriteClicked(widget.pGen.getCurrentQuote());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
