import 'package:flutter/material.dart';
import 'package:music/pages/search/search.dart';
import 'package:music/pages/search/searchResult.dart';
import 'package:music/pages/playAudio.dart';

const Map<String, dynamic> _searchParams = {'keyword': ''};

class RouteCtrl {
  // 跳到搜索页面
  static Future<dynamic> goSearch(BuildContext context,
      {Map<String, dynamic> searchParams = _searchParams}) {
    return Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
  }

  // 跳到搜索结果列表页
  static Future<dynamic> goSearchResult(BuildContext context,
      {Map<String, dynamic> searchParams = _searchParams}) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => SearchResultPage(
              searchParams: searchParams,
            )));
  }

  // 跳转到播放页面
  static Future<dynamic> goPlayAudio(BuildContext context,
      {Map<String, dynamic> playParams = _searchParams}) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PlayAudioPage(
              song: playParams['song'],
            )));
  }
}
