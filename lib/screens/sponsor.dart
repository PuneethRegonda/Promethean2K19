import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/common/alertsHelper.dart';
import 'package:http/http.dart' as http;
import 'package:promethean_2k19/utils/urls.dart';

class Sponser{
  final String name;
  final String imageUrl;
  Sponser({this.name, this.imageUrl});
}


class SponserScreen extends StatefulWidget {
  @override
  _SponserScreenState createState() => _SponserScreenState();
}

class _SponserScreenState extends State<SponserScreen> {
  TextStyle titleTextStyle = new TextStyle(
      fontFamily: 'QuickSand',
      fontSize: 17.0,
      fontWeight: FontWeight.w500,
      color: Colors.black);
  TextStyle contentTextStyle = new TextStyle(
      fontFamily: 'QuickSand', fontSize: 13.0, color: Colors.black);


  buildSponserCard(Sponser sponser) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
//          height: MediaQuery.of(context).size.height * 0.33,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      image: sponser.imageUrl,
                      fit: BoxFit.fill,
                    )),
                Text(
                  sponser.name,
                  style: titleTextStyle,
                ),
              ],
            ),
          )),
    );
  }

  Widget getList(List<Sponser> sponser ) {
    return ListView.builder(
        itemCount: sponser.length,
        itemBuilder: (BuildContext context, int index) =>
            buildSponserCard(sponser[index]));
  }



  Future<List<Sponser>> _future() async {
    List<Sponser> listAlert= [];
    await http.get(Urls.getSponser + ".json").then((http.Response response) {
      Map<String, dynamic> fetchedData = {};
      print("entered Here");
      print(json.decode(response.body));
      fetchedData = json.decode(response.body);
      fetchedData.forEach((String uniqueId, dynamic v) {
        v.forEach((String k, dynamic value) {
          final Sponser sponser = Sponser(name:value["name"],imageUrl: value['imageUrl']);
          listAlert.add(sponser);
        });
        print('$fetchedData');
      });
    }
    ); //get
    return listAlert;
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot<List<Sponser>> snapshot) {
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
              print("sponsor ${snapshot.data.length}");
              return getList(snapshot.data);
              break;
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
