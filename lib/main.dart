import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:ciphatron/components/generate_menu.dart';
import 'package:ciphatron/global.dart';
import 'package:ciphatron/pswd_gen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: 'Ciphatron',
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.blue,
      ),
      darkTheme: ThemeData(
        accentColor: Colors.blue,
        cardColor: Colors.blue,
        brightness: Brightness.dark,
        canvasColor: Color(0xff341f97),
        dialogBackgroundColor: Colors.black,
      ),
      themeMode: ThemeMode.system,
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

PanelController _pc = new PanelController();

class _MyHomePageState extends State<MyHomePage> {
  PswdGen pGen;

  // floating button variables to make it follow panel movement
  final double _initFabHeight = 120.0;
  double _fabHeight;
  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  bool showEmptyList = true; // show/hide panel empty list instructions

  void initState() {
    super.initState();

    pGen = PswdGen();
    global.quotesMngr.addListener(() {
      setState(() {
        showEmptyList = global.quotesMngr.isEmpty();
      });
    });
    _fabHeight = _initFabHeight;
  }

  void dispose() {
    pGen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .80;
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    SlidingUpPanel slidingUpPanel = SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      borderRadius: radius,
      controller: _pc,
      backdropEnabled: true,
      color: Theme.of(context).dialogBackgroundColor,
      panelBuilder: (ScrollController sc) => _scrollingList(sc, pGen),
      collapsed: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: radius),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.horizontal_rule,
                size: 32,
              ),
              Text("Favorites"),
            ],
          ),
        ),
      ),
      panel: !showEmptyList // override panelBuilder when list is empty
          ? null
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add quotes with the ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    Icons.favorite_border,
                  ),
                ],
              ),
            ), // allows panelBuilder to be drawn
      body: GenerateMenu(pGen: pGen),
      onPanelSlide: (double pos) => setState(() {
        _fabHeight =
            pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
      }),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, // prevent panel to follow keyboard
      body: Stack(
        children: [
          slidingUpPanel,
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              onPressed: () {
                _pc.close();
                setState(() {
                  pGen.quoteController.clear();
                  pGen.numbersController.clear();
                  global.quotesMngr.onCurrentQuoteChanged("");
                });

                // clear focus
                FocusScope.of(context).requestFocus(FocusNode());
              },
              tooltip: 'Refresh',
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _scrollingList(ScrollController sc, PswdGen pGen) {
  return ListView.builder(
    controller: sc,
    itemCount: global.quotesMngr.size(),
    itemBuilder: (BuildContext context, int i) {
      final item = global.quotesMngr.get(i);
      return Dismissible(
        key: Key(item),
        onDismissed: (DismissDirection dir) {
          global.quotesMngr.onUserDismiss(i);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Quote dismissed")));
        },
        background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
        child: Card(
          child: ListTile(
            onTap: () {
              pGen.quoteController.text = item;
              global.quotesMngr.onUserLoad(); // update favorite
              _pc.close(); // slide down panel
            },
            title: Text(item),
          ),
        ),
      );
    },
  );
}
