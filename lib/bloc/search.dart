import 'dart:async';
import 'package:music/http/api.dart';
import 'package:music/models/song.dart';
import 'package:music/bloc/search_state.dart';
import 'package:dio/dio.dart';
import 'package:music/models/search.dart';

class SearchBloc {
  final StreamController<SearchState> _controller = StreamController();
  get controller => _controller;
  get stream => _controller.stream;
  get sink => _controller.sink;
  get initialState => getSearchInit();
  HistorySearch historySearch = HistorySearch();
  static bool loading;

  // 获取搜索建议
  getSuggestMusicList({Map params, Function(List<Song> list) callback}) async {
    try {
      var res = await API
          .getSearchList(params: {'keywords': params['keyword'], 'limit': 10});
      List<Map<String, dynamic>> songs =
          new List<Map<String, dynamic>>.from(res['result']['songs'] ?? []);

      List<Song> suggestSearchList = Song.getSongList(songs);
      SearchTips result = SearchTips(suggestSearchList: suggestSearchList);
      return result;
    } on DioError catch (err) {
      _controller.addError(err);
    } catch (err) {
      _controller.addError(err);
    }
  }

  //  添加历史搜索记录
  addHistorySearchRecord(String value) {
    historySearch.addStore(value);
    List<SearchHistory> searchHistory =
        SearchHistory.getSearchHistory(historySearch.getHistorySearchStore());
    SearchInit _searchInt = SearchInit(searchHistory: searchHistory);
    sink.add(_searchInt);
    return value;
  }

  // 移除所有历史记录
  removeAllHistoryRecode() {
    historySearch.clearStore();
    sink.add(SearchInit(searchHistory: []));

    return true;
  }

  // 获取初始搜索页面
  getSearchInit() async {
    sink.add(SearchLoading());
    await historySearch.setHistorySearchStore();
    List<Map<String, dynamic>> historySearchList =
        historySearch.getHistorySearchStore();

    try {
      var res = await API.getHotSearchList();
      List<HotSearch> hotSearchList = HotSearch.getHotSearchList(res['data']);
      List<SearchHistory> searchHistory =
          SearchHistory.getSearchHistory(historySearchList);
      SearchInit _searchInt = SearchInit(
          hotSearchList: hotSearchList, searchHistory: searchHistory);
      sink.add(_searchInt);
    } catch (err) {
      print(err);
      _controller.addError(err);
    }
  }

  dispose() {
    _controller.close();
  }
}
