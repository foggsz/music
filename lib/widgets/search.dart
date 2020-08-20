import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final Function(Map) suggestFn;
  final Function(String) jumpPageFn;
  final String hintText;
  final bool isSowClear;
  final String initText;

  Search(
      {this.suggestFn,
      this.hintText = '起风了',
      this.isSowClear = false,
      this.initText = '',
      this.jumpPageFn});
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  TextEditingController _controller;
  FocusNode _focusNode = FocusNode();
  void clearText() {
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initText);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          autofocus: true,
          focusNode: _focusNode,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            isDense: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: 18.0, color: Colors.black54),
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.grey[300]),
            suffixStyle: TextStyle(fontSize: 18.0, color: Colors.black54),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black26, width: 1)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black26, width: 1)),
            suffixIconConstraints: BoxConstraints(maxHeight: 18.0),
            suffixIcon: (widget.isSowClear && _controller.text.isNotEmpty)
                ? IconButton(
                    padding: EdgeInsets.zero,
                    focusNode: _focusNode,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black45,
                      size: 18.0,
                    ),
                    onPressed: () {
                      if (_controller.text.isNotEmpty)
                        setState(() {
                          _controller.text = "";
                        });
                    })
                : null,
          ),
          cursorColor: Colors.white,
          // autofocus: true,
          style: TextStyle(
            fontSize: 18.0,
          ),
          onEditingComplete: () {
            widget.jumpPageFn?.call(_controller.text);
          },
          onSubmitted: (value) {
            widget.jumpPageFn?.call(value);
          },
          onChanged: (String text) async {
            if (text.isNotEmpty) {
              Map<String, dynamic> params = {'keyword': text};
              await widget.suggestFn?.call(params);
            }
          }),
      onWillPop: () {
        _controller.clear();
        return Future.value(true);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
