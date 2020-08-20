import 'package:flutter/material.dart';
import 'package:music/widgets/badge.dart';

const _Color = Colors.redAccent;

const List<Map<String, dynamic>> firstList = [
  {
    'label': '我的消息',
    'icon': Icons.mail,
    'color': _Color,
    'num': 990,
  },
  {'label': '我的好友', 'icon': Icons.people, 'color': _Color, 'num': 9},
  {'label': '个人主页', 'icon': Icons.home, 'color': _Color, 'num': 10},
  {
    'label': '个性装扮',
    'icon': Icons.search,
    'color': _Color,
  }
];

const List<Map<String, dynamic>> secondtList = [
  {
    'label': '创作者中心',
    'icon': Icons.search,
  }
];

const List<Map<String, dynamic>> thirdList = [
  {
    'label': '听歌识曲',
    'icon': Icons.settings_voice,
  },
  {
    'label': '演出',
    'icon': Icons.settings_voice,
  },
  {
    'label': '商城',
    'icon': Icons.settings_voice,
  },
  {
    'label': '附近的人',
    'icon': Icons.settings_voice,
  },
  {
    'label': '游戏推荐',
    'icon': Icons.settings_voice,
  },
  {
    'label': '口袋彩铃',
    'icon': Icons.settings_voice,
  }
];


const List<Map<String, dynamic>> fourList = [
  {
    'label': '我的订单',
    'icon': Icons.book,
  },
  {
    'label': '定时停止播放',
    'icon': Icons.info,
  },
];

const List<Map<String, dynamic>> bottomList = [
  {
    'label': '夜间模式',
    'icon': Icons.photo_size_select_actual,
  },
  {
    'label': '设置',
    'icon': Icons.perm_data_setting,
  },
    {
    'label': '退出',
    'icon':  Icons.power_settings_new,
  },
];

class SlideCenter {
  final String label;
  final IconData icon;
  final Color color;
  final int num;

  SlideCenter({this.color, this.icon, this.num, this.label});

  SlideCenter.fromJson(Map dict)
      : label = dict['label'],
        icon = dict['icon'],
        color = dict['color'],
        num = dict['num'] ?? 0;

  static List<SlideCenter> getListModel(List<Map> listMap) {
    return listMap.map((item) {
      return SlideCenter.fromJson(item);
    }).toList();
  }

  static List<Widget> listWidget(List<Map> list){
    List<SlideCenter> _list = SlideCenter.getListModel(list);
      return _list.map((item) {
      return ListTile(
        title: Align(
          child: Text(item.label),
          alignment: Alignment(-1.25, 0),
        ),
        leading: Icon(item.icon),
      );
    }).toList();
  }

  static ListTile firstWidget() {
    List<SlideCenter> list = SlideCenter.getListModel(firstList);
    List<Widget> listWidget = list.map((item) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Badge(
              widget: Icon(
                item.icon,
                color: item.color,
                size: 30.0,
              ),
              num: item.num),
          Text(item.label)
        ],
      );
    }).toList();
    return ListTile(
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: listWidget),
    );
  }

  static ListTile secondWidget() {
    List<SlideCenter> list = SlideCenter.getListModel(secondtList);
    SlideCenter first = list?.first;
    return ListTile(
        title: Align(
          child: Text(first.label),
          alignment: Alignment(-1.25, 0),
        ),
        leading: Icon(
          first.icon,
        ));
  }

  static Widget thridWidget() {
    List<Widget> _list =  SlideCenter.listWidget(thirdList);
    return Column(
      children: _list,
    );
  }

  static Widget fourWidget() {
    List<Widget> _list =  SlideCenter.listWidget(fourList);
    return Column(
      children: _list,
    );
  }

  static Widget bottomWidget(){
    List<SlideCenter> _list =  SlideCenter.getListModel(bottomList);
    
    return Container(
      child: Row(
        children: _list.map((item){
          return FlatButton.icon(onPressed: null, icon: Icon(item.icon), label: Text(item.label));
        }).toList()
      ),
    );

  }
  
}
