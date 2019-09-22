import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Developer {
  final String developerName;
  final String desc;
  final String imagePath;
  final String tagPath;
  final String mailID;
  final String number;
  final String gitHubLink;

  Developer(
      {this.developerName,
      this.desc,
      this.imagePath,
      this.tagPath,
      this.mailID,
      this.number,
      this.gitHubLink});
}

class DevelopersScreen extends StatefulWidget {
  @override
  _DevelopersScreenState createState() => _DevelopersScreenState();
}

class _DevelopersScreenState extends State<DevelopersScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  List<Developer> devList = [];

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    animation = new CurvedAnimation(
      parent: controller,
      curve: new Interval(0.0, 1, curve: Curves.easeInOut),
    );


    devList.add(Developer(
        desc:
        " is passinated Mobile Application Developer, Open Source Contributor and much interested in UI/UX desinging and putting them to Life.",
        developerName: "Puneeth Regonda",
        imagePath: 'assets/ItsMe.jpg',
        mailID: "puneethregonda1291@gmail.com",
        number: "9441095948",
        tagPath: "assets/punDev.png",
        gitHubLink: "https://github.com/PuneethRegonda"));

    devList.add(
      Developer(
          desc:
              " is  passinated Mobile Application Developer,Open Source Contributor and interested in Backend, DB Connectivity and Networking. He puts all those complex tasks so Simple.",
          developerName: "Sai Kumar",
          imagePath: 'assets/ItsSai.jpg',
          mailID: "nagubandisai40@gmail.com",
          number: "9849210151",
          tagPath: "assets/saiDev.png",
          gitHubLink: "https://github.com/nagubandisai40"),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget getDevPicCard(Developer developer) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              top: 0.0,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: MediaQuery.of(context).size.width * 0.40,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(developer.imagePath))),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.14,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(developer.tagPath),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDev(Developer developer) {
    return Container(
      child: Card(
          child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getDevPicCard(developer),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Card(
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          Text.rich(TextSpan(
                              text: developer.developerName,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "QuickSand",
                                color: Colors.red,
                              ),
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'QuickSand',
                                    fontSize: 17.0,
                                  ),
                                  text: developer.desc,
                                )
                              ]))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: ExpansionTile(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ActionChip(
                          backgroundColor: Colors.red,
                          label: Text(
                            "Mail",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'QuickSand',
                                color: Colors.white),
                          ),
                          onPressed: () {
                            launch("mailto: ${developer.mailID}");
                          }),
                      ActionChip(
                          backgroundColor: Colors.green[200],
                          label: Text(
                            "Call",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'QuickSand',
                                color: Colors.white),
                          ),
                          onPressed: () async {
                            if (await canLaunch('tel:' + developer.number)) {
                              launch('tel:' + developer.number);
                            } else {
                              print("url launch exception caught");
                              throw "Could not launch " + developer.number;
                            }
                          }),
                      ActionChip(
                          backgroundColor: Colors.blueGrey,
                          label: Text(
                            "Github",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'QuickSand',
                                color: Colors.white),
                          ),
                          onPressed: () {
                            launch(developer.gitHubLink);
                          }),
                    ],
                  ),
                ),
              ],
              title: Text("IT (2017-2021)"),
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("${devList.length}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Developers",style: TextStyle(fontFamily: 'QuickSand',color: Colors.black,)),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: devList.length+1,
        itemBuilder: (BuildContext context, int index) {
          if(index<devList.length){
            return buildDev(devList[index]);
          }
          else
            return SizedBox(height: MediaQuery.of(context).size.height*0.11,);
        },
      ),
    );
  }
}

///SlideTransition(
//              position: animation.drive(Tween<Offset>(
//                begin: const Offset(0.0, 3.7),
//                end: const Offset(0.0, 1.5),
//              )),
//              child: Text(
//                "Intro To Imagination",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'QuickSand',
//                    fontSize: 50.0,
//                    color: Colors.white),
//              ),
//            ),

/// Widget buildDev2(Developer developer) {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      mainAxisSize: MainAxisSize.max,
//      children: <Widget>[
//        getDevPicCard(developer),
////        SizedBox(width: .0,),
//        SlideTransition(
//          position: animation.drive(Tween<Offset>(
//            begin: const Offset(0.0, 3.7),
//            end: const Offset(0.0, 1.5),
//          )),
//          child: Padding(
//            padding:
//                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
//            child: Align(
//              alignment: Alignment.bottomRight,
//              child: Container(
//                width: MediaQuery.of(context).size.width * 0.45,
//                child: Card(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Wrap(
//                      alignment: WrapAlignment.center,
//                      children: <Widget>[
//                        Text.rich(TextSpan(
//                            text: developer.developerName,
//                            style: TextStyle(
//                              fontSize: 20.0,
//                              fontFamily: "QuickSand",
//                              color: Colors.red,
//                            ),
//                            children: [
//                              TextSpan(
//                                style: TextStyle(
//                                  color: Colors.black,
//                                  fontFamily: 'QuickSand',
//                                  fontSize: 17.0,
//                                ),
//                                text: developer.desc,
//                              )
//                            ]))
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ),
//      ],
//    );
//  }
