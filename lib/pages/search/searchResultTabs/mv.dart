import 'package:flutter/material.dart';
import 'package:music/models/song.dart';
import 'package:music/http/api.dart';

class MvTab extends StatefulWidget {
  final String keywords;
  final int type;

  MvTab({this.keywords, this.type});
  @override
  State<StatefulWidget> createState() {
    return _MvTab();
  }
}

class _MvTab extends State<MvTab> {
  List<Song> songs = [];
  String moreText = '';
  Map<String, dynamic> searchParams = {
    'keywords': '',
  };

  fetchList() async {
    try {
      var res = await API.getSearchList(params: searchParams);
      Map<String, dynamic> song =
          Map<String, dynamic>.from(res['result']['song'] ?? {});
      List<Map<String, dynamic>> _songs =
          new List<Map<String, dynamic>>.from(song['songs']) ?? [];
      songs = Song.getSongList(_songs);
      moreText = song['moreText'] ?? '';
    } catch (err) {}
  }

  @override
  void initState() {
    super.initState();
    searchParams['keywords'] = widget.keywords;
    searchParams['type'] = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('mv'));
  }
}
