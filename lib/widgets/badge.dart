import 'package:flutter/material.dart';

class Badge extends StatefulWidget {
  final int num;
  final Widget widget;
  Badge({this.num = 0, this.widget});

  @override
  _Badge createState() => _Badge();
}

class _Badge extends State<Badge> {
  String num ='';
  @override
  void initState() {
    super.initState();
    if(widget.num>0 && widget.num<99){
      num = widget.num.toString();
    }else if(widget.num>99){
      num = '99+';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[ 
        Container(
          child:widget.widget,
          padding:EdgeInsetsDirectional.only(top:10.0, end:15.0)
        ),
        (num.isNotEmpty)?
        Positioned(
          right: 0,
          child: 
          new Container(
              padding: EdgeInsets.all(2.0),
              decoration:BoxDecoration(
                color: Colors.redAccent, 
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(minHeight: 20.0, minWidth: 20.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(num,style: TextStyle(color:Colors.white, fontSize: 12.0))
                ],
              )
            ,
          ),
        ):Container()
    ]);
  }
}
