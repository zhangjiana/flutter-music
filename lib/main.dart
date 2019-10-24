import 'package:flutter/material.dart';
import 'package:mymusic/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Music',
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.lightBlue,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: Colors.lightBlue,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 125.0,
              color: Colors.green,
            ),
            // song Title, artist
            Container(
              color: accentColor,
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(child: 
                    Column(children: <Widget>[
                      Text(
                      'Song Title',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4.0,
                            height: 1.5,
                          )
                    ),
                    Text(
                      'Artist Name',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.0,
                            letterSpacing: 3.0,
                            height: 1.5
                          )
                    ),
                  ],)
                  )
                ],)
              ],),
            )
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      )
    );
  }
}
