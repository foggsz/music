import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music/bloc/search.dart';
import 'package:music/pages/search/fn.dart' show searchShowSuggestMenu;
import 'package:music/route.dart';
import 'package:music/widgets/search.dart';
import 'package:music/widgets/loading.dart';
import 'package:music/bloc/search_state.dart';
import 'package:music/widgets/empty.dart';
import 'package:music/http/api.dart';
import 'package:music/models/search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final SearchBloc _bloc = SearchBloc();
  List<HotSearch> hotSearchList = [];
  List<SearchHistory> searchHistory = [];
  String searchHintText = '';
  // 搜索跳转结果页
  jumpSearchResult(String keyword) {
    Map<String, dynamic> _seachParams = {'keywords': keyword};
    return RouteCtrl.goSearchResult(context, searchParams: _seachParams);
  }

  @override
  void initState() {
    super.initState();
    API.getSearchDefaultKeyword().then((res) {
      this.setState(() {
        this.searchHintText = res['data']['showKeyword'];
      });
    });
  }

  // 搜索结果建议
  suggestFn(Map searchParams) async {
    SearchTips result = await _bloc.getSuggestMusicList(params: searchParams);
    var value = await searchShowSuggestMenu(
        context, result.suggestSearchList, searchParams);
    if (value != null) {
      this.jumpToSearchResult(value);
    }
  }

  jumpToSearchResult(String keyWord) {
    RouteCtrl.goSearchResult(context, searchParams: {'keywords': keyWord});
    // 增加搜索记录
    _bloc.addHistorySearchRecord(keyWord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Search(
          suggestFn: this.suggestFn,
          isSowClear: true,
          jumpPageFn: this.jumpSearchResult,
          hintText: this.searchHintText,
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person_pin), onPressed: null)
        ],
      ),
      body: StreamBuilder(
          stream: _bloc.stream,
          initialData: _bloc.initialState,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: null,
                      content: Text('${snapshot.error.toString()}'),
                    ));
              });
              return Container();
            } else if (!snapshot.hasData) {
              return EmptyWidget();
            } else if (snapshot.data is SearchLoading) {
              return Loading();
            } else {
              if (snapshot.data is SearchInit) {
                if ((snapshot.data as SearchInit).hotSearchList != null) {
                  hotSearchList = (snapshot.data as SearchInit).hotSearchList;
                }
                if ((snapshot.data as SearchInit).searchHistory != null) {
                  searchHistory = (snapshot.data as SearchInit).searchHistory;
                }
              }
              return Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      (searchHistory.length > 0)
                          ? SliverPadding(
                              padding: EdgeInsets.only(bottom: 40.0),
                              sliver: SliverToBoxAdapter(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          '历史记录',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.delete),
                                            iconSize: 28.0,
                                            onPressed: () {
                                              _bloc.removeAllHistoryRecode();
                                            })
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 40.0,
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          padding:
                                              EdgeInsets.only(right: 100.0),
                                          cacheExtent: 0,
                                          children: searchHistory.map((e) {
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                child: RaisedButton(
                                                  child: Text(e.keyword),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  onPressed: () {
                                                    this.jumpToSearchResult(
                                                        e.keyword);
                                                  },
                                                ));
                                          }).toList()),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.zero,
                            ),
                      SliverToBoxAdapter(
                        child: Row(
                          children: <Widget>[
                            Text(
                              '热搜榜',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                this.jumpToSearchResult(
                                    hotSearchList[index].searchWord);
                              },
                              child: Container(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18.0),
                                      ),
                                      Expanded(
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    hotSearchList[index]
                                                        .searchWord,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                  Text(
                                                    hotSearchList[index]
                                                        .content,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2,
                                                  ),
                                                ],
                                              ))),
                                      Text(
                                        '${hotSearchList[index].score}',
                                        style:
                                            TextStyle(color: Colors.grey[400]),
                                      )
                                    ],
                                  )),
                            );
                          },
                          childCount: hotSearchList.length,
                        ),
                      )
                    ],
                  ));
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
