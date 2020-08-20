import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 5.0,),
          Text('加载中...')
        ],
      )
    );
  }
  
}