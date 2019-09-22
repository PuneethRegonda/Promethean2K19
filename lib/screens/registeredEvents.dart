import 'dart:convert';
import 'package:flutter/material.dart';

//import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:promethean_2k19/common/alertsHelper.dart';
import 'package:promethean_2k19/data_models/event_model.dart';
import 'package:promethean_2k19/utils/urls.dart';

class RegisteredEvents extends StatefulWidget {
  final String uid;

  const RegisteredEvents(this.uid, {Key key}) : super(key: key);

  @override
  _RegisteredEventsState createState() => _RegisteredEventsState();
}

class _RegisteredEventsState extends State<RegisteredEvents> {
  List<Widget> slidingWidgets = [];

  Future<List<RegisteredEventsModel>> getregisteredEvents(String uid) async {
    List<RegisteredEventsModel> list = [];
    await http
        .get(
            "https://promethean2k19-68a29.firebaseio.com/users/$uid/registeredEvents.json")
        .then((http.Response response) {
      Map<String, dynamic> fecthedData = json.decode(response.body);
      fecthedData.forEach((String key, dynamic value) {
        Map<String, dynamic> temp = value;
        temp.forEach((String key, dynamic value) {
          list.add(RegisteredEventsModel(
              imageUrl: value["imageUrl"],
              eventName: value["eventName"],
              eventOrganisedBy: value["organizedDept"],
              registrationFee: value["fee"].toString()));
        });
      });
    });
    return list;
  }

  @override
  initState() {
    super.initState();
  }

  Widget getRegisteredList(List<RegisteredEventsModel> event) {

    return PageView(
      children: event.map((event)=>RegisteredEventCard(registeredEventsModel: event,)).toList(),
    );

    //    return ListView.builder(
//        itemCount: event.length,
//        itemBuilder: (BuildContext context, int index) {
//          print(event);
//          return RegisteredEventCard(
//            registeredEventsModel: event[index],
//          );
//        });
  }

  @override
  Widget build(BuildContext context) {
    final String uid = widget.uid;
    print("uid is $uid");
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<RegisteredEventsModel>>(
        future: getregisteredEvents(uid),
        builder: (BuildContext context,
            AsyncSnapshot<List<RegisteredEventsModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: Text("Loading...."),
              );

            case ConnectionState.done:
              if (snapshot.hasError) {
                print(snapshot.error);
                if(snapshot.error.toString().contains("NoSuchMethodError: The method 'forEach' was called on null."))
                  return Center(
                    child: Text("You have not registered to any events Yet.",style: TextStyle(fontFamily: 'QuickSand',color: Colors.black),),
                  );
                else
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
                      ),
                    ],
                  ),
                );
              } else
                return getRegisteredList(snapshot.data);
          }
          return Container();
        },
      ),
    );
  }
}

/*

imageUrl
organizingDept
EventName
Registered
amount

*/

class RegisteredEventCard extends StatelessWidget {
  final RegisteredEventsModel registeredEventsModel;

  const RegisteredEventCard({Key key, this.registeredEventsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle =
        TextStyle(fontSize: 19.0, fontFamily: 'QuickSand', color: Colors.black);
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15),
        width: MediaQuery.of(context).size.width*0.75,
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top:Radius.circular(5.0)),
                  child: FadeInImage.memoryNetwork(
                    fadeOutCurve: Curves.easeInOut,
                    image: registeredEventsModel.imageUrl,
                    placeholder: kTransparentImage,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(registeredEventsModel.eventName, style: textStyle),
                      ),
                      Spacer(),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          registeredEventsModel.eventOrganisedBy,
                          style: textStyle.copyWith(
                            fontSize: 13.0,
                          ),
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Chip(
                       backgroundColor: Color(0xFF162A49),
                        label: Text(
                      "Registered",

                      style: textStyle.copyWith(
                        color: Colors.white
                      ),
                    )),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '₹' + registeredEventsModel.registrationFee,
                      style: textStyle,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String eventName;
  final String date;
  final String fee;
  final double offset;

  const CardContent({Key key, this.eventName, this.date, this.fee, this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Transform.translate(
            offset: Offset(8 * offset, 0),
            child: Text(eventName, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 8),
          Transform.translate(
            offset: Offset(32 * offset, 0),
            child: Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer(),
          Row(
            children: <Widget>[
              Transform.translate(
                offset: Offset(48 * offset, 0),
                child: RaisedButton(
                  color: Color(0xFF162A49),
                  child: Transform.translate(
                    offset: Offset(0, 0),
                    child: Text('Registered'),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {},
                ),
              ),
              Spacer(),
              Transform.translate(
                offset: Offset(18 * offset, 0),
                child: Text(
                  "₹" + fee,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
            ],
          )
        ],
      ),
    );
  }
}

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
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
                Wrap(
                  alignment: WrapAlignment.center,
                  children: <Widget>[
                    Text(
                      alert.content,
                      style: contentTextStyle,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget getList(List<Alert> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) =>
            buildAlertCard(list[index]));
  }

  Future<List<Alert>> _future() async {
    List<Alert> listAlert = [];
    await http.get(Urls.getAlert + ".json").then((http.Response response) {
      Map<String, dynamic> fetchedData = {};
      fetchedData = json.decode(response.body);
      fetchedData.forEach((String uniqueId, dynamic v) {
        v.forEach((String k, dynamic value) {
          final Alert alert = Alert(
              title: value["title"], content: "", imageUrl: value['imageUrl']);
          listAlert.add(alert);
//          list.add(alert);
        });
        print('$fetchedData');
      });
    }); //get
    return listAlert;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future(),
        builder: (BuildContext context, AsyncSnapshot<List<Alert>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Center(
                  child: CircularProgressIndicator(
                strokeWidth: 0.9,
              ));
              // return CupertinoAlertDialog(content: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     CircularProgressIndicator(),
              //     Text("Loading...")
              //   ],
              // ),);

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
                      ),
                    ],
                  ),
                );
              }
              return getList(snapshot.data);
              break;
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
