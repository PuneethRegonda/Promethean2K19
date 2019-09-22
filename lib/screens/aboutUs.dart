import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promethean_2k19/common/alertsHelper.dart';
import 'package:promethean_2k19/screens/developerScreen.dart';
import 'package:promethean_2k19/screens/sponsor.dart';
import 'package:promethean_2k19/utils/folder/data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:promethean_2k19/utils/urls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

// import 'package:vhelp/utils.dart';

var style = TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0);

class AboutCollege extends StatefulWidget {
  final bool isFirstLaunch;
  final Size deviceSize;

  const AboutCollege({Key key, this.deviceSize, this.isFirstLaunch = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print(isFirstLaunch);
    return _AboutCollegeState();
  }
}

class _AboutCollegeState extends State<AboutCollege>
    with TickerProviderStateMixin {
  AnimationController fabcontroller;
  AnimationController floatingAboutButtonController;
  Widget activeWidget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void initState() {
    fabcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    fabcontroller.forward();
    floatingAboutButtonController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }


  final List<AboutModel> model = [
    AboutModel(
        icon: "assets/college.png",
        title: "About College",
        onPressed: (BuildContext navcontext) {
          Navigator.of(navcontext).push(CupertinoPageRoute(
            builder: (BuildContext context) => AboutCollegeScreen(),
          ));
          print("About College");
        }),
    AboutModel(
        icon: "assets/aboutdeveloper.png",
        title: "About Developers",
        onPressed: (BuildContext context) {
          print("Developers ");
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => DevelopersScreen()));
        }),
    AboutModel(
        icon: "assets/coreteam.png",
        title: "Core Team",
        onPressed: (BuildContext context) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => CustomScreen(
                    name: "coreTeam",
                    screenTitle: "Core Team",
                  )));
        }),
    AboutModel(
        icon: "assets/studentco.png",
        title: "Department Coordinators",
        onPressed: (BuildContext context) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => CustomScreen(
                    name: "deptCoordinators",
                    screenTitle: "Department Coordinators",
                  )));
        }),
    AboutModel(
        icon: "assets/facultyco.png",
        title: "Faculty Coordinators",
        onPressed: (BuildContext context) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => CustomScreen(
                    name: "facultyCoordinators",
                    screenTitle: "Faculty Coordinators",
                  )));
        }),
    AboutModel(
        icon: "assets/transportation.png",
        title: "Transportation",
        onPressed: (BuildContext context) async {
          await launch("https://www.bvrit.ac.in/index.php/transport");
        }),
    AboutModel(
        icon: "assets/aboutvenue.png",
        title: "Venue",
        onPressed: (BuildContext context) {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (BuildContext context) => GoogleLocation()));
        }),
    AboutModel(
        icon: "assets/sponser.png",
        title: "Our Sponsors",
        onPressed: (BuildContext context) {
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (context) => SponserScreen()));
        }),
  ];

  final TextStyle textStyle =
      new TextStyle(fontFamily: 'QuickSand', color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 1.0, spreadRadius: 1.0)
                ],
              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.25),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: ShapeDecoration(
                      shape: CircleBorder(), color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.0111),
                    child: DecoratedBox(
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.25),
                        child: Container(
                          child: Image.asset(
                            "assets/logo.jpg",
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "Synchronize Synergise Sustain",
                style: TextStyle(
                    fontFamily: 'QuickSand',
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              ),
            ),
            Divider(
              endIndent: 1.0,
            ),
            Expanded(
                child: ListView.builder(
                    primary: true,
                    addRepaintBoundaries: false,
                    physics: BouncingScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(model[index].icon),
                        ),
                        title: Text(
                          model[index].title,
                          style: textStyle,
                        ),
                        onTap: () {
                          model[index].onPressed(context);
                        },
                      );
                    }))
          ],
        ));
  }
}

class AboutModel {
  final String icon;
  final String title;
  final Function(BuildContext context) onPressed;

  AboutModel(
      {@required this.icon, @required this.title, @required this.onPressed});
}

// import 'package:google_maps_flutter/google_maps_flutter.dart';
class GoogleLocation extends StatefulWidget {
  @override
  _GoogleLocationState createState() => _GoogleLocationState();
}

class _GoogleLocationState extends State<GoogleLocation> {
  GoogleMapController controller;
  Set<Marker> marker = {};

