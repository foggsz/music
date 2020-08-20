import 'package:flutter/material.dart';
import 'package:music/pages/search/searchResultTabs/singer.dart';
import 'package:music/widgets/search.dart';
import 'package:music/models/search.dart';
import 'package:music/themes/tabBar.dart';
// import 'package:music/bloc/search.dart';
import 'package:music/pages/search/searchResultTabs/all.dart';
import 'package:music/pages/search/searchResultTabs/album.dart';
import 'package:music/pages/search/searchResultTabs/singles.dart';
import 'package:music/pages/search/searchResultTabs/songSheet.dart';
import 'package:music/pages/search/searchResultTabs/user.dart';
import 'package:music/pages/search/searchResultTabs/mv.dart';
import 'package:music/pages/search/searchResultTabs/lyric.dart';
import 'package:music/pages/search/searchResultTabs/broadcastingStation.dart';
import 'package:music/pages/search/searchResultTabs/video.dart';

const Map<String, dynamic> _searchParams = null;

class SearchResultPage extends StatefulWidget {
  final Map<String, dynamic> searchParams;
  SearchResultPage({this.searchParams = _searchParams});
  @override
  _SearchResultPage createState() {
    return _SearchResultPage();
  }
}

class _SearchResultPage extends State<SearchResultPage>
    with TickerProviderStateMixin {
  String _keywords = '';
  final List<SearchTab> searchTabs = SearchTab.getSearchTabs();
  List<Widget> tabs = [];
  TabController _tabController;
  List<Widget> tabsView = [];

  Map<String, dynamic> searchParams = {};
  int curIndex = 0;
  String keywords = '';
  @override
  void initState() {
    super.initState();

    _keywords = widget.searchParams['keywords'];
    keywords = _keywords;
    tabs = searchTabs
        .map((SearchTab e) => Tab(
              text: e.keyword,
            ))
        .toList();
    tabsView = [
      SearchAllTab(keywords: keywords, type: SearchTypeDict.all),
      AlbumTab(keywords: keywords, type: SearchTypeDict.album),
      SinglesTab(keywords: keywords, type: SearchTypeDict.singles),
      SingerTab(keywords: keywords, type: SearchTypeDict.singer),
      SongSheet(keywords: keywords, type: SearchTypeDict.songSheet),
      UserTab(keywords: keywords, type: SearchTypeDict.songSheet),
      MvTab(keywords: keywords, type: SearchTypeDict.mv),
      LyricTab(keywords: keywords, type: SearchTypeDict.lyric),
      BroadcastingStationTab(
          keywords: keywords, type: SearchTypeDict.broadcastingStation),
      VideoTab(keywords: keywords, type: SearchTypeDict.video)
    ];

    _tabController =
        TabController(initialIndex: 0, length: tabsView.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Search(
            isSowClear: true,
            initText: _keywords,
          ),
          bottom: TabBar(
              tabs: tabs,
              isScrollable: true,
              controller: _tabController,
              labelStyle: TextStyle(
                  fontSize: MtabBarTheme.labelFontSize), //For Selected tab
              unselectedLabelStyle:
                  TextStyle(fontSize: MtabBarTheme.activeLabelFontSize),
              labelPadding: MtabBarTheme.labelPadding),
        ),
        body: TabBarView(
          children: tabsView,
          controller: _tabController,
        ));
  }
}
