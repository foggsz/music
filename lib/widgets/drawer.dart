import 'package:flutter/material.dart';
import 'package:music/models/user.dart';
import 'package:music/models/slideDraw.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawer createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {
  User user = User.fromJson(
      {'accountName': '李白', 'avatar': 'assets/avatar.jpg', 'email': '22222'});

  Widget getDivider() {
    return Divider(
      color: Colors.grey[400],
      indent: 20.0,
      endIndent: 20.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                    leading: CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage(user.avatar),
                        backgroundColor: Colors.transparent),
                    title: Text(
                      user.accountName,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: SizedBox(
                      child: FlatButton(
                          onPressed: () {},
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.border_color, size: 12.0),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text('签到', style: TextStyle(fontSize: 12.0)),
                            ],
                          )),
                      height: 25.0,
                      width: 72.0,
                    )),
                SlideCenter.firstWidget(),
                getDivider(),
                SlideCenter.secondWidget(),
                getDivider(),
                SlideCenter.thridWidget(),
                SlideCenter.thridWidget(),
                getDivider(),
                SlideCenter.fourWidget(),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                getDivider(),
                Container(
                  child: SlideCenter.bottomWidget(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
