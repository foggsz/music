import 'package:flutter/material.dart';
import 'package:music/models/song.dart';
import 'package:music/widgets/play.dart';
import 'package:music/http/api.dart';
import 'package:music/widgets/loading.dart';

class PlayAudioPage extends StatefulWidget {
  final Song song;
  PlayAudioPage({this.song});
  @override
  _PlayAudioPage createState() => _PlayAudioPage();
}

class _PlayAudioPage extends State<PlayAudioPage> {
  List<Map<String, dynamic>> formatLyric(String val) {
    List<Map<String, dynamic>> lyric = [];
    RegExp r = new RegExp(r'\[([\d:.]+)\]([\u4e00-\u9fa5\s\w-]+)');
    Iterable<Match> s = r.allMatches(val);
    bool first = true;
    for (Match m in s) {
      Map<String, dynamic> _item = {
        'text': '',
        'time': '-999',
        'color': Colors.white30
      };
      for (int i = 0; i < m.groupCount + 1; i++) {
        String match = m.group(i);
        if (i == 2) {
          if (match != '' && first) {
            _item['color'] = Colors.white;
            first = false;
          }
          _item['text'] = match ?? '';
        }
        if (i == 1) {
          _item['time'] = match ?? '-999';
        }
      }
      lyric.add(_item);
    }
    return lyric;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.song.name),
        ),
        body: FutureBuilder(
            future: API.getPlaySongUrl(params: {'id': widget.song.id}),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // 请求失败，显示错误
                  return Text("Error: ${snapshot.error}");
                } else {
                  // print(snapshot.data);
                  // (snapshot.data['data'] as JsArray)?.first
                  PlaySong _psong =
                      PlaySong.fronJSON((snapshot.data['data'] as List)?.first);
                  return Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.black26,
                      ),
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: FutureBuilder(
                              future: API
                                  .getSongLyric(params: {'id': widget.song.id}),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                // print(snapshot.data['']);
                                List<Map<String, dynamic>> lyric = [];
                                if (snapshot.hasData) {
                                  lyric = formatLyric(
                                      snapshot.data['lrc']['lyric']);
                                  return Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: lyric.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Center(
                                          child: Text(
                                            lyric[index]['text'],
                                            style: TextStyle(
                                                color: lyric[index]['color']),
                                            softWrap: true,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                                // print(lyric.length);
                              },
                            ),
                          ),
                          PlayWidget(
                            url: _psong.url,
                          )
                        ],
                      ),
                    ],
                  );
                }
              } else {
                return Loading();
              }
            }));
  }
}
