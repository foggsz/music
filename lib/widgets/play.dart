import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class PlayWidget extends StatefulWidget {
  final String url;
  final PlayerMode mode;
  PlayWidget({Key key, @required this.url, this.mode = PlayerMode.MEDIA_PLAYER})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayWidget();
  }
}

class _PlayWidget extends State<PlayWidget> {
  AudioPlayerState _playerState = AudioPlayerState.STOPPED;
  Duration _duration = Duration(seconds: 0);
  Duration _position = Duration(seconds: 0);
  StreamSubscription _durationListener;
  StreamSubscription _positionListener;
  StreamSubscription _completeListener;
  StreamSubscription _stateChangeListener;
  StreamSubscription _errorListener;

  get _isPlaying => _playerState == AudioPlayerState.PLAYING;
  get _isPaused => _playerState == AudioPlayerState.PAUSED;
  get _durationTxt => _duration.toString().split('.')?.first;
  get _positionTxt => _position.toString().split('.')?.first;
  // get _isCompleted => _playerState == AudioPlayerState.COMPLETED;
  // get _isStoped => _playerState == AudioPlayerState.STOPPED;
  AudioPlayer audioPlayer;

  Widget getIconButton(IconData iconData,
      {Color color = Colors.white, double size = 26.0, Function press}) {
    return Expanded(
        child: IconButton(
      icon: Icon(
        iconData,
        color: color,
        size: size,
      ),
      onPressed: press,
    ));
  }

  bool isFavorite = false;

  setFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<int> play() async {
    int result = 0;
    if (_isPaused) {
      result = await audioPlayer.resume();
    } else {
      result = await audioPlayer.play(widget.url);
    }
    return result;
  }

  Future<int> pasused() async {
    int result = 0;
    result = await audioPlayer.pause();
    return result;
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer(mode: widget.mode);

    // audioPlayer.setReleaseMode(ReleaseMode.LOOP);

    _durationListener = audioPlayer.onDurationChanged.listen((Duration d) {
      if (!mounted) {
        return;
      }
      setState(() {
        _duration = d;
      });
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        audioPlayer.setNotification(
            title: 'App Name',
            artist: 'Artist or blank',
            albumTitle: 'Name or blank',
            imageUrl: 'url or blank',
            forwardSkipInterval: const Duration(seconds: 30), // default is 30s
            backwardSkipInterval: const Duration(seconds: 30), // default is 30s
            duration: _duration,
            elapsedTime: Duration(seconds: 0));
      }
    });
    _positionListener = audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (!mounted) {
        return;
      }
      setState(() {
        _position = p;
      });
    });

    _completeListener = audioPlayer.onPlayerCompletion.listen((event) {
      if (!mounted) {
        return;
      }
      setState(() {
        _position = _duration;
        _playerState = AudioPlayerState.STOPPED;
      });
    });

    _errorListener = audioPlayer.onPlayerError.listen((msg) {
      print('play error : $msg');
      if (!mounted) {
        return;
      }

      setState(() {
        _playerState = AudioPlayerState.STOPPED;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   showDialog(
      //       context: context,
      //       child: AlertDialog(
      //         title: null,
      //         content: Text('$msg'),
      //       ));
      // });
    });

    _stateChangeListener = audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) {
        return;
      }
      setState(() {
        _playerState = state;
      });
    });

    audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playerState = state);
    });
  }

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() async {
    super.dispose();
    audioPlayer.dispose();
    _durationListener?.cancel();
    _positionListener?.cancel();
    _completeListener?.cancel();
    _stateChangeListener?.cancel();
    _errorListener?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: new Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
                child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    isFavorite
                        ? getIconButton(Icons.favorite,
                            color: Colors.red, press: setFavorite)
                        : getIconButton(Icons.favorite, press: setFavorite),
                    getIconButton(Icons.file_download),
                    getIconButton(Icons.music_note),
                    getIconButton(Icons.comment),
                    getIconButton(Icons.share),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      _positionTxt,
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Slider(
                        value: (_position.inMilliseconds != 0 &&
                                _duration.inMilliseconds != 0 &&
                                _position.inMilliseconds <
                                    _duration.inMilliseconds)
                            ? _position.inMilliseconds /
                                _duration.inMilliseconds
                            : 0,
                        divisions: 5,
                        label: _positionTxt,
                        onChanged: (double value) async {
                          final double pos = value * _duration.inMilliseconds;
                          await audioPlayer
                              .seek(Duration(milliseconds: pos.round()));
                        },
                      ),
                    ),
                    Text(
                      _durationTxt,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    getIconButton(Icons.restaurant_menu),
                    getIconButton(Icons.text_rotation_angleup),
                    _isPlaying
                        ? getIconButton(Icons.pause_circle_outline,
                            size: 40.0, press: pasused)
                        : getIconButton(Icons.play_circle_outline,
                            size: 40.0, press: play),
                    getIconButton(Icons.text_rotation_angledown),
                    getIconButton(Icons.menu),
                    SizedBox(
                      width: 20.0,
                    )
                  ],
                )
              ],
            ))),
        onWillPop: () async {
          await audioPlayer.pause();
          return Future.value(true);
        });
  }
}
