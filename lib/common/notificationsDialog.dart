import 'package:flutter/material.dart';
import 'package:promethean_2k19/common/alertsHelper.dart';

TextStyle titleStyle = const TextStyle(fontFamily: 'QuickSand',fontWeight: FontWeight.w400,fontSize: 17.0);

class NotificationsDialogs {
  BuildContext context;
  EventNotification eventnotification;
  WinnerNotification winnernotification;
  NotificationsDialogs(context,{this.eventnotification,this.winnernotification}) {
    this.context = context;
  }

  showEventDialog(){
    _getEventDialog(this.eventnotification);
  }

  showWinnerDialog(){
    _getWinnerDialog(this.winnernotification);
  }

  _getWinnerDialog(WinnerNotification winnerNotification) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              child: Card(
                child: Column(
                  children: <Widget>[
//                    Container(
//                      width: double.infinity,
//                      height: 300.0,
//                      child: FadeInImage.memoryNetwork(
//                        fadeOutCurve: Curves.easeInOutSine,
//                        placeholder: kTransparentImage,
//                        image: ,
//                        fit: BoxFit.fill,
//                      ),
//                    ),
                    Text(winnerNotification.winnerName),
                    Text(winnerNotification.winnerDept),
                    Text(winnerNotification.eventName,style: titleStyle,),
                    Text(winnerNotification.college,style: titleStyle,),
                    Text(winnerNotification.eventOrganized,style: titleStyle,),
                    Text(winnerNotification.tilte,style: titleStyle,),
                  ],
                ),
              ),
              constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.height * 0.7));

        });
  }

  _getEventDialog(EventNotification eventNotification) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 300.0,
                      child: FadeInImage.memoryNetwork(
                        fadeOutCurve: Curves.easeInOutSine,
                        placeholder: kTransparentImage,
                        image: eventNotification.imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(eventNotification.title,style: titleStyle,),
                  ],
                ),
              ),
              constraints: BoxConstraints.tightFor(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.height * 0.7));

        });
  }
}


class Notification {
  final String tilte;
  Notification(this.tilte);
}


class EventNotification extends Notification{
  final String title;
  final String deptName;
  final String imageUrl;
  EventNotification ({this.deptName,this.title,this.imageUrl}) : super(title);
}


class WinnerNotification extends Notification{
  final String tilte;
  final String winnerName;
  final String winnerDept;
  final String college;
  final String eventName;
  final String eventOrganized;
  WinnerNotification({this.tilte,this.winnerName,this.winnerDept,this.college,this.eventName,this.eventOrganized}) : super(tilte);
}
