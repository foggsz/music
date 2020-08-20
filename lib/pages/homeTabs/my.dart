import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MyTab extends StatefulWidget {
  final String tabName = '我的';
  @override
  _MyTab createState() {
    return _MyTab();
  }
}

class _MyTab extends State<MyTab> {
  List<String> _swipers = [
    'http://p1.music.126.net/OxryWQ44xGPOTZWAei3WJg==/109951165120508001.jpg?imageView&quality=89',
    'http://p1.music.126.net/gYRUCGwmgVWq6a-Jmk_7lg==/109951165119273655.jpg?imageView&quality=89',
    'http://p1.music.126.net/F6XdVjLB-kNIXpLIq6Hn5g==/109951165119326163.jpg?imageView&quality=89',
    'http://p1.music.126.net/qXu16yZ5skOxVvHowtB3Tg==/109951165119336809.jpg?imageView&quality=89',
    'http://p1.music.126.net/64ZMtVQSul-RrcVs3T000g==/109951165120409374.jpg?imageView&quality=89'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: new BoxConstraints.loose(
            new Size(MediaQuery.of(context).size.width, 170.0)),
        child: Swiper(
          onTap: (int index) => {},
          itemBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.topCenter,
              child: Image.network(
                _swipers[index],
                fit: BoxFit.fill,
              ),
            );
          },
          itemCount: _swipers.length,
          autoplay: true,
          control: new SwiperControl(),
          pagination: new SwiperPagination(
            margin: new EdgeInsets.all(10.0),
          ),
          // itemWidth: MediaQuery.of(context).size.width,
          // itemHeight: 170.0,
          // layout: SwiperLayout.TINDER,
        ),
      ),
    );
  }
}
