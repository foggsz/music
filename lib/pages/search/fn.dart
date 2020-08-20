import 'package:flutter/material.dart';
import 'package:music/models/song.dart';

dynamic searchShowSuggestMenu(
    BuildContext context, List<Song> list, Map searchParams) async {
  double _fontSize = 16.0;
  List<Widget> _list = list.map((item) {
    return PopupMenuItem(
        value: '${item.name}',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: <Widget>[
                    Icon(Icons.search),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                        child: Text(
                      item.name,
                      style: TextStyle(fontSize: _fontSize),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    )),
                  ],
                )),
          ]).toList(),
        ));
  }).toList();
  String tip = '搜索 "${searchParams['keyword']}"';
  _list.insert(
      0,
      PopupMenuItem(
        value: '${searchParams['keyword']}',
        child: Text(
          tip,
          style: TextStyle(
              color: Theme.of(context).primaryColor, fontSize: _fontSize),
        ),
      ));
  var value = await showMenu(
      context: context,
      initialValue: '',
      position: RelativeRect.fromLTRB(
          0,
          kToolbarHeight +
              MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .padding
                  .top,
          0,
          0),
      items: _list);
  return value;
}
