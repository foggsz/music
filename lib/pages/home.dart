import 'package:flutter/material.dart';
import 'package:music/widgets/drawer.dart';
import 'package:music/route.dart';
import 'package:music/pages/homeTabs/my.dart';
import 'package:music/pages/homeTabs/discover.dart';
import 'package:music/pages/homeTabs/cloudyVilage.dart';
import 'package:music/pages/homeTabs/video.dart';
import 'package:music/themes/tabBar.dart';

class HomePage extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomePage> with TickerProviderStateMixin {
  List<Widget> tabBarViews = [
    MyTab(),
    DiscoverTab(),
    CloudyVilageTab(),
    VideoTab()
  ];

  List<Tab> getTabs() {
    List<dynamic> _tabs = List<dynamic>.from(tabBarViews);
    return _tabs.map((e) {
      String tabName = e.tabName;
      return new Tab(
        iconMargin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.zero,
          child: Text(tabName),
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      );
    }).toList();
  }

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabBarViews.length, vsync: this);
    _tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Container(
              width: 400,
              child: TabBar(
                  isScrollable: false,
                  controller: _tabController,
                  tabs: getTabs(),
                  indicatorColor: Colors.transparent,
                  labelStyle: TextStyle(
                      fontSize: MtabBarTheme.labelFontSize), //For Selected tab
                  unselectedLabelStyle:
                      TextStyle(fontSize: MtabBarTheme.activeLabelFontSize))),
          titleSpacing: 0,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () => RouteCtrl.goSearch(context))
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabBarViews,
        ),
        drawer: MyDrawer());
  }
}
