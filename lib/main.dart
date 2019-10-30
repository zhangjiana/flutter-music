import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mymusic/bottom_controls.dart';
import 'package:mymusic/theme.dart';
import 'package:mymusic/songs.dart';
import 'package:fluttery_dart2/gestures.dart';
import 'package:audioplayers/audioplayers.dart';
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

  final String url = demoPlayList.songs[0].audioUrl;
  AudioPlayer audioPlayer = AudioPlayer();
  void _play() async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      // success
      print('played');
    }
  }
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
          onPressed: _play,
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
          // seek bar
          Expanded(child: RadialSeekBar()),
          // visualLizer
          Container(
            width: double.infinity,
            height: 125.0,
            color: Colors.green,
          ),
          // song Title, artist
          new BottomControls()
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RadialSeekBar extends StatefulWidget {

  final double seekPercent;

  RadialSeekBar({
    this.seekPercent = 0.0
  });

  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {

  double _seekPercent = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();
    _seekPercent = widget.seekPercent;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _seekPercent = widget.seekPercent;
  }
  
  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercent = _seekPercent;
    print(coord);
  }
  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(() {
      _currentDragPercent = (_startDragPercent + dragPercent) * 1.0;
    });
  }
  void _onDragEnd() {
    setState(() {
      _seekPercent = _currentDragPercent;
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0.0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
        onRadialDragStart: _onDragStart,
        onRadialDragUpdate: _onDragUpdate,
        onRadialDragEnd: _onDragEnd,
        child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 140.0,
            height: 140.0,
            child: RadialProgressBar(
                trackColor: Color(0xFFDDDDDD) ,
                progressPercent: _currentDragPercent ?? _seekPercent,
                progressColor: accentColor,
                thumbPosiiton: _currentDragPercent ?? _seekPercent,
                thumbColor: lightAccentColor,
                innerPadding: EdgeInsets.all(10.0),
                child: ClipOval(
                  clipper: CircleClipper(),
                  child: Image.network(
                  demoPlayList.songs[0].albumArtUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return new Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

}

class RadialProgressBar extends StatefulWidget {

  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final double thumbPosiiton;
  final Color thumbColor;
  final Widget child;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;

  RadialProgressBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 3.0,
    this.progressColor = accentColor,
    this.progressPercent = 0.0,
    this.thumbSize = 3.0,
    this.thumbPosiiton = 0.0,
    this.thumbColor = Colors.green,
    this.child,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0)
  });
   
  @override
  _RadialProgressBarState createState() => _RadialProgressBarState();
}

class _RadialProgressBarState extends State<RadialProgressBar> {
  EdgeInsets _insetsForPainter() {
    final outerThickness = max(
      widget.trackWidth,
      max(widget.progressWidth, widget.thumbSize)
    );
    return EdgeInsets.all(outerThickness);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialProgressBarPainter(
          trackWidth: widget.trackWidth,
          trackColor: widget.trackColor,
          progressWidth: widget.progressWidth,
          progressColor: widget.progressColor,
          progressPercent: widget.progressPercent,
          thumbSize: widget.thumbSize,
          thumbColor: widget.thumbColor,
          thumbPosiiton: widget.thumbPosiiton
        ),
        child: Padding(
          padding: _insetsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialProgressBarPainter extends CustomPainter {

  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final double progressPercent;
  final Paint progressPaint;
  final double thumbSize;
  final double thumbPosiiton;
  final Paint thumbPaint;

  RadialProgressBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required this.thumbPosiiton,
    @required thumbColor
  }) : trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = trackWidth,
       progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = progressWidth
        ..strokeCap = StrokeCap.round,
      thumbPaint = Paint()
        ..color = thumbColor
        ..style = PaintingStyle.fill; 


  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize = Size(
      size.width - outerThickness,
      size.height - outerThickness
    );
    // paint track
    // 圆中心坐标
    final center = Offset(size.width / 2, size.height / 2);
    // 圆半径
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;

    // 绘制路径图
    canvas.drawCircle(center, radius, trackPaint);

    // paint progress
    final startAngle = - pi / 2;
    final progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, progressAngle, false, progressPaint);

    // paint thumb
    // 手指触动的路径，是一个沿着圆路径的小圆形。
    final thumbAngle = 2 * pi * thumbPosiiton - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
     canvas.drawCircle(thumbCenter, thumbSize / 2.0, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true; 
  }

}