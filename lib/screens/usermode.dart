import 'package:flutter/material.dart';

class Usermode extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: []),
      ),

      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          height: MediaQuery.of(context).size.height*0.5,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   InkWell(
                     onTap: (){},
                     child: Card(
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(15.0),
                       ),
                       child: Text("Student",style: TextStyle(
                         fontFamily: 'QuickSand',
                         color: Colors.black,
                         fontSize: 18.0,
                       ),),
                     ),
                   ),
                   InkWell(
                     onTap: (){

                     },
                     child: Card(
                       color: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(15.0),
                       ),
                       child: Text("Student",style: TextStyle(
                         fontFamily: 'QuickSand',
                         color: Colors.black,
                         fontSize: 18.0,
                       ),),
                     ),
                   ),
                 ],
               ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text("Faculty",style: TextStyle(
                  fontFamily: 'QuickSand',
                  color: Colors.black,
                  fontSize: 18.0,
                ),),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text("Other",style: TextStyle(
                  fontFamily: 'QuickSand',
                  color: Colors.black,
                  fontSize: 18.0,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

}