import 'package:flutter/material.dart';
import 'package:music/bloc/search_state.dart';
import 'package:music/models/song.dart';
import 'package:music/http/api.dart';
import 'package:music/help.dart';
import 'package:music/widgets/loading.dart';
import 'package:music/route.dart';

List<Map> getBottomMenu(Song song) {
  return [
    {'name': '下一首播放', 'icon': Icons.play_circle_outline},
    {'name': '收藏到歌单', 'icon': Icons.photo_filter},
    {'name': '下载', 'icon': Icons.file_download},
    {'name': '评论', 'icon': Icons.comment},
    {'name': '分享', 'icon': Icons.share},
    {'name': song.artists[0].name, 'icon': Icons.person_pin},
    {
      'name': song.album.name,
      'icon': Icons.album,
    },
    {'name': '云贝推哥（已有12323人推荐）', 'icon': Icons.star_half},
    {'name': '相关视频', 'icon': Icons.video_library},
    {'name': '购买单曲', 'icon': Icons.shopping_cart}
  ];
}

class SearchAllTab extends StatefulWidget {
  final String keywords;
  final int type;

  SearchAllTab({this.keywords, this.type});
  @override
  State<StatefulWidget> createState() {
    return _SearchAllTab();
  }
}

class _SearchAllTab extends State<SearchAllTab> {
  List<Song> songs = [];
  String moreText = '';
  Map<String, dynamic> searchParams = {
    'keywords': '',
  };

  showBottomSheet(BuildContext context, Song song) {
    List<Map> _list = getBottomMenu(song);
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.only(top: 10.0),
              constraints: getBoxConstraints(
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                  2 / 3),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: Image.network(
                            song.album.picUrl,
                            fit: BoxFit.cover,
                          )),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${song.name}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              )),
                          song.artists is List
                              ? Text(
                                  song.artists
                                      .map((e) => ('${e.name}'))
                                      .join(''),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(''),
                        ],
                      )),
                  Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          itemBuilder: (BuildContext context, int index) {
                            Map _item = _list[index];
                            return Container(
                              margin: EdgeInsets.zero,
                              height: 45.0,
                              child: ListTile(
                                isThreeLine: false,
                                title: Align(
                                  child: Text(_item['name']),
                                  alignment: Alignment(-1.15, 0),
                                ),
                                leading: Icon(_item['icon']),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: _list.length))
                ],
              ));
        });
  }

  Future<ALLSearchResult> fetchList() async {
    try {
      var res = await API.getSearchList(params: searchParams);
      Map<String, dynamic> song =
          Map<String, dynamic>.from(res['result']['song'] ?? {});
      List<Map<String, dynamic>> _songs =
          new List<Map<String, dynamic>>.from(song['songs']) ?? [];
      songs = Song.getSongList(_songs);
      moreText = song['moreText'] ?? '';
      return ALLSearchResult(moreText: moreText, songs: songs);
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }

  @override
  void initState() {
    super.initState();
    searchParams['keywords'] = widget.keywords;
    searchParams['type'] = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              ALLSearchResult _result = snapshot.data;

              // 请求成功，显示数据
              return CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0),
                      sliver: SliverList(
                        delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            //创建子widget
                            Song song = _result.songs[index];
                            return Container(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () => {print('onTap')},
                                      child: Row(children: [
                                        Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    song.album.picUrl),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('${song.name}',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.blue[300],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                )),
                                            song.alia is List &&
                                                    song.alia.length > 0
                                                ? Text(
                                                    song.alia.join(''),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                            song.artists is List
                                                ? Text(
                                                    song.artists
                                                        .map((e) => ('${e.name}' +
                                                            ' - ${song.al.name}'))
                                                        .join(''),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Text(''),
                                          ],
                                        ))
                                      ]),
                                    )),
                                    IconButton(
                                        icon: Icon(Icons.play_circle_outline),
                                        onPressed: () {
                                          RouteCtrl.goPlayAudio(context,
                                              playParams: {'song': song});
                                        }),
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () =>
                                          {this.showBottomSheet(context, song)},
                                    ),
                                  ],
                                ));
                          },
                          childCount: _result.songs.length,
                        ),
                      )),
                ],
              );
            }
          } else {
            // loading
            return Loading();
          }
        });
  }
}
