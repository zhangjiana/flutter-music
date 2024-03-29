import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'net_utils.dart';
class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController = StreamController<String>.broadcast();

  List _songs = [];
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;

  var nowSong;
  // 向外部暴露 自己的私有变量
  List get allSongs => _songs;
  get curSong => nowSong;
  Stream<String> get curPositionStream => _curPositionController.stream;
  double seekPercent = 0.0;
  AudioPlayerState get curState => _curState;
  // 获取歌曲
  void _getSongs() {
    NetUtils.getDailySongsData().then((data) {
      _songs = data['hotSongs'];
    });
  }
  void init() {
    _getSongs();
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;
      if (state == AudioPlayerState.COMPLETED) {
        nextPlay();
        print('播放下一首歌曲');
      }
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((d) {
      curSongDuration = d;
    });
    // 进度监听
    _audioPlayer.onAudioPositionChanged.listen((Duration position) {
      seekPercent = position.inMilliseconds / curSongDuration.inMilliseconds;
      // setState(() { seekPercent =  percent; });
      sinkProgress(position.inMilliseconds > curSongDuration.inMilliseconds ? curSongDuration.inMilliseconds: position.inMilliseconds);
    });
  }
  // 监听进度的事件。抛出去，供使用
  void audioChange(fn) {
    _audioPlayer.onAudioPositionChanged.listen((Duration position) {
      var p = position.inMilliseconds / curSongDuration.inMilliseconds;
      fn(p);
    });
  }
  // 下一首
  void nextPlay() {
    if (curIndex >= _songs.length) {
      curIndex = 0;
    } else {
      curIndex++;
    }
    play();
  }
  // 上一首
  void prevPlay() {
    if (curIndex == 0) {
      curIndex = _songs.length;
    } else {
      curIndex--;
    }
    play();
  }
  // 播放进度
  void sinkProgress(int m) {
    // print(m);
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }
  // 跳转到固定时间
  void seekPlay(double percent){
    print('drag$percent');
    var nowTime = (curSongDuration.inMilliseconds * percent).toInt();
    _audioPlayer.seek(Duration(milliseconds: nowTime));
    _audioPlayer.resume();
  }
  // 播放
  void play() {
    NetUtils.getSongUrl(this._songs[curIndex]['id']).then((val) {
      print(val);
      _audioPlayer.play(val);
    });
    NetUtils.getSongDetail(this._songs[curIndex]['id']).then((val) {
      nowSong = val;
    });
  }
  // 暂停 
  void pause() {
    _audioPlayer.pause();
  }
  // 暂停还是播放
  void toggle() {
    if (_audioPlayer.state == AudioPlayerState.PLAYING) {
      pause();
    } else if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      _audioPlayer.resume();
    } else {
      play();
    }
  }

  // 离开的时候要释放
  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }
}