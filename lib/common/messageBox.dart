import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class LoadingMessageBox {
  BuildContext buildContext;
  String message = " ", title = " ";

  LoadingMessageBox(this.buildContext, this.message, this.title);

  void show() {
    _showFetchProfileDialog(this.message);
  }

  Future _showFetchProfileDialog(String message) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: SizedBox(
            height: 45.0,
            child: Center(
              child: Row(
                children: <Widget>[
                  CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                  Expanded(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return null;
  }
}

class MessageBox {
  BuildContext buildContext;
  String message = " ", title = " ";
  bool isSend;
  MessageBox(this.buildContext, this.message, this.title,{this.isSend=false});

  show() {
    _showErrorDialog();
  }

  Future _showErrorDialog() {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            '$title',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ),
            isSend?FlatButton(
              child: Text('Check Event',style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ):Container(),
            
          ],
          content: SizedBox(
            height: 45.0,
            child: Center(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 11.0),
                    ),
                  ),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
          ),
        );
      },
    );
    return null;
  }
}
