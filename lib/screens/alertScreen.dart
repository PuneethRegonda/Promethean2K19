import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/common/alertsHelper.dart';
import 'package:http/http.dart' as http;
import 'package:promethean_2k19/utils/urls.dart';


class AlertScreen extends StatefulWidget {
  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  TextStyle titleTextStyle = new TextStyle(
      fontFamily: 'QuickSand',
      fontSize: 17.0,
      fontWeight: FontWeight.w500,
      color: Colors.black);
  TextStyle contentTextStyle = new TextStyle(
      fontFamily: 'QuickSand', fontSize: 13.0, color: Colors.black);



  buildAlertCard(Alert alert) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
//          height: MediaQuery.of(context).size.height * 0.33,
          child: Card(
            child: Column(
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: FadeInImage.memoryNetwork(

                      fadeOutCurve: Curves.easeInOutSine,
                      placeholder: kTransparentImage,
                      image: alert.imageUrl,
                      fit: BoxFit.fill,
                    )),
                Text(
                  alert.title,
                  style: titleTextStyle,
                ),
                alert.content.isEmpty?Container():ExpansionTile(title: Text(""),children: <Widget>[
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Text(
                        alert.content,
                        style: contentTextStyle,
                      ),
                    ],
                  )
                ],)
              ],
            ),
          )),
    );
  }

  Widget getList(List<Alert> list) {
    return list.isEmpty?Center(child: Text("No ALert Currenting",style: TextStyle(fontFamily: 'QuickSand',color: Colors.black),),):ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) =>
            buildAlertCard(list[index]));
  }



  Future<List<Alert>> _future() async {
    List<Alert> listAlert= [];
    await http.get(Urls.getAlert + ".json").then((http.Response response) {
      Map<String, dynamic> fetchedData = {};
      fetchedData = json.decode(response.body);
      fetchedData.forEach((String uniqueId, dynamic v) {
        v.forEach((String k, dynamic value) {
          final Alert alert = Alert(title:value["title"],content: value["content"],imageUrl: value['imageUrl']);
          listAlert.add(alert);
//          list.add(alert);
        });
        print('$fetchedData');
      });
    }
    ); //get
    return listAlert;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: _future(),
          builder: (BuildContext context, AsyncSnapshot<List<Alert>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
               return Center(child: CircularProgressIndicator(strokeWidth: 0.9,));


                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/tryAgain.png"),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Something went Wrong !!"),
                              ),
                              RaisedButton.icon(
                                color: Colors.blue,
                                icon: Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {});
                                },
                                label: Text(
                                  "Try Again",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),                    ],
                    ),
                  );
                }
                return getList(snapshot.data);
                break;
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
