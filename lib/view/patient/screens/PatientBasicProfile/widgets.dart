import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:maulaji/chat/model/chat_message.dart';
import 'package:maulaji/myCalling/call.dart';
import 'package:maulaji/projPaypal/config.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/utils/mySharedPreffManager.dart';
import 'package:maulaji/view/login_view.dart';
import 'package:maulaji/view/patient/counter_bloc.dart';
import 'package:maulaji/view/patient/screens/PatientBasicProfile/stream.dart';
import 'package:maulaji/view/patient/screens/PatientBasicProfile/widgets.dart';
import 'package:maulaji/view/patient/sharedActivitys.dart';
import 'package:maulaji/view/patient/sharedData.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:maulaji/chat/model/chat_screen.dart';
import 'package:maulaji/chat/model/root_page.dart';
import 'package:maulaji/chat/service/authentication.dart';
import 'package:maulaji/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";

class ProfileBasicPatient extends StatefulWidget {
  StatusModel state;
  ProfileBasicPatient(this.state);
  @override
  _ProfileBasicPatienttate createState() => _ProfileBasicPatienttate();
}

class _ProfileBasicPatienttate extends State<ProfileBasicPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        elevation: 10,
        title: Text("Profile Information"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
              child: InkWell(
                onTap: () async {
                  var header = <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':widget.state. prefs.getString("auth"),};
                  File image =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
                  var stream =
                  new http.ByteStream(DelegatingStream.typed(image.openRead()));
                  var length = await image.length();

                  var uri = Uri.parse(_baseUrl + "update-user-info");

                  var request = new http.MultipartRequest("POST", uri);
                  var multipartFile = new http.MultipartFile(
                      'photo', stream, length,
                      filename: basename(image.path));
                  //contentType: new MediaType('image', 'png'));

                  request.files.add(multipartFile);
                  request.fields.addAll(<String, String>{'user_id':widget. state. prefs.getString("uid")});
                  request.headers.addAll(header);
                  //  showThisToast(AUTH_KEY + "/n" + UID);

                  var response = await request.send();

                  print(response.statusCode);
                  // showThisToast(response.statusCode.toString());

                  response.stream.transform(utf8.decoder).listen((value) {
                    //print(value);
                    //showThisToast(value);

                    var data = jsonDecode(value);
                    //showThisToast(data.t);
                    // showThisToast((data["photo"]).toString());
                    widget. state.   prefs.setString("uphoto",data["photo"].toString()).then((value) => {
                      PatientProfileStream.getInstance()
                    });
                    setState(() {
                      // user_picture = (data["photo"]).toString();
                      // UPHOTO = user_picture;
                    });
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        //  top: 0,bottom: 0,left: 0,right: 0,
                          child: CircleAvatar(
                            radius: 72,
                            backgroundColor: Colors.orange,
                          )),
                      Center(
                        // top: 0,bottom: 0,left: 0,right: 0,

                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                              _baseUrl_image +widget.state. prefs.getString("uphoto")),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 00),
            child: Card(
              elevation: 10,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      final _formKey = GlobalKey<FormState>();
                      String newName;
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Edit Display Name'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          initialValue:widget. state. prefs.getString("uname"),
                                          validator: (value) {
                                            newName = value;
                                            if (value.isEmpty) {
                                              return 'Please enter Display Name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Update'),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    var status = updateDisplayName(
                                        widget.state. prefs.getString("auth"), widget.state. prefs.getString("uid"), newName);
                                    USER_NAME = newName;

                                    widget. state.   prefs.setString("uname", newName);




                                    status.then((value) {
                                              Navigator.of(context).pop();
                                              PatientProfileStream.getInstance();
                                            }
                                            );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                      child: Text(widget.state. prefs.getString("uname")),
                    ),
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                          child: Text("Display Name"),
                        ),
                        Padding(
                          child: Text(
                            "EDIT",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 00, 00, 00),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                      child: Text(widget.state. prefs.getString("uphone")),
                    ),
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                          child: Text("Phone"),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  ListTile(
                    subtitle: Padding(
                      padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                      child: Text(widget.state. prefs.getString("uemail")),
                    ),
                    title: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 00, 00, 00),
                          child: Text("Email"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}