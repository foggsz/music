// 艺术家
class Artist {
  int id;
  String name;
  String picUrl;
  List<dynamic> alias; // 歌手别名
  int albumSize; // 专辑数量
  int picId; // 图片id
  String img1v1Url; // ?
  int img1v1; // ?
  var trans; // ?

  Artist.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        picUrl = map['picUrl'],
        alias = map['alias'],
        albumSize = map['albumSize'],
        picId = map['picId'],
        img1v1Url = map['img1v1Url'],
        img1v1 = map['img1v1'],
        trans = map['trans'];

  static getArtistList(List<Map<String, dynamic>> list) {
    return list.map((item) {
      return Artist.fromJson(item);
    }).toList();
  }
}

// 专辑
class Album {
  int id;
  String name;
  Artist artist; // 专辑相关艺术家
  int publishTime; // 发布时间
  int size; // 大小
  int picId; // 图片id
  List<dynamic> alia; // 专辑别名
  int mark; //标记
  String picUrl;

  Album.formJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'] ?? null;
    name = jsonMap['name'] ?? null;
    if (jsonMap['artist'] is Map<String, dynamic>) {
      artist = Artist.fromJson(jsonMap['artist']);
    }
    publishTime = jsonMap['publishTime'] ?? null;
    size = jsonMap['size'] ?? null;
    picId = jsonMap['picId'] ?? null;
    alia = jsonMap['alia'] ?? [];
    mark = jsonMap['mark'] ?? null;
    picUrl = jsonMap['picUrl'] ?? '';
  }
}

class AL {
  String name = '';
  AL.fromJson(json) {
    this.name = json['name'] ?? '';
  }
}

class Song {
  int id; // 歌曲id
  String name; // 歌曲名字
  List<Artist> artists; // 歌曲相关艺术家
  Album album; // 专辑
  int duration; //时长
  int copyrightId; // 版权id
  int status; // 状态
  List<dynamic> alias; // 歌曲名字别名数组
  List<dynamic> alia; // 歌曲名字别名数组
  int rtype; // ?
  int ftype; // ?
  int mvid; // mv id
  int fee; // 费用？
  String rUrl; // ?
  int mark; // 标记
  AL al;

  Song.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        artists = Artist.getArtistList(jsonMap['artists']),
        album = Album.formJson(jsonMap['album']),
        duration = jsonMap['duration'],
        copyrightId = jsonMap['copyrightId'],
        status = jsonMap['status'],
        alias = jsonMap['alias'],
        alia = jsonMap['alia'],
        rtype = jsonMap['rtype'],
        ftype = jsonMap['ftype'],
        mvid = jsonMap['mvid'],
        fee = jsonMap['fee'],
        rUrl = jsonMap['rUrl'],
        mark = jsonMap['mark'],
        al = AL.fromJson(jsonMap['al'] ?? {});

  static List<Song> getSongList(List<Map<String, dynamic>> _list) {
    return _list.map((e) {
      var ar = e['artists'] ?? e['ar'];
      var al = e['album'] ?? e['al'];
      e['artists'] = new List<Map<String, dynamic>>.from(ar);
      e['album'] = new Map<String, dynamic>.from(al);
      Song song = Song.fromJson(e);
      return song;
    }).toList();
  }
}

// 播放song
class PlaySong {
  int id;
  String url;
  int size;
  int expi;
  int br;
  String type;

  PlaySong.fronJSON(Map<String, dynamic> map)
      : id = map['id'],
        url = map['url'],
        size = map['size'],
        expi = map['expi'],
        br = map['br'],
        type = map['type'];
}
