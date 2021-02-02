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
  String _quote;
  int _minPswdSize = 0;

  void _setQuote(String quote) {
    _quote = quote;
    print("user citation set to: $_quote");
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
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quote',
                ),
                onSubmitted: (String text) {
                  _setQuote(text);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numbers',
                ),
                onSubmitted: (String text) {
                  _setQuote(text);
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
                  Text("Minimum output size: $_minPswdSize"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  print("Generate button pressed");
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
