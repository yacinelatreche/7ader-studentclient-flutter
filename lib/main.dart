import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:qr_utils/qr_utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

_makePostRequest() async {
  // set up POST request arguments
  String url = 'https://jsonplaceholder.typicode.com/posts';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  // make POST request
  Response response = await post(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}


class _MyAppState extends State<MyApp> {
  String _content = 'Undefined';
  String _qrBase64Content = 'Undefined';
  Image _qrImg;

  TextEditingController _qrTextEditingController = TextEditingController();

  String _error;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xFF019592),
          title: const Text('7ADER - حاضر'),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Scan QR: ",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                Text(_content != null ? _content : 'Undefined'),
                SizedBox(
                  height: 24.0,
                ),
                FlatButton(
                  color: Colors.blue,
                  onPressed: _scanQR,
                  child: Text(
                    'Scan QR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),

              ],
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: _scanQR,
          label: Text('Scan'),
          icon: Icon(Icons.camera_alt),
          backgroundColor: Color(0xFF019592),
        ),
      ),
    );
  }

  void _scanQR() async {
    String result;
    try {
      result = await QrUtils.scanQR;
    } on PlatformException {
      result = 'Process Failed!';
    }

    setState(() {
      _content = result;
    });
  }
}
