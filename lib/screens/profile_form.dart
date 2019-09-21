import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:promethean_2k19/common/messageBox.dart';
import 'package:http/http.dart' as http;
import 'package:promethean_2k19/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserProfileForm extends StatefulWidget {
  final bool isFirstLaunch;

  const UserProfileForm({Key key, this.isFirstLaunch=false}) : super(key: key);

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final GlobalKey<FormState> _formkey = new GlobalKey();

  String branchdropdownValue = "IT";
  String yeardropdownValue = "1 Year";

  Map<String, String> _formData = {
    'uid': null,
    'email': null,
    'phone': null,
    'userName': null,
    'year': "1 Year",
    'college': null,
    'branch': "IT",
    'rollNo': null,
    'profilePic':'https://firebasestorage.googleapis.com/v0/b/promethean2k19-68a29.appspot.com/o/profile_images%2Fthor_Hulk.png?alt=media&token=2f964c3d-8e52-4875-9824-7ea31ebd8a56'

  };

  ///sending userprofile to server Firbase...
  Future<Null> _sendToServer() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String uid = _prefs.get('uid');
//    print("send Server with uid $uid");
    if (_formkey.currentState.validate()) {
    LoadingMessageBox(context, "Loading..", "").show();    
      _formkey.currentState.save();
//      print("entered saveed fromkey ${_formData['branch']}");
      http
          .post(
              "https://promethean2k19-68a29.firebaseio.com/users/$uid/userInfo.json",
              body: json.encode(_formData))
          .then((http.Response response) {
        _prefs.setBool('UIS', true);
        Navigator.of(context).pop();
//        print("before pop");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(isFirstLaunch: widget.isFirstLaunch,)));
      }).catchError(
        (_, __) {
          Navigator.of(context).pop();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _sendToServer();                          
                          Navigator.of(context).pop();
                        });
                      },
                      child: Text("Ok"),
                    )
                  ],
                  content: Container(
                    child: Text("Please Try Again"),
                  ),
                );
              });
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.blue.withOpacity(0.60),
            pinned: false,
            // automaticallyImplyLeading: false,
            expandedHeight: _size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "User Profile",
                style: TextStyle(letterSpacing: 1.2),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Please Enter UserName.";
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                                suffix: Icon(Icons.person, color: Colors.blue),
                                labelText: 'User Name',
                                hintText: 'UserName',
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54)),
                            onSaved: (String s) {
                              _formData['userName'] = s;
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: TextFormField(
                            validator: (String value) {
                              if (!value.contains("@gmail.com") &&
                                  !value.contains("@bvrit.ac.in")) {
                                return "Please Enter Valid Email.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                suffix: Icon(Icons.alternate_email,
                                    color: Colors.blue),
                                labelText: 'Email',
                                hintText:
                                    'Email ID (@gmail.com , @bvrit.ac.in)',
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54)),
                            onSaved: (String s) {
                              _formData['email'] = s;
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: TextFormField(
                            // focusNode: phoneNo,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                suffix: Icon(Icons.phone, color: Colors.blue),
                                labelText: 'Phone Number',
                                hintText: 'xxxxx xxxxx',
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54)),
                            onEditingComplete: () {
                              // FocusScope.of(context).requestFocus(college);
                            },
                            onSaved: (String s) {
                              _formData['phone'] = s;
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: TextFormField(
                            // focusNode: college,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Invalid College Name.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                suffix: Icon(Icons.school, color: Colors.blue),
                                labelText: 'College Name',
                                hintText: 'Name of Your Institute.',
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54)),
                            onSaved: (String value) {
                              _formData['college'] = value;
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: TextFormField(
                            // focusNode: rollno,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "RollNo is Empty.";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                suffix: Icon(Icons.school, color: Colors.blue),
                                labelText: 'Roll No',
                                hintText: 'Enter Your RollNo',
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: Colors.black54)),
                            onSaved: (String value) {
                              _formData['rollNo'] = value;
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: DropdownButton<String>(
                            value: branchdropdownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                branchdropdownValue = newValue;
                              });
                              _formData['branch'] = branchdropdownValue;
                            },
                            items: <String>[
                              'IT',
                              'CSE',
                              'CHE',

                              'CIV',
                              'ECE',
                              'EEE',
                              
                              'MEC',
                              'PHE',
                              'BME',
                              
                              'MBA',
                              'Other',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Card(
                        elevation: 15.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
                          child: DropdownButton<String>(
                            value: yeardropdownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                yeardropdownValue = newValue;
                              });
                              _formData['year'] = yeardropdownValue;
                            },
                            items: <String>[
                              '1 Year',
                              '2 Year',
                              '3 Year',
                              '4 Year',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          color: Colors.transparent,
                          elevation: 15.0,
                          child: CupertinoButton(
                            color: Colors.blue,
                            onPressed: _sendToServer,
                            child: Text('Save'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
