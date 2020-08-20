class HotSearch {
  final String searchWord;
  final int score;
  final String content;
  final int source;
  final int iconType;
  final String iconUrl;
  final String url;
  final String alg;
  HotSearch(
      {this.searchWord,
      this.score,
      this.content,
      this.source,
      this.iconType,
      this.iconUrl,
      this.url,
      this.alg});

  HotSearch.fromJSON(Map<String, dynamic> map)
      : this.searchWord = map['searchWord'],
        this.score = map['score'],
        this.content = map['content'],
        this.source = map['source'],
        this.iconType = map['iconType'],
        this.iconUrl = map['iconUrl'],
        this.url = map['url'],
        this.alg = map['alg'];

  static List<HotSearch> getHotSearchList(List<dynamic> list) {
    return list.map((e) => HotSearch.fromJSON(e)).toList();
  }
}

class SearchHistory {
  String keyword;

  SearchHistory({this.keyword});
  SearchHistory.fromJSON(Map map) : keyword = map['keyword'];

  static List<Map<String, dynamic>> defaultHistoryJson = [
    {'keyword': '千与千寻1'},
    {'keyword': '千与千寻2'},
    {'keyword': '千与千寻3'},
    {'keyword': '千与千寻4'},
    {'keyword': '千与千寻5'},
    {'keyword': '千与千寻6'},
  ];

  static List<SearchHistory> getSearchHistory(
      List<Map<String, dynamic>> _list) {
    return _list.map((e) => SearchHistory.fromJSON(e)).toList();
  }
}

// type: 搜索类型；默认1
class SearchTypeDict {
  static final int singles = 1; // 单曲
  static final int album = 10; // 专辑
  static final int singer = 100; // 歌手
  static final int songSheet = 1000; //歌单
  static final int user = 1002; // 用户
  static final int mv = 1004; // MV
  static final int lyric = 1006; // 歌词
  static final int broadcastingStation = 1009; //电台
  static final int video = 1014; // 视频
  static final int all = 1018; // 综合
}

Map<int, dynamic> searchTypeCnDict = {
  SearchTypeDict.all: '综合',
  SearchTypeDict.singles: '单曲',
  SearchTypeDict.album: '专辑',
  SearchTypeDict.singer: '歌手',
  SearchTypeDict.songSheet: '歌单',
  SearchTypeDict.user: '用户',
  SearchTypeDict.mv: 'MV',
  SearchTypeDict.lyric: '歌词',
  SearchTypeDict.broadcastingStation: '电台',
  SearchTypeDict.video: '视频',
};

// searchTab
class SearchTab {
  String keyword;
  int type;
  SearchTab.fromJson(Map<String, dynamic> json)
      : keyword = json['keyword'],
        type = json['type'];

  // 获取tab
  static List<SearchTab> getSearchTabs() {
    List<SearchTab> _searchTab = [];
    searchTypeCnDict.forEach((key, value) {
      Map<String, dynamic> _item = {
        'keyword': value,
        'type': key,
      };
      _searchTab.add(SearchTab.fromJson(_item));
    });
    return _searchTab;
  }
}
