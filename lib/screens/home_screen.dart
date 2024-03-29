import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:promethean_2k19/carousel_slider.dart';
import 'package:promethean_2k19/common/helper.dart';
import 'package:promethean_2k19/common/notificationsDialog.dart';
import 'package:promethean_2k19/data_models/notificationMessages.dart';
import 'package:promethean_2k19/screens/aboutUs.dart';
import 'package:promethean_2k19/screens/alertScreen.dart';
import 'package:promethean_2k19/screens/registeredEvents.dart';
import 'package:promethean_2k19/screens/registration_screen.dart';
import 'package:promethean_2k19/screens/seeAll_events.dart';
import 'package:promethean_2k19/screens/user_profile.dart';
import 'package:promethean_2k19/utils/bottomNav.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const HomeScreen({Key key, this.isFirstLaunch=false}) : super(key: key);
  @override
  _HomeScreenState createState() {
    print("in homescreen $isFirstLaunch");
    return _HomeScreenState();}
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Widget body = Container();
  int currentIndex = 0;
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Press again to exit App"),
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  notificationHandler(notification) {
    if (notification['title'] == 'event_notification') {
      EventNotification eventNotification = new EventNotification(
          title: notification['eventName'],
          deptName: notification['dept'],
          imageUrl: notification['imageUrl']);
      NotificationsDialogs(context, eventnotification: eventNotification)
          .showEventDialog();
    } else if (notification['title'] == 'winner_notification') {
      WinnerNotification winnerNotification = new WinnerNotification(
          college: notification['college'],
          eventName: notification['eventName'],
          eventOrganized: notification['eventOrganized'],
          tilte: notification['title'],
          winnerDept: notification['winnerDept'],
          winnerName: notification['winnerName']);
      NotificationsDialogs(context, winnernotification: winnerNotification)
          .showWinnerDialog();
    }
  }

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        setState(() {
//          messages.add(Message(
//              title: notification['title'], body: notification['body']));
//            notificationHandler(notification);

//          showDialog(
//              context: context,
//              builder: (BuildContext context) {
//                return AlertDialog(
//                  title: Text("Title"),
//                  content: Text("hello Wrold"),
//                  actions: <Widget>[
//                    FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                        child: Text("ok"))
//                  ],
//                );
//              });
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
//          notificationHandler(notification);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        setState(() {
//          notificationHandler(notification);
        });
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    print("in homeScreen");
    final _size = MediaQuery.of(buildContext).size;
    final List<Widget> chliderens = [
      HomeScreenBody(deviceSize: _size),
      RegisteredEvents(Helper.authenticatedUser.uid),
      AlertScreen(),
      AboutCollege(deviceSize: _size,isFirstLaunch: widget.isFirstLaunch,),
    ];

    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: false,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
              width: 130.0,
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              width: 170.0,
              icon: Icon(Icons.event_available),
              title: Text(
                'Registered Events',
                style: TextStyle(fontSize: 13.0),
              ),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              width: 130.0,
              icon: Icon(Icons.notifications),
              title: Text('Alerts'),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              width: 130.0,
              icon: Icon(Icons.error_outline),
              title: Text('About Us'),
              activeColor: Colors.red,
              inactiveColor: Colors.black),
        ],
      ),
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(buildContext).push(CupertinoPageRoute(
                  builder: (BuildContext context) => UserProfile()));
            },
            icon: Icon(Icons.person, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 3.0,
        title: new Text(
          "Promethean2k19",
          style: new TextStyle(
            color: Colors.black,
            fontFamily: 'bebas-neue',
            fontSize: 25.0,
          ),
        ),
      ),
      body: WillPopScope(onWillPop: onWillPop, child: chliderens[currentIndex]),
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  final Size deviceSize;

  const HomeScreenBody({Key key, this.deviceSize}) : super(key: key);

  @override
  _HomeScreenBodyState createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  List<Widget> mainScreenwidgets = [];
  TextStyle labelStyle;
  List<String> l = [];
  List<String> technical = [];

  // List<String> galleryImages=[];
  List<Widget> galleryWidgets = [];

  ScrollController scrollController = new ScrollController();

  Future<List<Widget>> galleryNetworkImages() async {
    await http
        .get("https://promethean2k19-68a29.firebaseio.com/gallery_images.json")
        .then((http.Response response) {
      Map<String, dynamic> map = json.decode(response.body);
      // print("json body gallery: $map");
      map.forEach((String uniqueId, dynamic value) {
        // print(value);
        // print(value);
        galleryWidgets.add(galleryNetworkCards(imageurl: value));
      });
    });
    return galleryWidgets;
  }

  Future<List<String>> _getCentralDepts(String title) async {
    print("Inside _getCentralDept $title");
    List<String> temp = [];
    await http
        .get(
            "https://promethean2k19-68a29.firebaseio.com/centralEventDept/$title.json")
        .then((http.Response response) {
      Map<String, dynamic> map = json.decode(response.body);
      map.forEach((String uniqueid, dynamic value) {
        temp.add(value);
      });
    });
    print("after Map temp");
    return temp;
  }

  callSetState() {
    setState(() {});
  }

  @override
  void initState() {
    galleryWidgets.add(galleryCards(imageurl: "assets/bvrit_vishu.png"));
    galleryWidgets.add(
        galleryCards(imageurl: "assets/logo.jpg", color: Color(0xFFf7f7f7)));
    galleryWidgets.add(galleryCards(imageurl: "assets/bvrit.jpg"));

    labelStyle = new TextStyle(
      fontSize: widget.deviceSize.width * 0.049,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    mainScreenwidgets.add(slider());
    mainScreenwidgets.add(_getHeader(
        widget.deviceSize.width, "Central Events", labelStyle, false, () {}));
    mainScreenwidgets.add(_getFeaturedEvents(widget.deviceSize.width));
    mainScreenwidgets.add(_getHeader(
        widget.deviceSize.width, "Departments", labelStyle, false, () {}));
    // mainScreenwidgets.add(_getDeptList());
    super.initState();
  }

  Widget getDepartments(String title) {
    print(title);
    return Container(
      margin: EdgeInsets.all(2.0),
      child: Card(
        child: Container(
          child: Center(
            child: Text(title),
          ),
          width: 50.0,
          height: 50.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _getHeader(double width, String label, TextStyle labelStyle,
      bool seeall, Function onpressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
          child: Row(
            children: <Widget>[
              Text(label, style: labelStyle),
              Expanded(
                child: Container(),
              ),
              seeall
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: CupertinoButton(
                        minSize: 20.0,
                        onPressed: onpressed,
                        // color: Colors.tran,
                        child: Text(
                          "See all",
                          style: labelStyle.copyWith(
                              color: Colors.lightBlue, fontSize: width * 0.038),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  slider() {
    return FutureBuilder<List<Widget>>(
      future: galleryNetworkImages(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return CarouselSlider(
                autoPlayCurve: Curves.easeInOutCubic,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: widget.deviceSize.aspectRatio * 3.5,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                items: galleryWidgets);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return CarouselSlider(
                  autoPlayCurve: Curves.easeInOutCubic,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  aspectRatio: widget.deviceSize.aspectRatio * 3.5,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  items: galleryWidgets);
            }
            return CarouselSlider(
                autoPlayCurve: Curves.easeInOutCubic,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                aspectRatio: widget.deviceSize.aspectRatio * 3.5,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                items: galleryWidgets);
        }
        return Container();
      },
    );
  }

  galleryNetworkCards({@required String imageurl}) {
    return Container(
      padding: EdgeInsets.only(top: 13.0, right: 2.0, left: 2.0, bottom: 5.0),
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
         color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: Card(
          elevation: 5.0,
          child: networkCard(imageurl: imageurl)),
    );
  }

  Widget galleryCards({@required String imageurl, Color color}) {
    return Container(
      padding: EdgeInsets.only(top: 13.0, right: 2.0, left: 2.0, bottom: 5.0),
      height: 100.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: Card(
        color: color == null ? Colors.white : color,
        elevation: 5.0,
        child: Image.asset(
          imageurl,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  List<String> assetsbranches = [
    'assets/bme.png',
    'assets/che.png',
    'assets/civil.png',

    'assets/cse.jpg',
    'assets/eee.png',
    'assets/ece.png',
    
    'assets/it.jpg',
    'assets/mech.png',
    'assets/mba.jpg',

    'assets/pharma.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: mainScreenwidgets.length + 10,
        itemBuilder: (BuildContext context, int index) {
          if (index >= mainScreenwidgets.length) {
            List<String> tempList = [
              "Biomedical Engineering",
              "Chemical Engineering",
              "Civil Engineering",
              "Computer Science and Engineering",
              "Electrical and Electronic Engineering",
              "Electronics and Communication Engineering",
              "Information Technology",
              "Mechanical Engineering",
              "MBA",
              "Pharmaceutical Engineering",
            ];
            print(tempList[index - mainScreenwidgets.length].length);
            return buildBranchCard(tempList, index);
          }
          return mainScreenwidgets[index];
        });
  }

  String getBranchShort(String branch) {
    if (branch.toLowerCase() == "biomedical engineering") {
      return "BME";
    } else if (branch.toLowerCase() == "chemical engineering") {
      return "CHEM";
    } else if (branch.toLowerCase() == "civil engineering") {
      return "CIVIL";
    } else if (branch.toLowerCase() == "computer science and engineering") {
      return "CSE";
    } else if (branch.toLowerCase() ==
        "electrical and electronic engineering") {
      return "EEE";
    } else if (branch.toLowerCase() ==
        "electronics and communication engineering") {
      return "ECE";
    } else if (branch.toLowerCase() == "information technology") {
      return "IT";
    } else if (branch.toLowerCase() == "mechanical engineering") {
      return "MECH";
    } else if (branch.toLowerCase() == "mba") {
      return "MBA";
    } else if (branch.toLowerCase() == "pharmaceutical engineering") {
      return "PHE";
    }

    return "NOT THERE";
  }

  Widget buildBranchCard(List<String> tempList, int index) {
    TextStyle textStyle = TextStyle(
        fontFamily: 'QuickSand',
        fontSize: 22 % widget.deviceSize.width * 0.65,
        color: Colors.white);
    // TextStyle textStyle = const TextStyle(fontFamily: 'QuickSand',fontSize: 20.0,color: Colors.white);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: InkWell(
        onTap: () {
          print(tempList[index - mainScreenwidgets.length]);
          String temp =
              getBranchShort(tempList[index - mainScreenwidgets.length]);
          print(temp);
          Navigator.push(context,
              CupertinoPageRoute(builder: (BuildContext context) {
            return AllEventScreen(
              deptName: temp,
            );
          }));
        },
        child: Card(
          color: Colors.transparent,
          elevation: 5.0,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  image: DecorationImage(
                    
                    fit: BoxFit.cover,
                    image: AssetImage(assetsbranches[index - mainScreenwidgets.length])),
                  // color: Colors.blue.withOpacity(0.2),
                  gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ])
                ),

                height: widget.deviceSize.height * 0.3,

                // margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
              ),
              Positioned(
                  bottom: 10.0,
                  left: 20.0,
                  child: Text(
                    tempList[index - mainScreenwidgets.length],
                    style: textStyle,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget networkCard({String imageurl}) {
    print("printed tech : in netwrok $technical");
    return CachedNetworkImage(
        imageUrl: imageurl,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        placeholder: (context, url) => Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
        errorWidget: (context, url, error) {
          print("error in network card $error\n with url $url");
          return Container(child: Center(child: CircularProgressIndicator()));
        });
  }

  List<String> eventList = [
    "Poster Presentation",
    "Project Expo",
    "Paper Presentation",
    "Ideation",
  ];
    List<String> eventAsset = [
    "assets/posterPresentation.jpg",
    "assets/ProjectExpo.jpg",
    "assets/paperPresentation.jpg",
    "assets/ideation.jpg",
    ];

  Widget _getFeaturedEvents(double width) {
    int index = 0;
    return Column(
        children: List<String>(2).map<Widget>((_) {
      print("index is $index");
      print("index is $index");
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List(2).map((T) {
            return _buildCustomeCard(
                width, eventAsset[index], eventList[index++]);
          }).toList());
    }).toList());
  }

  Widget _buildCustomeCard(double width, String imageAsset, String title) {
    return Tooltip(
      message: title,
      child: InkWell(
        onTap: () {
//          print("taped featured_events/$title");
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return FutureBuilder<List<String>>(
                    future: _getCentralDepts(title),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<String>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
//                          print(snapshot.data);
//                          print("While Loading..");
                          return Center(
                            child: Container(
                              color: Colors.grey.withOpacity(0.5),
                              child: CupertinoAlertDialog(
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
                                            "Loading..",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return AlertDialog(
                              content: Text(
                                "Something Went Worng. Please Try Again",
                                style: TextStyle(
                                  fontFamily: 'QuickSand',
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"),
                                ),
                              ],
                            );
                          } else {
                            print("After Completion of Builder");
                            print(snapshot.data);
                            return AlertDialog(
                              content:
                                  MultiSelectChip(reportList: snapshot.data),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    String dep =
                                        _MultiSelectChipState.getChoice();
                                    print(dep.length);
                                    if (dep.length != 0) {
                                      Navigator.of(context).pushReplacement(
                                        CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              RegistrationScreen(
                                            organizingDepartment: dep,
                                            eventName: title.trim(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Continue"),
                                ),
                              ],
                            );
                          }
                      }
                      return Container();
                    });
              });
          print(title.trim());
        },
        child: Card(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Card(
                  elevation: 0.0,
                  child: Container(
                    width: width * 0.41,
                    height: width * 0.38,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(imageAsset), fit: BoxFit.fill),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                            ])),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              Positioned(
                bottom: -5.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Card(
                    elevation: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      width: width * 0.47,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(title,
                              softWrap: false,
                              style: labelStyle.copyWith(
                                fontSize: width * 0.04,
                                fontFamily: 'bebas-neue',
                                letterSpacing: 1.5,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;

  MultiSelectChip({this.reportList});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  static String getChoice() {
    return _MultiSelectChipState.selectedChoice;
  }

  static String selectedChoice = "";

  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

/*

Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\firebase_core-0.4.0+3\android\src\main\java\io\flutter\plugins\firebase\core\FirebaseCorePlugin.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\firebase_messaging-5.1.5\android\src\main\java\io\flutter\plugins\firebasemessaging\FlutterFirebaseMessagingService.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\firebase_messaging-5.1.5\android\src\main\java\io\flutter\plugins\firebasemessaging\FirebaseMessagingPlugin.java uses unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
Note: Some input files use unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\url_launcher-5.1.2\android\src\main\java\io\flutter\plugins\urllauncher\WebViewActivity.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.

*/
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:promethean_2k19/carousel_slider.dart';
// import 'package:promethean_2k19/common/helper.dart';
// import 'package:promethean_2k19/common/notificationsDialog.dart';
// import 'package:promethean_2k19/data_models/notificationMessages.dart';
// import 'package:promethean_2k19/screens/aboutUs.dart';
// import 'package:promethean_2k19/screens/alertScreen.dart';
// import 'package:promethean_2k19/screens/registeredEvents.dart';
// import 'package:promethean_2k19/screens/registration_screen.dart';
// import 'package:promethean_2k19/screens/seeAll_events.dart';
// import 'package:promethean_2k19/screens/user_profile.dart';
// import 'package:promethean_2k19/utils/bottomNav.dart';

// import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   Widget body = Container();
//   int currentIndex = 0;
//   DateTime currentBackPressTime;

//   Future<bool> onWillPop() {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       scaffoldKey.currentState.showSnackBar(SnackBar(
//         content: Text("Press again to exit App"),
//       ));
//       return Future.value(false);
//     }
//     return Future.value(true);
//   }

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final List<Message> messages = [];

//   notificationHandler(notification) {
//     if (notification['title'] == 'event_notification') {
//       EventNotification eventNotification = new EventNotification(
//           title: notification['eventName'],
//           deptName: notification['dept'],
//           imageUrl: notification['imageUrl']);
//       NotificationsDialogs(context, eventnotification: eventNotification)
//           .showEventDialog();
//     } else if (notification['title'] == 'winner_notification') {
//       WinnerNotification winnerNotification = new WinnerNotification(
//           college: notification['college'],
//           eventName: notification['eventName'],
//           eventOrganized: notification['eventOrganized'],
//           tilte: notification['title'],
//           winnerDept: notification['winnerDept'],
//           winnerName: notification['winnerName']);
//       NotificationsDialogs(context, winnernotification: winnerNotification)
//           .showWinnerDialog();
//     }
//   }

//   @override
//   void initState() {
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         final notification = message['data'];
//         setState(() {
// //          messages.add(Message(
// //              title: notification['title'], body: notification['body']));
// //            notificationHandler(notification);
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: Text("title"),
//                   content: Text("hello Wrold"),
//                   actions: <Widget>[
//                     FlatButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: Text("ok"))
//                   ],
//                 );
//               });
//         });
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         final notification = message['data'];
//         setState(() {
//           notificationHandler(notification);
//         });
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         final notification = message['data'];

//         setState(() {
//           notificationHandler(notification);
//         });
//       },
//     );

//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext buildContext) {
//     print("in homeScreen");
//     final _size = MediaQuery.of(buildContext).size;
//     final List<Widget> chliderens = [
//       HomeScreenBody(deviceSize: _size),
//       RegisteredEvents(Helper.authenticatedUser.uid),
//       AlertScreen(),
//       AboutCollege(deviceSize: _size),
//     ];

//     return Scaffold(
//       key: scaffoldKey,
//       bottomNavigationBar: BottomNavyBar(
//         selectedIndex: currentIndex,
//         showElevation: false,
//         onItemSelected: (index) => setState(() {
//           currentIndex = index;
//         }),
//         items: [
//           BottomNavyBarItem(
//               width: 130.0,
//               icon: Icon(Icons.home),
//               title: Text('Home'),
//               activeColor: Colors.red,
//               inactiveColor: Colors.black),
//           BottomNavyBarItem(
//               width: 170.0,
//               icon: Icon(Icons.event_available),
//               title: Text(
//                 'Registered Events',
//                 style: TextStyle(fontSize: 13.0),
//               ),
//               activeColor: Colors.red,
//               inactiveColor: Colors.black),
//           BottomNavyBarItem(
//               width: 130.0,
//               icon: Icon(Icons.people),
//               title: Text('Alerts'),
//               activeColor: Colors.red,
//               inactiveColor: Colors.black),
//           BottomNavyBarItem(
//               width: 130.0,
//               icon: Icon(Icons.error_outline),
//               title: Text('About Us'),
//               activeColor: Colors.red,
//               inactiveColor: Colors.black),
//         ],
//       ),
//       appBar: new AppBar(
//         automaticallyImplyLeading: false,
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               Navigator.of(buildContext).push(CupertinoPageRoute(
//                   builder: (BuildContext context) => UserProfile()));
//             },
//             icon: Icon(Icons.person, color: Colors.black),
//           ),
//         ],
//         backgroundColor: Colors.white,
//         elevation: 3.0,
//         title: new Text(
//           "Promethean2k19",
//           style: new TextStyle(
//             color: Colors.black,
//             fontFamily: 'bebas-neue',
//             fontSize: 25.0,
//           ),
//         ),
//       ),
//       body: WillPopScope(onWillPop: onWillPop, child: chliderens[currentIndex]),
//     );
//   }
// }

// class HomeScreenBody extends StatefulWidget {
//   final Size deviceSize;

//   const HomeScreenBody({Key key, this.deviceSize}) : super(key: key);

//   @override
//   _HomeScreenBodyState createState() => _HomeScreenBodyState();
// }

// class _HomeScreenBodyState extends State<HomeScreenBody> {
//   List<Widget> mainScreenwidgets = [];
//   TextStyle labelStyle;
//   List<String> l = [];
//   List<String> technical = [];

//   // List<String> galleryImages=[];
//   List<Widget> galleryWidgets = [];

//   ScrollController scrollController = new ScrollController();

//   Future<List<Widget>> galleryNetworkImages() async {
//     await http
//         .get("https://promethean2k19-68a29.firebaseio.com/gallery_images.json")
//         .then((http.Response response) {
//       Map<String, dynamic> map = json.decode(response.body);
//       // print("json body gallery: $map");
//       map.forEach((String uniqueId, dynamic value) {
//         // print(value);
//         // print(value);
//         galleryWidgets.add(galleryNetworkCards(imageurl: value));
//       });
//     });
//     return galleryWidgets;
//   }

//   Future<List<String>> _getCentralDepts(String title) async {
//     print("Inside _getCentralDept $title");
//     List<String> temp = [];
//     await http
//         .get(
//             "https://promethean2k19-68a29.firebaseio.com/centralEventDept/$title.json")
//         .then((http.Response response) {
//       Map<String, dynamic> map = json.decode(response.body);
//       map.forEach((String uniqueid, dynamic value) {
//         temp.add(value);
//       });
//     });
//     print("after Map temp");
//     return temp;
//   }

//   callSetState() {
//     setState(() {});
//   }

//   @override
//   void initState() {
//     galleryWidgets.add(galleryCards(imageurl: "assets/bvrit_vishu.png"));
//     galleryWidgets.add(
//         galleryCards(imageurl: "assets/logo.jpg", color: Color(0xFFf7f7f7)));
//     galleryWidgets.add(galleryCards(imageurl: "assets/bvrit.jpg"));

//     labelStyle = new TextStyle(
//       fontSize: widget.deviceSize.width * 0.049,
//       fontWeight: FontWeight.w600,
//       color: Colors.black,
//     );

//     mainScreenwidgets.add(slider());
//     mainScreenwidgets.add(_getHeader(
//         widget.deviceSize.width, "Central Events", labelStyle, false, () {}));
//     mainScreenwidgets.add(_getFeaturedEvents(widget.deviceSize.width));
//     mainScreenwidgets.add(_getHeader(
//         widget.deviceSize.width, "Departments", labelStyle, false, () {}));
//     // mainScreenwidgets.add(_getDeptList());
//     super.initState();
//   }

//   Widget getDepartments(String title) {
//     print(title);
//     return Container(
//       margin: EdgeInsets.all(2.0),
//       child: Card(
//         child: Container(
//           child: Center(
//             child: Text(title),
//           ),
//           width: 50.0,
//           height: 50.0,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }

//   Widget _getHeader(double width, String label, TextStyle labelStyle,
//       bool seeall, Function onpressed) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(top: 8.0, left: 8.0),
//           child: Row(
//             children: <Widget>[
//               Text(label, style: labelStyle),
//               Expanded(
//                 child: Container(),
//               ),
//               seeall
//                   ? Padding(
//                       padding: const EdgeInsets.only(right: 5.0),
//                       child: CupertinoButton(
//                         minSize: 20.0,
//                         onPressed: onpressed,
//                         // color: Colors.tran,
//                         child: Text(
//                           "See all",
//                           style: labelStyle.copyWith(
//                               color: Colors.lightBlue, fontSize: width * 0.038),
//                         ),
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   slider() {
//     return FutureBuilder<List<Widget>>(
//       future: galleryNetworkImages(),
//       builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//           case ConnectionState.waiting:
//           case ConnectionState.active:
//             return CarouselSlider(
//                 autoPlayCurve: Curves.easeInOutCubic,
//                 enlargeCenterPage: true,
//                 enableInfiniteScroll: true,
//                 aspectRatio: widget.deviceSize.aspectRatio * 3.5,
//                 scrollDirection: Axis.horizontal,
//                 autoPlay: true,
//                 autoPlayAnimationDuration: const Duration(seconds: 2),
//                 items: galleryWidgets);
//           case ConnectionState.done:
//             if (snapshot.hasError) {
//               return CarouselSlider(
//                   autoPlayCurve: Curves.easeInOutCubic,
//                   enlargeCenterPage: true,
//                   enableInfiniteScroll: true,
//                   aspectRatio: widget.deviceSize.aspectRatio * 3.5,
//                   scrollDirection: Axis.horizontal,
//                   autoPlay: true,
//                   autoPlayAnimationDuration: const Duration(seconds: 2),
//                   items: galleryWidgets);
//             }
//             return CarouselSlider(
//                 autoPlayCurve: Curves.easeInOutCubic,
//                 enlargeCenterPage: true,
//                 enableInfiniteScroll: true,
//                 aspectRatio: widget.deviceSize.aspectRatio * 3.5,
//                 scrollDirection: Axis.horizontal,
//                 autoPlay: true,
//                 autoPlayAnimationDuration: const Duration(seconds: 2),
//                 items: galleryWidgets);
//         }
//         return Container();
//       },
//     );
//   }

//   galleryNetworkCards({@required String imageurl}) {
//     return Container(
//       padding: EdgeInsets.only(top: 13.0, right: 2.0, left: 2.0, bottom: 5.0),
//       height: 100.0,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         // color: Colors.red,
//         borderRadius: new BorderRadius.circular(20.0),
//       ),
//       child: ClipRRect(
//         borderRadius: new BorderRadius.circular(20.0),
//         child: Card(elevation: 5.0, child: networkCard(imageurl: imageurl)),
//       ),
//     );
//   }

//   Widget galleryCards({@required String imageurl, Color color}) {
//     return Container(
//       padding: EdgeInsets.only(top: 13.0, right: 2.0, left: 2.0, bottom: 5.0),
//       height: 100.0,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: new BorderRadius.circular(20.0),
//       ),
//       child: Card(
//         color: color == null ? Colors.white : color,
//         elevation: 5.0,
//         child: ClipRRect(
//           borderRadius: new BorderRadius.circular(20.0),
//           child: Image.asset(
//             imageurl,
//             fit: BoxFit.fitHeight,
//           ),
//         ),
//       ),
//     );
//   }

//   List<Gradient> branchgra = [
//     //bio
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFFfdcd21),
//           Color(0xFFf69e01),
//         ]),
//     //chem
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFFd0be92),
//           Color(0xFF8f1d1b),
//         ]),
//    //civil
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFF3bb0d8),
//           Color(0xFF47cdb0),
//         ]),
//     //cse
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFF045da6),
//           Color(0xFF012770),
//         ]),
//     //eee
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFF0953a1),
//           Color(0xFFdf3026),
//         ]),
//     //ece
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFFccb67b),
//           Color(0xFF575a5c),
//         ]),
//     //IT
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFF0164a4),
//           Color(0xFF0064a4),
//         ]),
//         //mech
//     LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFFe1403d),
//           Color(0xFFc29015),
//         ]),
//      LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: <Color>[
//           Color(0xFFe1403d),
//           Color(0xFF5a0a8e),
//         ]),
//         //pharm

//   ];
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         controller: scrollController,
//         physics: BouncingScrollPhysics(),
//         itemCount: mainScreenwidgets.length + 9,
//         itemBuilder: (BuildContext context, int index) {
//           if (index >= mainScreenwidgets.length) {
//             List<String> tempList = [
//               "Biomedical Engineering",
//               "Chemical Engineering",
//               "Civil Engineering",
//               "Computer Science and Engineering",
//               "Electrical and Electronic Engineering",
//               "Electronics and Communication Engineering",
//               "Information Technology",
//               "Mechanical Engineering",
//               "Pharmaceutical Engineering",
//             ];
//             print(tempList[index - mainScreenwidgets.length].length);
//             return buildBranchCard(tempList, index);
//           }
//           return mainScreenwidgets[index];
//         });
//   }

//   String getBranchShort(String branch) {
//     if (branch.toLowerCase() == "biomedical engineering") {
//       return "BME";
//     } else if (branch.toLowerCase() == "chemical engineering") {
//       return "CHEM";
//     } else if (branch.toLowerCase() == "civil engineering") {
//       return "CIVIL";
//     } else if (branch.toLowerCase() == "computer science and engineering") {
//       return "CSE";
//     } else if (branch.toLowerCase() ==
//         "electrical and electronic engineering") {
//       return "EEE";
//     } else if (branch.toLowerCase() ==
//         "electronics and communication engineering") {
//       return "ECE";
//     } else if (branch.toLowerCase() == "information technology") {
//       return "IT";
//     } else if (branch.toLowerCase() == "mechanical engineering") {
//       return "MECH";
//     } else if (branch.toLowerCase() == "pharmaceutical engineering") {
//       return "PHE";
//     }
//     return "NOT THERE";
//   }

//   Widget buildBranchCard(List<String> tempList, int index) {
//     TextStyle textStyle = TextStyle(
//         fontFamily: 'QuickSand',
//         fontSize: 22 % widget.deviceSize.width * 0.65,
//         color: Colors.white);
//     // TextStyle textStyle = const TextStyle(fontFamily: 'QuickSand',fontSize: 20.0,color: Colors.white);
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//       child: InkWell(
//         onTap: () {
//           print(tempList[index - mainScreenwidgets.length]);
//           String temp =
//               getBranchShort(tempList[index - mainScreenwidgets.length]);
//           print(temp);
//           Navigator.push(context,
//               CupertinoPageRoute(builder: (BuildContext context) {
//             return AllEventScreen(
//               deptName: temp,
//             );
//           }));
//         },
//         child: Card(
//           color: Colors.transparent,
//           elevation: 5.0,
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                     // color: Colors.blue.withOpacity(0.2),
//                     gradient: branchgra[index - mainScreenwidgets.length]),

//                 height: widget.deviceSize.height * 0.3,

//                 // margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
//               ),
//               Positioned(
//                   bottom: 10.0,
//                   left: 20.0,
//                   child: Text(
//                     tempList[index - mainScreenwidgets.length],
//                     style: textStyle,
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget networkCard({String imageurl}) {
//     print("printed tech : in netwrok $technical");
//     return CachedNetworkImage(
//         imageUrl: imageurl,
//         imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//         placeholder: (context, url) => Center(
//               child: Container(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         errorWidget: (context, url, error) {
//           print("error in network card $error\n with url $url");
//           return Container(child: Center(child: CircularProgressIndicator()));
//         });
//   }

//   List<String> eventList = [
//     "Poster Presentation",
//     "Project Expo",
//     "Paper Presentation",
//     "Ideation",
//   ];

//   Widget _getFeaturedEvents(double width) {
//     int index = 0;
//     return Column(
//         children: List<String>(2).map<Widget>((_) {
//       print("index is $index");
//       print("index is $index");
//       return Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List(2).map((T) {
//             return _buildCustomeCard(
//                 width, 'assets/steak_on_cooktop.jpg', eventList[index++]);
//           }).toList());
//     }).toList());
//   }

//   Widget _buildCustomeCard(double width, String imageAsset, String title) {
//     return Tooltip(
//       message: title,
//       child: InkWell(
//         onTap: () {
//           print("taped featured_events/$title");
//           showDialog(
//               barrierDismissible: false,
//               context: context,
//               builder: (BuildContext context) {
//                 return FutureBuilder<List<String>>(
//                     future: _getCentralDepts(title),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<List<String>> snapshot) {
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.none:
//                         case ConnectionState.waiting:
//                         case ConnectionState.active:
//                           print(snapshot.data);
//                           print("While Loading..");
//                           return Center(
//                             child: Container(
//                               color: Colors.grey.withOpacity(0.5),
//                               child: CupertinoAlertDialog(
//                                 content: SizedBox(
//                                   height: 45.0,
//                                   child: Center(
//                                     child: Row(
//                                       children: <Widget>[
//                                         CircularProgressIndicator(
//                                           strokeWidth: 1.5,
//                                         ),
//                                         Expanded(
//                                           child: Text(
//                                             "Loading..",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 18.0),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         case ConnectionState.done:
//                           if (snapshot.hasError) {
//                             return AlertDialog(
//                               content: Text(
//                                 "Something Went Worng. Please Try Again",
//                                 style: TextStyle(
//                                   fontFamily: 'QuickSand',
//                                 ),
//                               ),
//                               actions: <Widget>[
//                                 FlatButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text("Ok"),
//                                 ),
//                               ],
//                             );
//                           } else {
//                             print("After Completion of Builder");
//                             print(snapshot.data);
//                             return AlertDialog(
//                               content:
//                                   MultiSelectChip(reportList: snapshot.data),
//                               actions: <Widget>[
//                                 FlatButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text("Cancel"),
//                                 ),
//                                 FlatButton(
//                                   onPressed: () {
//                                     String dep =
//                                         _MultiSelectChipState.getChoice();
//                                     print(dep.length);
//                                     if (dep.length != 0) {
//                                       Navigator.of(context).pushReplacement(
//                                         CupertinoPageRoute(
//                                           builder: (BuildContext context) =>
//                                               RegistrationScreen(
//                                             organizingDepartment: dep,
//                                             eventName: title.trim(),
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                   child: Text("Continue"),
//                                 ),
//                               ],
//                             );
//                           }
//                           return null;
//                       }
//                     });
//               });
//           print(title.trim());
//         },
//         child: Card(
//           child: Stack(
//             alignment: Alignment.center,
//             children: <Widget>[
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20.0),
//                 child: Card(
//                   elevation: 0.0,
//                   child: Container(
//                     width: width * 0.4,
//                     height: width * 0.4,
//                     // color: Colors.red,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(imageAsset), fit: BoxFit.cover),
//                         gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.2),
//                             ])),
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0)),
//                 ),
//               ),
//               Positioned(
//                 bottom: -5.0,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20.0),
//                   child: Card(
//                     elevation: 0.0,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                       ),
//                       width: width * 0.47,
//                       child: Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Text(title,
//                               softWrap: false,
//                               style: labelStyle.copyWith(
//                                 fontSize: width * 0.04,
//                                 fontFamily: 'bebas-neue',
//                                 letterSpacing: 1.5,
//                               )),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MultiSelectChip extends StatefulWidget {
//   final List<String> reportList;

//   MultiSelectChip({this.reportList});

//   @override
//   _MultiSelectChipState createState() => _MultiSelectChipState();
// }

// class _MultiSelectChipState extends State<MultiSelectChip> {
//   static String getChoice() {
//     return _MultiSelectChipState.selectedChoice;
//   }

//   static String selectedChoice = "";

//   // this function will build and return the choice list
//   _buildChoiceList() {
//     List<Widget> choices = List();
//     widget.reportList.forEach((item) {
//       choices.add(Container(
//         padding: const EdgeInsets.all(2.0),
//         child: ChoiceChip(
//           label: Text(item),
//           selected: selectedChoice == item,
//           onSelected: (selected) {
//             setState(() {
//               selectedChoice = item;
//             });
//           },
//         ),
//       ));
//     });
//     return choices;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: _buildChoiceList(),
//     );
//   }
// }

// /*

// Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\firebase_core-0.4.0+3\android\src\main\java\io\flutter\plugins\firebase\core\FirebaseCorePlugin.java uses unchecked or unsafe operations.
// Note: Recompile with -Xlint:unchecked for details.
// Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\firebase_messaging-5.1.5\android\src\main\java\io\flutter\plugins\firebasemessaging\FlutterFirebaseMessagingService.java uses or overrides a deprecated API.
// Note: Recompile with -Xlint:deprecation for details.
// Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\firebase_messaging-5.1.5\android\src\main\java\io\flutter\plugins\firebasemessaging\FirebaseMessagingPlugin.java uses unchecked or unsafe operations.
// Note: Recompile with -Xlint:unchecked for details.
// Note: Some input files use unchecked or unsafe operations.
// Note: Recompile with -Xlint:unchecked for details.
// Note: D:\flutter\.pub-cache\hosted\pub.dartlang.org\url_launcher-5.1.2\android\src\main\java\io\flutter\plugins\urllauncher\WebViewActivity.java uses or overrides a deprecated API.
// Note: Recompile with -Xlint:deprecation for details.

// */
