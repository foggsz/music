import 'package:music/models/song.dart';
import 'package:music/models/search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchState {
  SearchState();
}

class SearchLoading extends SearchState {}

class SearchTips extends SearchState {
  final List<Song> suggestSearchList;
  SearchTips({this.suggestSearchList});
}

class SeachError extends SearchState {
  final String errMessage;
  SeachError(this.errMessage);
}

class HistorySearch extends SearchState {
  // SharedPreferences prefs;
  static final HistorySearch _historySearch = HistorySearch._internal();
  static final String storeKey = 'HistorySearch';
  final int storeMaxSize = 10;
  SharedPreferences prefs;
  factory HistorySearch() {
    return HistorySearch._historySearch;
  }
  HistorySearch._internal();

  setHistorySearchStore() async {
    prefs = await SharedPreferences.getInstance();
  }

  // 获取历史记录
  List<Map<String, dynamic>> getHistorySearchStore() {
    var res = (prefs.getStringList(HistorySearch.storeKey) ?? [])
        .map((item) => ({'keyword': item}))
        .toList();
    return res;
  }

  addStore(String value) {
    List<String> oldStore = prefs.getStringList(HistorySearch.storeKey) ?? [];
    if (oldStore.length >= storeMaxSize) {
      oldStore.removeAt(0);
    }
    if (oldStore.indexOf(value) < 0) {
      oldStore.add(value);
    }
    prefs.setStringList(HistorySearch.storeKey, oldStore);
  }

  clearStore() {
    prefs.remove(HistorySearch.storeKey);
  }
}

// 初始化状态
class SearchInit extends SearchState {
  final List<HotSearch> hotSearchList;
  final List<SearchHistory> searchHistory;

  SearchInit({this.hotSearchList, this.searchHistory});
}

// 全部搜索结果
class ALLSearchResult extends SearchState {
  final List<Song> songs;
  final String moreText;
  ALLSearchResult({this.songs, this.moreText});
}
