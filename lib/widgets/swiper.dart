import 'dart:async';

import 'package:flutter/material.dart';

const Duration _duration = Duration(seconds: 3);
const Duration _animateDuration = Duration(milliseconds: 300);
const Curve _animateCurve = Curves.easeIn;
const VoidCallback _voidCallback = null;
const List<Widget> _items = [Text('111'), Text('222'), Text('3333')];

class Swiper extends StatefulWidget {
  final Duration interval;
  final Duration animateDuration;
  final Curve animateCurve;
  final List<Widget> items;
  final VoidCallback onPageTapFn;
  final bool isLoop;

  Swiper(
      {this.interval = _duration,
      this.animateDuration = _animateDuration,
      this.animateCurve = _animateCurve,
      this.onPageTapFn = _voidCallback,
      this.items = _items,
      this.isLoop = false});

  @override
  State<StatefulWidget> createState() {
    return _Swiper();
  }
}

class _Swiper extends State<Swiper> {
  PageController _controller =
      PageController(initialPage: 0, viewportFraction: 1, keepPage: true);
  Timer _timer;
  // int _curPage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (timer) {
      scrollSwiper();
    });
  }

  scrollSwiper() {
    int page = _controller.page.round();
    if (page + 1 == widget.items.length) {
      _controller.jumpToPage(0);
    } else {
      _controller.animateToPage(page + 1,
          duration: widget.animateDuration, curve: widget.animateCurve);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.custom(
          controller: _controller,
          physics: PageScrollPhysics(),
          onPageChanged: (int index) {
            if (index > _controller.page) {
              print('$index,  ${_controller.page}');
            }
          },
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return widget.items[index];
            },
            childCount: widget.items.length,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
