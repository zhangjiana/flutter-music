import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'model/song.dart';

class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController = StreamController<String>.broadcast();

  List<Song> _songs = [];
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;

  List<Song> get allSongs => _songs;
  Song get curSong => _songs[curIndex];

  Stream<String> get curPositionStream => _curPositionController.stream;

  AudioPlayerState get curState => _curState;
  // 初始化
  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;
      if (state == AudioPlayerState.COMPLETED) {
        // nextPlay();
        print('播放下一首歌曲');
      }
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((d) {
      curSongDuration = d;
    });
    // 进度监听
    _audioPlayer.onAudioPositionChanged.listen((Duration position) {
      sinkProgress(position.inMilliseconds > curSongDuration.inMilliseconds ? curSongDuration.inMilliseconds: position.inMilliseconds);
    });
  }
  // 播放进度
  void sinkProgress(int m) {
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }
  // 播放
  void play() {
    print('get');
    _audioPlayer.play('https://music.163.com/song/media/outer/url?id=${this._songs[curIndex].id}.mp3');
  }
  // 暂停
  void pause() {
    _audioPlayer.pause();
  }
  // 离开的时候要释放
  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }
}