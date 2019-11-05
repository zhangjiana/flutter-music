
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mymusic/play_songs.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

class BottomControls extends StatelessWidget {
  const BottomControls({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaySongsModel>(builder: (context, model, child) {
      print(model.play);
      return Container(
        width: double.infinity,
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
            Material(
                shadowColor: Color(0x44080800),
                color: accentColor,
                child: Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 50.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    new PrevButton(model),
                    Expanded(
                      child: Container(),
                    ),
                    new PlayPauseButton(model),
                    Expanded(
                      child: Container(),
                    ),
                    new NextButton(model),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
    });
  }
}

class PlayPauseButton extends StatefulWidget {
  final PlaySongsModel model;
  PlayPauseButton(this.model);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: CircleBorder(),
      fillColor: Colors.white,
      splashColor: lightAccentColor,
      highlightColor: lightAccentColor.withOpacity(0.5),
      elevation: 10.0,
      highlightElevation: 5.0,
      onPressed: () {
        widget.model.toggle();
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          widget.model.curState == AudioPlayerState.PLAYING ? Icons.pause : Icons.play_arrow,
          color: darkAccentColor,
          size: 35.0,
        ),),
    );
  }
}

class PrevButton extends StatefulWidget {
  
  final PlaySongsModel model;
  PrevButton(this.model);

  @override
  _PrevButtonState createState() => _PrevButtonState();
}

class _PrevButtonState extends State<PrevButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      onPressed: () {
        widget.model.prevPlay();
      },
      icon: Icon(Icons.skip_previous,
          color: Colors.white, size: 35.0),
    );
  }
}

class NextButton extends StatefulWidget {
  final PlaySongsModel model;
  NextButton(this.model);

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      onPressed: () {
        widget.model.nextPlay();
      },
      icon: Icon(Icons.skip_next,
          color: Colors.white, size: 35.0),
    );
  }
}