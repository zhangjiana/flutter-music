import 'package:flutter/material.dart';
import 'package:mymusic/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My music',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            print('leading');
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.lightBlue,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('actions');
            },
            icon: Icon(Icons.menu),
            color: Colors.lightBlue,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            height: 125.0,
            color: Colors.green,
          ),
          // song Title, artist
          Container(
              color: accentColor,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 40.0, bottom: 50.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text('Song Title',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4.0,
                                    height: 1.5,
                                  )),
                              Text('Artist Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.75),
                                      fontSize: 12.0,
                                      letterSpacing: 3.0,
                                      height: 1.5)),
                            ],
                          ))
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0, bottom: 50.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.skip_previous,
                              color: Colors.white, size: 35.0),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        RawMaterialButton(
                          shape: CircleBorder(),
                          fillColor: Colors.white,
                          splashColor: lightAccentColor,
                          highlightColor: lightAccentColor.withOpacity(0.5),
                          elevation: 10.0,
                          highlightElevation: 5.0,
                          onPressed: () {
                            // ToDo:
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow,
                              color: darkAccentColor,
                              size: 35.0,
                            ),),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.skip_next,
                              color: Colors.white, size: 35.0),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
