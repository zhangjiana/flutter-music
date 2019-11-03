import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'model/song.dart';
import 'net_utils.dart';
class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController = StreamController<String>.broadcast();

  List _songs = [];
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;

  List get allSongs => _songs;
  Song get curSong => _songs[curIndex];

  Stream<String> get curPositionStream => _curPositionController.stream;

  AudioPlayerState get curState => _curState;
  // 获取歌曲
  void _getSongs() {
    NetUtils.getDailySongsData().then((data) {
      print(data['hotSongs']);
      _songs = data['hotSongs'];
      // data['toplist']
      //     .map((r) => Song(
      //           r.id,
      //           name: r.name,
      //           picUrl: r.picUrl,
      //           artists: '${r.artists.map((a) => a.name).toList().join('/')}',
      //         )).toList();
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
      sinkProgress(position.inMilliseconds > curSongDuration.inMilliseconds ? curSongDuration.inMilliseconds: position.inMilliseconds);
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
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }
  // 播放
  void play() {
    NetUtils.getSongUrl(this._songs[curIndex]['id']).then((val) {
      print(val);
      _audioPlayer.play(val);
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