  @override
  void initState() {
    marker.add(new Marker(
        markerId: MarkerId("college Marker"),
        position: const LatLng(17.7253, 78.2572),
        infoWindow: InfoWindow(
            title: "B V Raju Institute of Technology",
            // snippet: "BVRIT",
            // anchor: Offset(0.5, 0.0)),
            onTap: () {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation:10.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.lightBlue,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.keyboard_backspace),
        ),
        centerTitle: true,
        title: Text("College Location",
            style: TextStyle(
                fontFamily: 'QuickSand', color: Colors.deepOrangeAccent)),
        elevation: 10.0,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.5,

              width: double.infinity,

              child: GoogleMap(
                compassEnabled: true,

                // trafficEnabled: true,

                markers: marker,

                myLocationEnabled: true,

                initialCameraPosition: CameraPosition(
                    target: LatLng(17.725235, 78.257153), zoom: 16),

                onMapCreated: (controlle) {
                  setState(() {
                    controller = controlle;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AboutState { Open, Close }

class AboutCollegeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Our College",
          style: TextStyle(fontFamily: 'QuickSand', color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: new BouncingScrollPhysics(),
        child: SizedBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/bvrit.png'),
            SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "${Data.aboutUsTitle}",
                style: Styles.heading.copyWith(
                  fontSize: deviceSize.width * 0.04,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 5.0, bottom: 10.0),
              child: Text(
                Data.aboutUs,
                textAlign: TextAlign.justify,
                style: Styles.description,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text(Data.rowText1, textAlign: TextAlign.center, style: style),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.white30,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(Data.rowText2, textAlign: TextAlign.center, style: style),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.white30,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(Data.rowText3, textAlign: TextAlign.center, style: style),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.white30,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                Text(Data.rowText4, textAlign: TextAlign.center, style: style),
              ],
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOfferedTitle1,
                      style: Styles.heading.copyWith(
                        fontSize: deviceSize.width * 0.04,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOffered1,
                      style: Styles.description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOfferedTitle2,
                      style: Styles.heading.copyWith(
                        fontSize: deviceSize.width * 0.04,
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      Data.coursesOffred2,
                      style: Styles.description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class CustomScreen extends StatelessWidget {
  final String name;
  final String screenTitle;

  CustomScreen({Key key, this.name, this.screenTitle}) : super(key: key);

  final TextStyle titleTextStyle = new TextStyle(
      fontFamily: 'QuickSand',
      fontSize: 17.0,
      fontWeight: FontWeight.w500,
      color: Colors.black);

  Future<List<Coordinator>> _future() async {
    List<Coordinator> listCo = [];
    await http
        .get(Urls.getRoot + name + ".json")
        .then((http.Response response) {
      Map<String, dynamic> fetchedData = {};
      fetchedData = json.decode(response.body);
      fetchedData.forEach((String uniqueId, dynamic v) {
        v.forEach((String k, dynamic value) {
          final Coordinator coordinator = new Coordinator(
              imageUrl: value['imageUrl'],
              branch: value['branch'],
              phone: value['phonenum'].toString(),
              name: value['name']);
          listCo.add(coordinator);
        });
      });
    });
    return listCo;
  }

  buildcoordinatorCard(Coordinator coordinator, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: double.infinity,
          child: Card(
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.0,
                          spreadRadius: 1.0)
                    ],
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.25),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.25,
                      decoration: ShapeDecoration(
                          shape: CircleBorder(), color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.0111),
                        child: DecoratedBox(
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.25),
                            child: Container(
                              child: coordinator.imageUrl.isEmpty?CircleAvatar(
                                child: Icon(Icons.add_a_photo,color: Colors.grey,),
                                backgroundColor: Colors.grey[100],
                              ):
                              FadeInImage.memoryNetwork(
                                fit: BoxFit.fill,
                                fadeOutCurve: Curves.easeInOutSine,
                                placeholder: kTransparentImage,
                                  image: coordinator.imageUrl,
                              ),
                            ),
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      coordinator.name,
                      style: titleTextStyle,
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.45,
                        child: Text(
                            coordinator.branch,
                            softWrap: true,
                          style: TextStyle(fontFamily: 'QuickSand',color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: ActionChip(
                              onPressed: () {
                                _launchUrl(coordinator.phone);
                              },
                              label: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                child: Text(
                                  "Call",
                                  style: TextStyle(fontFamily: 'QuickSand',color: Colors.white),
                                ),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          screenTitle,
          style: titleTextStyle.copyWith(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _future(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Coordinator>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 0.9,
                ));
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                      child: Text(
                          "Please try again later something went wrong!!!"));
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child:
                            buildcoordinatorCard(snapshot.data[index], context),
                      );
                    });
                break;
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}



void _launchUrl(String phoneno) async {
  if (await canLaunch('tel:' + phoneno)) {
    launch('tel:' + phoneno);
  } else {
    print("url launch exception caught");
    throw "Could not launch " + phoneno;
  }
}



class Coordinator {
  final String imageUrl;
  final String name;
  final String branch;
  final String phone;

  Coordinator({this.imageUrl, this.name, this.branch, this.phone});
}

///  return Container(
//          decoration: BoxDecoration(
//            shape: BoxShape.circle,
//            boxShadow: [
//              BoxShadow(color: Colors.grey, blurRadius: 1.0, spreadRadius: 1.0)
//            ],
//          ),
//          child: ClipRRect(
//            clipBehavior: Clip.antiAliasWithSaveLayer,
//            borderRadius: BorderRadius.circular(
//                MediaQuery.of(context).size.width * 0.25),
//            child: Container(
//              width: MediaQuery.of(context).size.width * 0.25,
//              height: MediaQuery.of(context).size.width * 0.25,
//              decoration:
//              ShapeDecoration(shape: CircleBorder(), color: Colors.white),
//              child: Padding(
//                padding: EdgeInsets.all(
//                    MediaQuery.of(context).size.width * 0.0111),
//                child: DecoratedBox(
//                  child: ClipRRect(
//                    clipBehavior: Clip.antiAlias,
//                    borderRadius: BorderRadius.circular(
//                        MediaQuery.of(context).size.width * 0.25),
//                    child:  Container(
//                      child: Image.asset(
//                        "assets/logo.jpg",
//                        fit: BoxFit.cover,
//                        filterQuality: FilterQuality.high,
//                      ),
//                    ),
//                  ),
//                  decoration: ShapeDecoration(
//                    color: Colors.white,
//                    shape: CircleBorder(),
//                  ),
//                ),
//              ),
//            ),
//          ),
//        );
