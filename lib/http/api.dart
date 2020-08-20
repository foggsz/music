import 'package:music/http/http.dart';

const Map DefaultParams = {};

class URL {
  static final String searchList = '/search'; // 搜索
  static final String hotSearchList = '/search/hot/detail'; // 热搜列表
  static final String searchDefaultKeywords = '/search/default'; // 默认搜索关键词
  static final String songPlayUrl = '/song/url'; // 歌曲播放地址
  static final String songlyric = '/lyric'; // 歌词
}

class API {
  static Future<dynamic> getMusicList({Map<String, dynamic> params}) async {
    return http.get(URL.searchList, data: params);
  }

  static Future<dynamic> getSearchList({Map<String, dynamic> params}) async {
    if (params['keywords'].runtimeType == null ||
        params['keywords'].runtimeType == '') {
      params.remove('keywords');
    }

    var res = http.get(URL.searchList, data: params);
    return res;
  }

  static Future<dynamic> getHotSearchList({Map<String, dynamic> params}) async {
    return http.get(URL.hotSearchList, data: params);
  }

  static Future<dynamic> getSearchDefaultKeyword(
      {Map<String, dynamic> params}) async {
    return http.get(URL.searchDefaultKeywords, data: params);
  }

  // 获取歌曲播放地址
  static Future<dynamic> getPlaySongUrl({Map<String, dynamic> params}) {
    return http.get(URL.songPlayUrl, data: params);
  }

  // 获取歌词
  static Future<dynamic> getSongLyric({Map<String, dynamic> params}) {
    return http.get(URL.songlyric, data: params);
  }
}
