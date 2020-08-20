import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music/pages/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  bool _offstage = false;
  // final containerPage = ContainerPage();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        _offstage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Offstage(
          child: HomePage(),
          offstage: !_offstage,
        ),
        Offstage(
          offstage: _offstage,
          child: Container(
            color: Colors.redAccent,
            child: Center(
              child: Text(
                '网易云，每天创造一个故事',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
            ),
          ),
        ),
        // Offstage(
        //   child: SafeArea(
        //     child: CountButton(
        //       countFinshCallback: (bool val) {
        //         this.setState(() {
        //           _offstage = val;
        //         });
        //       },
        //     ),
        //   ),
        //   offstage: _offstage,
        // )
      ],
    );
  }
}

class CountButton extends StatefulWidget {
  final countFinshCallback;
  CountButton({
    Key key,
    @required this.countFinshCallback,
  }) : super(key: key);

  _CountButton createState() => _CountButton();
}

class _CountButton extends State<CountButton> {
  int i = 5;
  String tip = '';
  Timer t;

  _CountButton() {
    this.tip = '点击关闭$i';
  }
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    t = Timer.periodic(Duration(seconds: 1), (timer) {
      i--;
      if (i <= 0) {
        widget.countFinshCallback(true);
        timer.cancel();
        return;
      }
      this.setState(() {
        this.tip = '点击关闭$i';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
        child: RaisedButton(
          child: Text(tip),
          onPressed: () {
            widget.countFinshCallback(true);
            t.cancel();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                  color: Color(0xFFFFFFFF), style: BorderStyle.none)),
        ),
        alignment: Alignment.topRight);
  }
}
