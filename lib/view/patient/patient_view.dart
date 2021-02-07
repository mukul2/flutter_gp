import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'package:maulaji/chat/model/chat_message.dart';
import 'package:maulaji/myCalling/VoiceCall.dart';
import 'package:maulaji/myCalling/call.dart';
import 'package:maulaji/myCalling/jitsiCall.dart';
import 'package:maulaji/myCalling/videoCall.dart';
import 'package:maulaji/projPaypal/config.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/utils/mySharedPreffManager.dart';
import 'package:maulaji/view/login_view.dart';
import 'package:maulaji/view/patient/counter_bloc.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/stream.dart';
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
import '../../main.dart';
import 'OnlineDoctorFullProfileView.dart';
import 'OnlineDoctorsList.dart';
import 'SubscriptionsActivityPatient.dart';
import 'departments_for_chamber_doc.dart';
import 'departments_for_online_doc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'myMapViewActivity.dart';
import 'myYoutubePlayer.dart';

Function myFun;

int lastApiHitted1 = 0;
int lastApiHitted2 = 0;
ConsultationFormActivity oldWidget;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print("_backgroundMessageHandler");
  print("nadia");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("_backgroundMessageHandler data: ${data}");
  }
}

BuildContext useThisContext;
var OWN_PHOTO;
String AUTH_KEY;
String A_KEY;
String UPHOTO;
String UEMAIL;
String UID;
String UNAME;
String UPHONE;
var PARTNER_PHOTO;

Function reLoadhome;

Map<int, Color> colorCodes = {
  50: Color.fromRGBO(147, 205, 72, .1),
  100: Color.fromRGBO(147, 205, 72, .2),
  200: Color.fromRGBO(147, 205, 72, .3),
  300: Color.fromRGBO(147, 205, 72, .4),
  400: Color.fromRGBO(147, 205, 72, .5),
  500: Color.fromRGBO(147, 205, 72, .6),
  600: Color.fromRGBO(147, 205, 72, .7),
  700: Color.fromRGBO(147, 205, 72, .8),
  800: Color.fromRGBO(147, 205, 72, .9),
  900: Color.fromRGBO(147, 205, 72, 1),
};
// Green color code: FF93cd48
MaterialColor customColor = MaterialColor(0xFF34448c, colorCodes);
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://callgpnow.com/public/";
var header;

GlobalKey _bottomNavigationKey = GlobalKey();
Color tColor = Color(0xFF34448c);
SharedPreferences prefs;

void mainP() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  prefs = await _prefs;
  AUTH_KEY = prefs.getString("auth");
  A_KEY = prefs.getString("auth");
  UID = prefs.getString("uid");
  UNAME = prefs.getString("uname");
  UPHOTO = prefs.getString("uphoto");
  UEMAIL = prefs.getString("uemail");
  UPHONE = prefs.getString("uphone");


  header = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': AUTH_KEY,
  };
  // = prefs.getString("auth");
  UID_FOR_CHAT = UID;

  //runApp(PatientAPP());
}


















class IncomingCallActivity extends StatefulWidget {
  dynamic data;
  var player;

  IncomingCallActivity(this.data);

  @override
  _IncomingCallActivityState createState() => _IncomingCallActivityState();
}

class _IncomingCallActivityState extends State<IncomingCallActivity> {

  @override
  void dispose() {
    widget.player.dispose();
    print("dispose");
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      /*
      widget.player = AssetsAudioPlayer.newPlayer();
      widget.player.open(
        Audio("assets/ring.mp3"),
        autoStart: true,
        //showNotification: true,
      );

       */

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Incomming Video Call"),),

      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    widget.data["doc_name"],
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage:
                    NetworkImage(_baseUrl_image + widget.data["doc_photo"]),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              widget.player.stop();
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              String chatRoom = createChatRoomName(
                                  int.parse(UID),
                                  int.parse(widget.data["doc_id"].toString()));
                              CHAT_ROOM = widget.data["room"];

                              // await for camera and mic permissions before pushing video page
                              await _handleCameraAndMic();
                              // push video page with given channel name

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JitsiCall(
                                      widget.data["room"], true
                                  ),
                                ),
                              );
                              /*
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CallPageVideo(
                                        channelName: widget.data["room"],

                                        isCameraOn: true,
                                        UID: UID,
                                        isCaller: false,
                                      ),
                                ),
                              );

                               */


                            },
                            leading: Icon(Icons.done),
                            title: Text("Attend Call"),
                          ),
                        )),
                    Expanded(
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              widget.player.stop();

                              http.Response response = await http.post(
                                'https://fcm.googleapis.com/fcm/send',
                                headers: <String, String>{
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                  'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw',
                                  // Constant string
                                },
                                body: jsonEncode(
                                  <String, dynamic>{
                                    'notification': <String, dynamic>{},
                                    'priority': 'high',
                                    'data': <String, dynamic>{
                                      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                      // 'doc_id': widget.UID,
                                      // 'doc_name': widget.ownName,
                                      // 'doc_photo': widget.partnerPhoto,
                                      'type': 'reject_call',
                                      //'room': widget.channelName
                                    },
                                    'to': "/topics/" +
                                        widget.data["doc_id"].toString()
                                  },
                                ),
                              );
                              // showThisToast(response.statusCode.toString());
                            //  isCallingEngagged = false;
                              Navigator.of(context).pop();

                              mainP();
                            },
                            leading: Icon(Icons.close),
                            title: Text("Reject Call"),
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    widget.data["doc_name"],
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage:
                    NetworkImage(_baseUrl_image + widget.data["doc_photo"]),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              if(widget.player!=null) widget.player.stop();
                              Navigator.of(context).pop();
                              String u =await  getUserID();
                              // Navigator.of(context).pop();
                              // String chatRoom = createChatRoomName(
                              //     int.parse(getUserID()),
                              //     int.parse(widget.data["doc_id"].toString()));
                              CHAT_ROOM = widget.data["room"];

                              // await for camera and mic permissions before pushing video page
                              await _handleCameraAndMic();
                              // push video page with given channel name
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JitsiCall(
                                      widget.data["room"], true
                                  ),
                                ),
                              );
                              /*
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CallPageVideo(
                                        channelName: widget.data["room"],

                                        isCameraOn: true,
                                        UID: u,
                                        isCaller: false,
                                      ),
                                ),
                              );

                               */


                            },
                            leading: Icon(Icons.done),
                            title: Text("Attend Call"),
                          ),
                        )),
                    Expanded(
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              if(widget.player!=null) widget.player.stop();

                              http.Response response = await http.post(
                                'https://fcm.googleapis.com/fcm/send',
                                headers: <String, String>{
                                  'Content-Type': 'application/json',
                                  'Authorization':
                                  'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw',
                                  // Constant string
                                },
                                body: jsonEncode(
                                  <String, dynamic>{
                                    'notification': <String, dynamic>{},
                                    'priority': 'high',
                                    'data': <String, dynamic>{
                                      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                      // 'doc_id': widget.UID,
                                      // 'doc_name': widget.ownName,
                                      // 'doc_photo': widget.partnerPhoto,
                                      'type': 'reject_call',
                                      //'room': widget.channelName
                                    },
                                    'to': "/topics/" +
                                        widget.data["doc_id"].toString()
                                  },
                                ),
                              );
                              // showThisToast(response.statusCode.toString());
                              //isCallingEngagged = false;
                              Navigator.of(context).pop();

                              mainP();
                            },
                            leading: Icon(Icons.close),
                            title: Text("Reject Call"),
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class IncomingCallActivityVoice extends StatefulWidget {
  dynamic data;
  var player;

  IncomingCallActivityVoice(this.data);

  @override
  _IncomingCallActivityVoiceState createState() => _IncomingCallActivityVoiceState();
}

class _IncomingCallActivityVoiceState extends State<IncomingCallActivityVoice> {

  @override
  void dispose() {
    widget.player.dispose();
    print("dispose");
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      /*
      widget.player = AssetsAudioPlayer.newPlayer();
      widget.player.open(
        Audio("assets/ring.mp3"),
        autoStart: true,
        //showNotification: true,
      );
      
       */


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Incomming Voice Call"),),

      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.network(_baseUrl_image+widget.data["doc_photo"],fit: BoxFit.fill,),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: () async {
                        if(widget.player!=null) widget.player.stop();
                        Navigator.of(context).pop();
                        String u =await  getUserID();
                        // Navigator.of(context).pop();
                        // String chatRoom = createChatRoomName(
                        //     int.parse(getUserID()),
                        //     int.parse(widget.data["doc_id"].toString()));
                        CHAT_ROOM = widget.data["room"];

                        // await for camera and mic permissions before pushing video page
                        await _handleCameraAndMic();
                        // push video page with given channel name
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JitsiCall(
                                widget.data["room"], false
                            ),
                          ),
                        );
                        /*
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CallPageAudio(
                                  channelName: widget.data["room"],

                                  isCameraOn: true,
                                  UID: u,
                                  isCaller: false,
                                ),
                          ),
                        );



                         */
                      },
                      child: Card(
                        child: ListTile(

                          leading: Icon(Icons.done),
                          title: Text("Attend Call"),
                        ),
                      ),
                    )),
                Expanded(
                    child: InkWell(
                      onTap: () async {
                        if(widget.player!=null) widget.player.stop();

                        http.Response response = await http.post(
                          'https://fcm.googleapis.com/fcm/send',
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                            'Authorization':
                            'key=AAAA8TsH26U:APA91bEK0P-32wiwnhs3iEicQzLFe20P4o7hx0-o4OS2oENSY0jfKSbd0zERkFJL1BNPYV3yE8_Y9PG4-HQ-j4ZXmV9AwrrjKvAiQdnh1JIR3JCmNg0Z4X3bM3lPZoiNGAsGXPkEdoGw',
                            // Constant string
                          },
                          body: jsonEncode(
                            <String, dynamic>{
                              'notification': <String, dynamic>{},
                              'priority': 'high',
                              'data': <String, dynamic>{
                                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                // 'doc_id': widget.UID,
                                // 'doc_name': widget.ownName,
                                // 'doc_photo': widget.partnerPhoto,
                                'type': 'reject_call',
                                //'room': widget.channelName
                              },
                              'to': "/topics/" +
                                  widget.data["doc_id"].toString()
                            },
                          ),
                        );
                        // showThisToast(response.statusCode.toString());
                        //isCallingEngagged = false;
                        Navigator.of(context).pop();


                      },
                      child: Card(
                        child: ListTile(

                          leading: Icon(Icons.close),
                          title: Text("Reject Call"),
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      )
    );
  }
}

Future<void> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions(
    [PermissionGroup.camera, PermissionGroup.microphone],
  );
}



class HomeVisitsDoctorsList extends StatefulWidget {
  String address;

  HomeVisitsDoctorsList(this.address);

  @override
  _HomeVisitsDoctorsListState createState() => _HomeVisitsDoctorsListState();
}

class _HomeVisitsDoctorsListState extends State<HomeVisitsDoctorsList> {
  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://api.callgpnow.com/api/" + 'home_visits_doctor_search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
    );

    this.setState(() {
      data = json.decode(response.body);
      ALL_HOME_DOC_LIST = data;
    });

    print(data);
    print("home doc size " + (data.length).toString());

    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (data != null && data.length > 0)
          ? new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {
              //   showThisToast(data[index].toString());
              // print(data[index].toString());
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => HomeVisitDoctorDetailPage(
              //             widget.address, data[index])));

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SimpleDocProfileActivityHomeVisit(
                              data[index])));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(
                    data[index]["designation_title"] == null
                        ? ("General Practician")
                        : data[index]["designation_title"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: new Text(
                    data[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://api.callgpnow.com/" +
                          data[index]["photo"]),
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text("No Data"),
      ),
    );
  }
}

class HomeVisitDoctorDetailPage extends StatefulWidget {
  dynamic data;
  String address;

  HomeVisitDoctorDetailPage(this.address, this.data);

  @override
  _HomeVisitDoctorDetailPageState createState() =>
      _HomeVisitDoctorDetailPageState();
}

class _HomeVisitDoctorDetailPageState extends State<HomeVisitDoctorDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String problems, homeAddress, date, phone;
  String myMessage = "Submit";
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime
      .now()
      .year
      .toString() +
      "-" +
      DateTime
          .now()
          .month
          .toString() +
      "-" +
      DateTime
          .now()
          .day
          .toString();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selctedDate_ = picked.year.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.day.toString();
        setState(() {
          date = selctedDate_;
        });
        //  showThisToast(selctedDate_);
      });
  }

  Widget StandbyWid = Text(
    "Submit",
    style: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Home Visit"),
      ),
      body: SingleChildScrollView(
        //24 nov
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    "https://api.callgpnow.com/" + widget.data["photo"]),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 2),
              child: Text(
                widget.data["name"],
                style: TextStyle(fontSize: 18, color: tColor),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 3, 20, 2),
                child: Text(
                  widget.data["designation_title"] == null
                      ? ("General Practician")
                      : widget.data["designation_title"],
                )),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        problems = value;
                        if (value.isEmpty) {
                          return 'Please write your problems';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Problems"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      initialValue: widget.address,
                      validator: (value) {
                        homeAddress = value;
                        if (value.isEmpty) {
                          return 'Please enter home address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Home Address"),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Container(
                      decoration: myBoxDecoration(),
                      child: ListTile(
                        onTap: () {
                          _selectDate(context);
                        },
                        trailing: Icon(Icons.arrow_downward),
                        title: Text(selctedDate_),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        phone = value;
                        if (value.isEmpty) {
                          return 'Please enter contact number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Contact Number"),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: SizedBox(
                        height: 50,
                        width: double.infinity, // match_parent
                        child: RaisedButton(
                          color: Color(0xFF34448c),
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              setState(() {
                                StandbyWid = Text("Please wait",
                                    style: TextStyle(color: Colors.white));
                              });
                              //add_home_appointment_info
                              //24 nov

                              final http.Response response = await http.post(
                                _baseUrl + 'add_home_appointment_info',
                                headers: header,
                                body: jsonEncode(<String, String>{
                                  'patient_id': UID,
                                  'dr_id': widget.data["id"].toString(),
                                  'problems': problems,
                                  'phone': phone,
                                  'date': selctedDate_,
                                  'home_address': homeAddress
                                }),
                              );
                              print(response.body);
                              setState(() {
                                myMessage = response.body;
                              });
                              if (response.statusCode == 200) {
                                setState(() {
                                  StandbyWid = Text("Submit Success",
                                      style: TextStyle(color: Colors.white));
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                              } else {
                                setState(() {
                                  StandbyWid = Text(response.body,
                                      style: TextStyle(color: Colors.white));
                                  // Navigator.of(context).pop();
                                  //Navigator.of(context).pop();
                                });
                              }
                            }
                          },
                          child: StandbyWid,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    borderRadius:
    BorderRadius.all(Radius.circular(5.0) //         <--- border radius here
    ),
    border: Border.all(
      color: Colors.blue,
    ),
  );
}

class AddDiseasesActivity extends StatefulWidget {
  Function function;

  //ChooseDeptActivity(this.deptList__, this.function);
  AddDiseasesActivity({Key key, this.function}) : super(key: key);

//  final Map<String, dynamic> data =
//  new Map<String, dynamic>();
//  data['id'] = widget.deptList__[index]["id"].toString();
//  data['name'] =
//  widget.deptList__[index]["name"].toString();
//  widget.function(data);
//  Navigator.of(context).pop(true);
  @override
  _AddDiseasesActivityState createState() => _AddDiseasesActivityState();
}

class _AddDiseasesActivityState extends State<AddDiseasesActivity> {
  final _formKey = GlobalKey<FormState>();
  String diseaesName, currentStatus, firstNoticeDate;
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime.now().toIso8601String();
  String dateToUpdate = (DateTime
      .now()
      .year).toString() +
      "-" +
      (DateTime
          .now()
          .month).toString() +
      "-" +
      (DateTime
          .now()
          .day).toString();

  //String dateToUpdate = "Choose First Notice Date";
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selctedDate_ = selectedDate.toIso8601String();
        dateToUpdate = (picked.year).toString() +
            "-" +
            (picked.month).toString() +
            "-" +
            (picked.day).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    // errr
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Diseases"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  diseaesName = value;
                  if (value.isEmpty) {
                    return 'Please enter Diseases Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Diseases Name"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
            Text("First notice date"),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Container(
                decoration: myBoxDecoration(),
                child: ListTile(
                  onTap: () {
                    _selectDate(context);
                  },
                  trailing: Icon(Icons.arrow_downward),
                  title: Text(dateToUpdate),
                  subtitle: Text("First Notice Date"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                initialValue: "",
                validator: (value) {
                  currentStatus = value;
                  if (value.isEmpty) {
                    return 'Please enter current status';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelText: "Current status"),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestUrgentCareActivity extends StatefulWidget {
  dynamic data;

  int myPotition = 0;


  List downloadedData = [];
  bool hasRequested = false;

  RequestUrgentCareActivity(this.data);

  @override
  _RrequestUrgentCareActivityState createState() =>
      _RrequestUrgentCareActivityState();
}

class _RrequestUrgentCareActivityState
    extends State<RequestUrgentCareActivity> {
  String status = "";

  bool hasAnyPendingRequest = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Request Urgent Care"),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        body: Column(
          children: [
            // FutureBuilder(
            //     future:  FirebaseDatabase.instance
            //         .reference()
            //         .child("xploreDoc")
            //         .child("urgent_care_list")
            //         .child(widget.data["doc_id"].toString())
            //         .orderByChild("patient_id").equalTo(UID)
            //
            //        // .orderByChild("isServed").equalTo(false)
            //         .once(),
            //     builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            //       if (snapshot.hasData ) {
            //
            //         Map<dynamic, dynamic> values = snapshot.data.value;
            //         values.forEach((key, values) {
            //           print("mukul data");
            //
            //           print(key.toString()+" => "+values.toString());
            //           print("my try => "+values["isServed"].toString());
            //           if(values["isServed"]  ){
            //
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) =>
            //                       Scaffold(
            //                         body: Center(
            //                           child: Text("You have a pending urgent request.Please wait until Doctor calls you"),
            //                         ),
            //                       ),
            //                 ));
            //
            //
            //
            //               status = "Please wait, Doctor will call you soon" ;
            //
            //             return Text("One Service is pending");
            //
            //           } else {
            //
            //
            //               status = "" ;
            //
            //             return new Center(
            //             child: Text("No Data Found"),
            //           );
            //
            //         }});
            //
            //
            //       }else {
            //         return new Center(
            //           child: Text("No Data Found"),
            //         );
            //       }
            //       return  Text(status);
            //     }),

            StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("xploreDoc")
                    .child("urgent_care_list")
                    .child(widget.data["doc_id"].toString())
                    .onValue,
                builder: (context, snap) {
                  if (snap.hasData && snap.data.snapshot.value != null) {
                    int i = 0;
                    widget.downloadedData.clear();
                    // widget.downloadedData.add(snap.data.snapshot.value);
                    Map<dynamic, dynamic> values = snap.data.snapshot.value;

                    values.forEach((key, value) {
                      if (value["status"] == "pending") {
                        widget.downloadedData.add(value);
                        print(widget.downloadedData.toString());
                      }
                    });
                    widget.myPotition = widget.downloadedData.length + 1;
                  }

                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Column(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                                widget.data["doc_photo"]),
                          ),
                        ),
                        Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Text(
                                widget.data["doc_name"],
                                style: TextStyle(
                                    fontSize: 22, color: Colors.blue),
                              ),
                            )),
                        Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 00, 0, 10),
                              child: Text(
                                widget.data["doc_dept"],
                              ),
                            )),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Queue is Long #" +
                                  (widget.downloadedData.length).toString() +
                                  " other patients are in the Queue",
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 20),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              if (true) {
                                DatabaseReference ref = FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child("xploreDoc")
                                    .child("urgent_care_list")
                                    .child(widget.data["doc_id"].toString());

                                String key = ref
                                    .push()
                                    .key;
                                //ref.child(key).child("date").set(new DateTime.now().day.toString()+"-"new DateTime.now().month.toString()+"-"+new DateTime.now().year.toString());
                                ref
                                    .child(key)
                                    .child("doc_id")
                                    .set(widget.data["doc_id"]);
                                ref
                                    .child(key)
                                    .child("doc_name")
                                    .set(widget.data["doc_name"]);
                                ref.child(key).child("patient_id").set(UID);
                                ref.child(key).child("patient_name").set(UNAME);
                                ref.child(key).child("patient_photo").set(
                                    UPHOTO);
                                ref.child(key).child("status").set("pending");
                                ref.child(key).child("isServed").set(false);
                                ref
                                    .child(key)
                                    .child("time")
                                    .set(new DateTime.now().toString());
                                ref.child(key).child("key").set(key);

                                //Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();

                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext bc) {
                                      return Container(
                                        child: new Wrap(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Success",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 25),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 20),
                                                child: Text(
                                                  "Requst is Sent Successfully.Doctor will call you shortly",
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // showThisToast("cl");
                                                // Navigator.of(context).pop(true);
                                                Navigator.pop(bc);

                                                // Navigator.of(context).pop();
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 20),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        "Close",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                    ),
                                                    decoration: ShapeDecoration(
                                                      shape:
                                                      CustomRoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                          bottomLeft:
                                                          Radius.circular(5),
                                                          topLeft:
                                                          Radius.circular(5),
                                                          bottomRight:
                                                          Radius.circular(5),
                                                          topRight:
                                                          Radius.circular(5),
                                                        ),
                                                        topSide: BorderSide(
                                                            color: Colors.blue),
                                                        leftSide: BorderSide(
                                                            color: Colors.blue),
                                                        bottomLeftCornerSide:
                                                        BorderSide(
                                                            color: Colors.blue),
                                                        topLeftCornerSide:
                                                        BorderSide(
                                                            color: Colors.blue),
                                                        topRightCornerSide:
                                                        BorderSide(
                                                            color: Colors.blue),
                                                        rightSide: BorderSide(
                                                            color: Colors.blue),
                                                        bottomRightCornerSide:
                                                        BorderSide(
                                                            color: Colors.blue),
                                                        bottomSide: BorderSide(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });

                                setState(() {
                                  widget.hasRequested = true;
                                });
                              }
                            },
                            child: Card(
                                color: Colors.blue,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Card(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          widget.hasRequested
                                              ? "Please wait,  You are in Queue #" +
                                              widget.myPotition.toString()
                                              : "Send Request",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      )),
                                )),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ],
        ));
  }
}

class ProjNotification extends StatefulWidget {
  @override
  _ProjNotificationState createState() => _ProjNotificationState();
}

class _ProjNotificationState extends State<ProjNotification> {
  @override
  Widget build(BuildContext context) {
    return Text("No Worry");
    //return NoticeList();
  }
}

class RealtimeOnlineDoctors extends StatefulWidget {
  List allOnlineData = [];

  @override
  _RealtimeOnlineDoctorsState createState() => _RealtimeOnlineDoctorsState();
}

class _RealtimeOnlineDoctorsState extends State<RealtimeOnlineDoctors> {
  getList() async {
    FirebaseDatabase.instance
        .reference()
        .child("xploreDoc")
        .child("online_status");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Online Doctors"),
          backgroundColor: Colors.white,
          elevation: 10,
        ),
        body: StreamBuilder(
            stream: FirebaseDatabase.instance
                .reference()
                .child("xploreDoc")
                .child("online_status")
                .onValue,
            builder: (context, snap) {
              widget.allOnlineData.clear();
              Map<dynamic, dynamic> values = snap.data.snapshot.value;

              values.forEach((key, value) {
                if (value["is_online"]) {
                  widget.allOnlineData.add(value);
                  print(widget.allOnlineData.toString());
                }
              });


              return widget.allOnlineData.length > 0
                  ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allOnlineData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Stream s = FirebaseDatabase.instance
                              .reference()
                              .child("xploreDoc")
                              .child("urgent_care_list")
                              .child(widget.allOnlineData[index]["doc_id"]
                              .toString())
                              .onValue;
                          s.listen((event) {
                            // showThisToast(event.snapsot.toString());
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RequestUrgentCareActivity(
                                        widget.allOnlineData[index]),
                              ));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.allOnlineData[index]["doc_photo"]),
                          ),
                          subtitle: Text(
                            widget.allOnlineData[index]["doc_dept"],
                            style: TextStyle(color: Colors.blue),
                          ),
                          title: Text(
                            widget.allOnlineData[index]["doc_name"],
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: Text(
                            widget.allOnlineData[index]["fees"],
                            style: TextStyle(color: Colors.blue),
                          ),
                        ));
                  })
                  : Center(
                child: Text("Please wait"),
              );
            }));
  }
}


class ConsultationFormActivityHomeVisit extends StatefulWidget {
  int currentPage = 0;
  String name = "Aminul islam",
      age = "27",
      gender = "Male";

  List appointmentForUserType = [];
  List diseasesType = [];
  List conditionsType = [];
  List medications = [];
  String tempMedName = "";

  String weight = "66";
  String allergy = "No allargy";
  String temperature = "34 C";
  String bloodPressure = "120/80";
  String date;

  String time;

  String reasonForVisit = "No reason selected";

  String conditions = "No conditions selected";

  String medicationsName = "No medicines selected";
  String docID;
  String docName;
  String fees;
  String problems = "Problems";

  String address = "Address";
  String contact = "Contact";
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime
      .now()
      .year
      .toString() +
      "-" +
      DateTime
          .now()
          .month
          .toString() +
      "-" +
      DateTime
          .now()
          .day
          .toString();

  ConsultationFormActivityHomeVisit(this.date, this.time, this.docID,
      this.docName, this.fees);

  @override
  _ConsultationFormActivityHomeVisitState createState() =>
      _ConsultationFormActivityHomeVisitState();
}

class _ConsultationFormActivityHomeVisitState
    extends State<ConsultationFormActivityHomeVisit> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  String problems, homeAddress, date, phone;
  String myMessage = "Submit";


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDate)
      setState(() {
        widget.selectedDate = picked;
        widget.selctedDate_ = picked.year.toString() +
            "-" +
            picked.month.toString() +
            "-" +
            picked.day.toString();
        setState(() {
          date = widget.selctedDate_;
        });
        //  showThisToast(selctedDate_);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "Me", 'isSelected': true});
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "My Child", 'isSelected': false});
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "Adult", 'isSelected': false});

      widget.diseasesType
          .add(<String, dynamic>{'name': "Allergies", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Cough,Cold", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Arthitis", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Asthma", 'isSelected': false});

      widget.conditionsType.add(<String, dynamic>{
        'name': "Alcohol use disorder",
        'isSelected': false
      });
      widget.conditionsType
          .add(<String, dynamic>{'name': "Alergies", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Arthitis", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Asthma", 'isSelected': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultation Form For Home Visit"),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Row(
                children: [

                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 0
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 1
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 2
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 3
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 4
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 5
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                              color: widget.currentPage == 6
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0,
                                ),
                              ]),
                        ),
                      )),
                ],
              ),
            ),
            Container(
                height: 600,
                child: PageView(
                  physics: new NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      widget.currentPage = index;
                    });
                  },
                  controller: _controller,
                  children: [
                    //24 nov
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            onChanged: (txt) {
                              widget.problems = txt;
                            },

                            decoration: InputDecoration(
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                labelText: "Problems"),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            initialValue: "",
                            onChanged: (txt) {
                              widget.address = txt;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                labelText: "Home Address"),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Container(
                            decoration: myBoxDecoration(),
                            child: ListTile(
                              onTap: () {
                                _selectDate(context);
                              },
                              trailing: Icon(Icons.arrow_downward),
                              title: Text(widget.selctedDate_),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            onChanged: (txt) {
                              widget.contact = txt;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.white10,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.pink)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                labelText: "Contact Number"),
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              //  widget.currentPage = old+1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Text(
                            "Patient Info",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                          child: Text(
                            "Who is this Visit for",
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.appointmentForUserType == null
                              ? 0
                              : widget.appointmentForUserType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      for (int i = 0;
                                      i <
                                          widget.appointmentForUserType
                                              .length;
                                      i++) {
                                        widget.appointmentForUserType[i]
                                        ["isSelected"] = false;
                                      }
                                      widget.appointmentForUserType[index]
                                      ["isSelected"] = true;
                                    });
                                  },
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value:
                                      widget.appointmentForUserType[index]
                                      ["isSelected"],
                                      activeColor: Colors.blue,
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                                      child: new Text(
                                        widget.appointmentForUserType[index]
                                        ["userType"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.name = value;
                                      },
                                      validator: (value) {
                                        widget.name = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Name';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Full Name",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.age = value;
                                      },
                                      validator: (value) {
                                        widget.age = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Age",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.gender = value;
                                      },
                                      validator: (value) {
                                        widget.gender = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Gender",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.gender = value;
                                      },
                                      validator: (value) {
                                        widget.gender = value;
                                        if (value.isEmpty) {
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Allergy",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              //  widget.currentPage = old+1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Reason for Visit",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "This information will help doctor to understand your problem more"),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.diseasesType == null
                              ? 0
                              : widget.diseasesType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.reasonForVisit =
                                      widget.diseasesType[index]["name"];

                                      widget.diseasesType[index]
                                      ["isSelected"] ==
                                          true
                                          ? (widget.diseasesType[index]
                                      ["isSelected"] = false)
                                          : widget.diseasesType[index]
                                      ["isSelected"] = true;
                                    });
                                  },
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value: widget.diseasesType[index]
                                      ["isSelected"],
                                      activeColor: Colors.blue,
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                      child: new Text(
                                        widget.diseasesType[index]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              // widget.currentPage = old+1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            });

                            // _controller.animateTo(MediaQuery
                            //     .of(context)
                            //     .size
                            //     .width, duration: new Duration(milliseconds: 300),
                            //     curve: Curves.easeIn);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Conditions",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "Have you ever diagonised with any of these conditions"),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.conditionsType == null
                              ? 0
                              : widget.conditionsType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.conditionsType[index]
                                      ["isSelected"] ==
                                          true
                                          ? (widget.conditionsType[index]
                                      ["isSelected"] = false)
                                          : widget.conditionsType[index]
                                      ["isSelected"] = true;

                                      widget.conditions = "";
                                      for (int i = 0;
                                      i < widget.conditionsType.length;
                                      i++) {
                                        if (widget.conditionsType[i]
                                        ["isSelected"]) {
                                          widget.conditions +=
                                              widget.diseasesType[i]["name"] +
                                                  " ";
                                        }
                                      }
                                    });
                                  },
                                  child: ListTile(
                                    trailing: Checkbox(
                                      value: widget.conditionsType[index]
                                      ["isSelected"],
                                      activeColor: Colors.blue,
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                      child: new Text(
                                        widget.conditionsType[index]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              int old = widget.currentPage;
                              widget.currentPage = old + 1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);

                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Medications",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child:
                          Text("Please disclose any Medications you take"),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                          child: Row(
                            children: [
                              Container(
                                width: 200,
                                child: TextFormField(
                                  onChanged: (value) {
                                    widget.tempMedName = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.medications
                                          .add(widget.tempMedName);
                                      widget.tempMedName = "";

                                      //  widget.conditions = "";
                                      for (int i = 0;
                                      i < widget.medications.length;
                                      i++) {
                                        widget.tempMedName +=
                                            widget.medications[i] + " ";
                                      }
                                    });
                                  },
                                  child: Card(
                                    color: Colors.blue,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.medications == null
                              ? 0
                              : widget.medications.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 10, 5),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // widget.diseasesType[index]["isSelected"] == true?( widget.diseasesType[index]["isSelected"] = false): widget.diseasesType[index]["isSelected"] = true;
                                    });
                                  },
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.medications.removeAt(index);
                                          });
                                        },
                                        child: Icon(Icons.close),
                                      ),
                                      title: Padding(
                                        padding:
                                        EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: new Text(
                                          widget.medications[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              widget.medicationsName = "";
                              for (int i = 0;
                              i < widget.medications.length;
                              i++) {
                                widget.medicationsName +=
                                    widget.medications[i] + " , ";
                              }

                              int old = widget.currentPage;
                              widget.currentPage = old + 1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);

                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Vitals",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "Would you like to share your vitals for this visit"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.weight = value;
                                      },
                                      validator: (value) {
                                        widget.weight = value;
                                        if (value.isEmpty) {
                                          return 'Weight in KG';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Weight in KG",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.temperature = value;
                                      },
                                      validator: (value) {
                                        widget.temperature = value;
                                        if (value.isEmpty) {
                                          return 'Temperature';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Temperature",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.bloodPressure = value;
                                      },
                                      validator: (value) {
                                        widget.bloodPressure = value;
                                        if (value.isEmpty) {
                                          return 'Blood Pressure';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Blood Pressure",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            setState(() {
                              widget.medicationsName = "";
                              for (int i = 0;
                              i < widget.medications.length;
                              i++) {
                                widget.medicationsName +=
                                    widget.medications[i] + " , ";
                              }

                              int old = widget.currentPage;
                              widget.currentPage = old + 1;
                              _controller.animateToPage(old + 1,
                                  duration: new Duration(milliseconds: 300),
                                  curve: Curves.easeIn);

                              // _controller.animateTo(MediaQuery
                              //     .of(context)
                              //     .size
                              //     .width, duration: new Duration(milliseconds: 300),
                              //     curve: Curves.easeIn);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Text(
                            "Allargy",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: Text(
                              "Please write here if you have any allargy"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            child: Center(
                              child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 189, 62, 68),
                                      ),
                                      initialValue: "",
                                      onChanged: (value) {
                                        widget.allergy = value;
                                      },
                                      validator: (value) {
                                        widget.weight = value;
                                        if (value.isEmpty) {
                                          return 'Allergyn';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                      Color.fromARGB(255, 189, 62, 68),
                                      decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 234, 234, 234),
                                          filled: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 234, 234, 234),
                                                width: 10.0),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 234, 234, 234),
                                                  width: 10.0)),
                                          labelText: "Allargy Information",
                                          focusColor:
                                          Color.fromARGB(255, 189, 62, 68),
                                          labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 189, 62, 68))),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                    ),
                                  )),
                            ),
                            height: 60,
                          ),
                        ),


                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Scaffold(
                                          appBar: AppBar(
                                            title: Text("Appointment Details"),
                                            backgroundColor: Colors.white,
                                          ),
                                          body: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(
                                                                      "Patient's Historty"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Patient Name"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .name),
                                                                )),
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Age and gender"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .age +
                                                                          " , " +
                                                                          widget
                                                                              .gender),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title:
                                                                  Text("Date"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .date),
                                                                )),
                                                            Expanded(
                                                                child: ListTile(
                                                                  title:
                                                                  Text("Time"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .time),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(
                                                                      "Medical History"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Reason for Visit"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .reasonForVisit),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Condition"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .conditions),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Allargy"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .allergy),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Medications"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .medicationsName),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(
                                                                      "Vitals"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Weight"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .weight),
                                                                )),
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Temparature"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .temperature),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Blood Pressure"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .date),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              10),
                                                          child: Stack(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                      5,
                                                                      0,
                                                                      0,
                                                                      0),
                                                                  child: Text(
                                                                      "Doctor's Profile"),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title:
                                                                  Text("Name"),
                                                                  subtitle: Text(
                                                                      widget
                                                                          .docName),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          height: 1,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child: ListTile(
                                                                  title: Text(
                                                                      "Consultation Fees"),
                                                                  //subtitle: Text(widget.fees),
                                                                  subtitle: Text(
                                                                      "No Fees"),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    color: Colors.blue,
                                                    elevation: 8,
                                                    child: InkWell(
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.all(
                                                              15),
                                                          child: Text(
                                                            "Submit",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        /*
                                                    var appointmentSubmitRespons =
                                                    await performAppointmentSubmitNewVersion(
                                                        AUTH_KEY,
                                                        UID,
                                                        widget.docID,
                                                        widget
                                                            .conditions,
                                                        "012",
                                                        widget.name,
                                                        null,
                                                        widget.date,
                                                        "0",
                                                        "n",
                                                        widget.time,
                                                        widget.age,
                                                        widget.gender,
                                                        widget
                                                            .reasonForVisit,
                                                        widget
                                                            .conditions,
                                                        widget
                                                            .medicationsName,
                                                        widget.weight,
                                                        widget
                                                            .temperature,
                                                        widget
                                                            .bloodPressure,
                                                        widget.fees);

                                                    //show dialog here like 1:30
                                                    //  oldWidget = widget;

                                                    String name =
                                                        widget.name;
                                                    String date =
                                                        widget.date;
                                                    String time =
                                                        widget.time;
                                                    String age = widget.age;
                                                    String gender =
                                                        widget.gender;
                                                    String reasonForVisit =
                                                        widget
                                                            .reasonForVisit;
                                                    String conditions =
                                                        widget.conditions;
                                                    String medicationsName =
                                                        widget
                                                            .medicationsName;
                                                    String weight =
                                                        widget.weight;
                                                    String temperature =
                                                        widget.temperature;
                                                    String bloodPressure =
                                                        widget
                                                            .bloodPressure;
                                                    String fees =
                                                        widget.fees;

                                                     */

                                                        final http
                                                            .Response response = await http
                                                            .post(
                                                          _baseUrl +
                                                              'add_home_appointment_info',
                                                          headers: header,
                                                          body: jsonEncode(
                                                              <String, String>{
                                                                'patient_id': UID,
                                                                'dr_id': widget
                                                                    .docID,
                                                                'problems': widget
                                                                    .problems,
                                                                'phone': widget
                                                                    .contact,
                                                                'date': widget
                                                                    .selctedDate_,
                                                                'home_address': widget
                                                                    .address,
                                                                'age': widget.age,
                                                                'gender': widget.gender,
                                                                'reasonToVisit':widget. problems,
                                                                'condition':widget. conditions,
                                                                'medications': widget.medicationsName,
                                                                'weight': widget.weight,
                                                                'temparature': widget.temperature,
                                                                'bloodPressure': widget.bloodPressure,
                                                                'fees': widget.fees,
                                                              }),
                                                        );

                                                        if(response.statusCode==200){



                                                          print(response.body);

                                                          Navigator.of(context).pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();

                                                          Navigator.of(context).pop();

                                                          //myFun();


                                                          //  Navigator.of(context).pop();
                                                          // mainP();


                                                          showModalBottomSheet(
                                                              context: useThisContext,
                                                              builder:
                                                                  (BuildContext
                                                              bc) {
                                                                return Container(
                                                                  child: new Wrap(
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                            10),
                                                                        child:
                                                                        Stack(
                                                                          children: [
                                                                            Align(
                                                                              alignment:
                                                                              Alignment
                                                                                  .centerRight,
                                                                              child:
                                                                              Icon(
                                                                                Icons
                                                                                    .close,color: Colors.white,),
                                                                            ),
                                                                            Align(
                                                                              alignment:
                                                                              Alignment
                                                                                  .center,
                                                                              child:
                                                                              Text(
                                                                                "Home Visit Booked",
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .grey,
                                                                                    fontSize: 25),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Center(
                                                                        child: Text(
                                                                            'Your request is successfully received.'),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                        Padding(
                                                                          padding: EdgeInsets
                                                                              .fromLTRB(
                                                                              10,
                                                                              10,
                                                                              10,
                                                                              20),
                                                                          child:
                                                                          InkWell(
                                                                            child:
                                                                            Container(
                                                                              width:
                                                                              double
                                                                                  .infinity,
                                                                              height:
                                                                              50,
                                                                              child:
                                                                              Center(
                                                                                child: Text(
                                                                                  "Close",
                                                                                  style: TextStyle(
                                                                                      fontSize: 15,
                                                                                      color: Colors
                                                                                          .blue,
                                                                                      fontWeight: FontWeight
                                                                                          .bold),
                                                                                ),
                                                                              ),
                                                                              decoration:
                                                                              ShapeDecoration(
                                                                                shape: CustomRoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .only(
                                                                                    bottomLeft: Radius
                                                                                        .circular(
                                                                                        5),
                                                                                    topLeft: Radius
                                                                                        .circular(
                                                                                        5),
                                                                                    bottomRight: Radius
                                                                                        .circular(
                                                                                        5),
                                                                                    topRight: Radius
                                                                                        .circular(
                                                                                        5),
                                                                                  ),
                                                                                  topSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  leftSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  bottomLeftCornerSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  topLeftCornerSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  topRightCornerSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  rightSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  bottomRightCornerSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                  bottomSide: BorderSide(
                                                                                      color: Colors
                                                                                          .blue),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(useThisContext).pop();

                                                                              /*

                                                                            Navigator
                                                                                .push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (
                                                                                        context) =>
                                                                                        Scaffold(
                                                                                          appBar: AppBar(
                                                                                            title: Text(
                                                                                                "Appointment Details"),
                                                                                            backgroundColor: Colors
                                                                                                .white,
                                                                                          ),
                                                                                          body: SingleChildScrollView(
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Padding(
                                                                                                  padding: EdgeInsets
                                                                                                      .all(
                                                                                                      10),
                                                                                                  child: Card(
                                                                                                    elevation: 8,
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets
                                                                                                              .all(
                                                                                                              10),
                                                                                                          child: Stack(
                                                                                                            children: [
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerLeft,
                                                                                                                child: Padding(
                                                                                                                  padding: EdgeInsets
                                                                                                                      .fromLTRB(
                                                                                                                      5,
                                                                                                                      0,
                                                                                                                      0,
                                                                                                                      0),
                                                                                                                  child: Text(
                                                                                                                      "Patient's Historty"),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerRight,
                                                                                                                child: Text(
                                                                                                                  "Edit",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors
                                                                                                                          .blue),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Patient Name"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .name),
                                                                                                                )),
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Age and gender"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .age +
                                                                                                                          " , " +
                                                                                                                          widget
                                                                                                                              .gender),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Date"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .date),
                                                                                                                )),
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Time"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .time),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets
                                                                                                      .all(
                                                                                                      10),
                                                                                                  child: Card(
                                                                                                    elevation: 8,
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets
                                                                                                              .all(
                                                                                                              10),
                                                                                                          child: Stack(
                                                                                                            children: [
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerLeft,
                                                                                                                child: Padding(
                                                                                                                  padding: EdgeInsets
                                                                                                                      .fromLTRB(
                                                                                                                      5,
                                                                                                                      0,
                                                                                                                      0,
                                                                                                                      0),
                                                                                                                  child: Text(
                                                                                                                      "Medical History"),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerRight,
                                                                                                                child: Text(
                                                                                                                  "Edit",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors
                                                                                                                          .blue),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Reason for Visit"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .reasonForVisit),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Condition"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .conditions),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Medications"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .medicationsName),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets
                                                                                                      .all(
                                                                                                      10),
                                                                                                  child: Card(
                                                                                                    elevation: 8,
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets
                                                                                                              .all(
                                                                                                              10),
                                                                                                          child: Stack(
                                                                                                            children: [
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerLeft,
                                                                                                                child: Padding(
                                                                                                                  padding: EdgeInsets
                                                                                                                      .fromLTRB(
                                                                                                                      5,
                                                                                                                      0,
                                                                                                                      0,
                                                                                                                      0),
                                                                                                                  child: Text(
                                                                                                                      "Vitals"),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerRight,
                                                                                                                child: Text(
                                                                                                                  "Edit",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors
                                                                                                                          .blue),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Weight"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .weight),
                                                                                                                )),
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Temparature"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .temperature),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Blood Pressure"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .date),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Padding(
                                                                                                  padding: EdgeInsets
                                                                                                      .all(
                                                                                                      10),
                                                                                                  child: Card(
                                                                                                    elevation: 8,
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets
                                                                                                              .all(
                                                                                                              10),
                                                                                                          child: Stack(
                                                                                                            children: [
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerLeft,
                                                                                                                child: Padding(
                                                                                                                  padding: EdgeInsets
                                                                                                                      .fromLTRB(
                                                                                                                      5,
                                                                                                                      0,
                                                                                                                      0,
                                                                                                                      0),
                                                                                                                  child: Text(
                                                                                                                      "Doctor's Profile"),
                                                                                                                ),
                                                                                                              ),
                                                                                                              Align(
                                                                                                                alignment: Alignment
                                                                                                                    .centerRight,
                                                                                                                child: Text(
                                                                                                                  "Edit",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors
                                                                                                                          .blue),
                                                                                                                ),
                                                                                                              )
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Name"),
                                                                                                                  subtitle: Text(
                                                                                                                      widget
                                                                                                                          .docName),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                        Divider(
                                                                                                          color: Colors
                                                                                                              .grey,
                                                                                                          height: 1,
                                                                                                        ),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                                child: ListTile(
                                                                                                                  title: Text(
                                                                                                                      "Consultation Fees"),
                                                                                                                  // subtitle: Text(widget.fees),
                                                                                                                  subtitle: Text(
                                                                                                                      "Fees"),
                                                                                                                )),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        )));

                                                                             */


                                                                            },
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        }else {

                                                        }

                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              color: Colors.blue,
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}


class ConsultationFormActivity extends StatefulWidget {
  int currentPage = 0;
  String name = "Aminul islam",
      age = "27",
      gender = "Male";

  List appointmentForUserType = [];
  List diseasesType = [];
  List conditionsType = [];
  List medications = [];
  String tempMedName = "";

  String weight = "66";
  String allergy = "No allargy";
  String temperature = "34 C";
  String bloodPressure = "120/80";
  String date;
  String dateLong;
  String s_time_key;

  String time;

  String reasonForVisit = "No reason selected";

  String conditions = "No conditions selected";

  String medicationsName = "No medicines selected";
  String docID;
  String docName;
  String fees;
  String hospital_id;

  ConsultationFormActivity(this.date, this.time, this.hospital_id,this.docID, this.docName,
      this.fees,this.dateLong,this.s_time_key);

  @override
  _ConsultationFormActivityState createState() =>
      _ConsultationFormActivityState();
}

class _ConsultationFormActivityState extends State<ConsultationFormActivity> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "Me", 'isSelected': true});
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "My Child", 'isSelected': false});
      widget.appointmentForUserType
          .add(<String, dynamic>{'userType': "Adult", 'isSelected': false});

      widget.diseasesType
          .add(<String, dynamic>{'name': "Allergies", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Cough,Cold", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Arthitis", 'isSelected': false});
      widget.diseasesType
          .add(<String, dynamic>{'name': "Asthma", 'isSelected': false});

      widget.conditionsType.add(<String, dynamic>{
        'name': "Alcohol use disorder",
        'isSelected': false
      });
      widget.conditionsType
          .add(<String, dynamic>{'name': "Alergies", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Arthitis", 'isSelected': false});
      widget.conditionsType
          .add(<String, dynamic>{'name': "Asthma", 'isSelected': false});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body :  Stack(
          children: [
            Positioned(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(

                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [Colors.blue, Colors.deepPurple])),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Container(
                  height: 60,
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 00, 20, 0),
                          child: Icon(Icons.chevron_left,color: Colors.white,size: 30,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 00, 20, 0),
                        child: Text("Consultation Form",style: TextStyle(fontSize: 20,color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ),

            ),
            Positioned(
              top: 85,
              left: 0,
              right: 0,
              bottom: 0,
              child:  Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),

                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 0
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 1
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 2
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 3
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 4
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                  ),
                                )),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 5
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(3),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueAccent,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                          height: 600,
                          child: PageView(
                            physics: new NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                widget.currentPage = index;
                              });
                            },
                            controller: _controller,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Text(
                                      "Patient Info",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
/*
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
                                    child: Text(
                                      "Who is this Visit for",
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.appointmentForUserType == null
                                        ? 0
                                        : widget.appointmentForUserType.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                for (int i = 0;
                                                i <
                                                    widget.appointmentForUserType
                                                        .length;
                                                i++) {
                                                  widget.appointmentForUserType[i]
                                                  ["isSelected"] = false;
                                                }
                                                widget.appointmentForUserType[index]
                                                ["isSelected"] = true;
                                              });
                                            },
                                            child: ListTile(
                                              trailing: Checkbox(
                                                value:
                                                widget.appointmentForUserType[index]
                                                ["isSelected"],
                                                activeColor: Colors.blue,
                                              ),
                                              title: Padding(
                                                padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                                                child: new Text(
                                                  widget.appointmentForUserType[index]
                                                  ["userType"],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  ),

 */


                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.name = value;
                                                },
                                                validator: (value) {
                                                  widget.name = value;
                                                  if (value.isEmpty) {
                                                    return 'Please enter Name';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Full Name",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.age = value;
                                                },
                                                validator: (value) {
                                                  widget.age = value;
                                                  if (value.isEmpty) {
                                                    return 'Please enter Email';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Age",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.gender = value;
                                                },
                                                validator: (value) {
                                                  widget.gender = value;
                                                  if (value.isEmpty) {
                                                    return 'Please enter Email';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Gender",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.gender = value;
                                                },
                                                validator: (value) {
                                                  widget.gender = value;
                                                  if (value.isEmpty) {
                                                    return 'Please enter Email';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Allergy",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        int old = widget.currentPage;
                                        //  widget.currentPage = old+1;
                                        _controller.animateToPage(old + 1,
                                            duration: new Duration(milliseconds: 300),
                                            curve: Curves.easeIn);
                                        // _controller.animateTo(MediaQuery
                                        //     .of(context)
                                        //     .size
                                        //     .width, duration: new Duration(milliseconds: 300),
                                        //     curve: Curves.easeIn);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        color: Colors.blue,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Text(
                                      "Reason for Visit",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    child: Text(
                                        "This information will help doctor to understand your problem more"),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.diseasesType == null
                                        ? 0
                                        : widget.diseasesType.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                widget.reasonForVisit =
                                                widget.diseasesType[index]["name"];

                                                widget.diseasesType[index]
                                                ["isSelected"] ==
                                                    true
                                                    ? (widget.diseasesType[index]
                                                ["isSelected"] = false)
                                                    : widget.diseasesType[index]
                                                ["isSelected"] = true;
                                              });
                                            },
                                            child: ListTile(
                                              trailing: Checkbox(
                                                value: widget.diseasesType[index]
                                                ["isSelected"],
                                                activeColor: Colors.blue,
                                              ),
                                              title: Padding(
                                                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                                child: new Text(
                                                  widget.diseasesType[index]["name"],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        int old = widget.currentPage;
                                        // widget.currentPage = old+1;
                                        _controller.animateToPage(old + 1,
                                            duration: new Duration(milliseconds: 300),
                                            curve: Curves.easeIn);
                                      });

                                      // _controller.animateTo(MediaQuery
                                      //     .of(context)
                                      //     .size
                                      //     .width, duration: new Duration(milliseconds: 300),
                                      //     curve: Curves.easeIn);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        color: Colors.blue,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Text(
                                      "Conditions",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    child: Text(
                                        "Have you ever diagonised with any of these conditions"),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.conditionsType == null
                                        ? 0
                                        : widget.conditionsType.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                widget.conditionsType[index]
                                                ["isSelected"] ==
                                                    true
                                                    ? (widget.conditionsType[index]
                                                ["isSelected"] = false)
                                                    : widget.conditionsType[index]
                                                ["isSelected"] = true;

                                                widget.conditions = "";
                                                for (int i = 0;
                                                i < widget.conditionsType.length;
                                                i++) {
                                                  if (widget.conditionsType[i]
                                                  ["isSelected"]) {
                                                    widget.conditions +=
                                                        widget.diseasesType[i]["name"] +
                                                            " ";
                                                  }
                                                }
                                              });
                                            },
                                            child: ListTile(
                                              trailing: Checkbox(
                                                value: widget.conditionsType[index]
                                                ["isSelected"],
                                                activeColor: Colors.blue,
                                              ),
                                              title: Padding(
                                                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                                child: new Text(
                                                  widget.conditionsType[index]["name"],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        int old = widget.currentPage;
                                        widget.currentPage = old + 1;
                                        _controller.animateToPage(old + 1,
                                            duration: new Duration(milliseconds: 300),
                                            curve: Curves.easeIn);

                                        // _controller.animateTo(MediaQuery
                                        //     .of(context)
                                        //     .size
                                        //     .width, duration: new Duration(milliseconds: 300),
                                        //     curve: Curves.easeIn);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        color: Colors.blue,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Text(
                                      "Medications",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    child:
                                    Text("Please disclose any Medications you take"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 5, 5, 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 200,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              widget.tempMedName = value;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                widget.medications
                                                    .add(widget.tempMedName);
                                                widget.tempMedName = "";

                                                //  widget.conditions = "";
                                                for (int i = 0;
                                                i < widget.medications.length;
                                                i++) {
                                                  widget.tempMedName +=
                                                      widget.medications[i] + " ";
                                                }
                                              });
                                            },
                                            child: Card(
                                              color: Colors.blue,
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    "Add",
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: widget.medications == null
                                        ? 0
                                        : widget.medications.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 10, 5),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                // widget.diseasesType[index]["isSelected"] == true?( widget.diseasesType[index]["isSelected"] = false): widget.diseasesType[index]["isSelected"] = true;
                                              });
                                            },
                                            child: Card(
                                              elevation: 5,
                                              color: Colors.white,
                                              child: ListTile(
                                                trailing: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      widget.medications.removeAt(index);
                                                    });
                                                  },
                                                  child: Icon(Icons.close),
                                                ),
                                                title: Padding(
                                                  padding:
                                                  EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  child: new Text(
                                                    widget.medications[index],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.medicationsName = "";
                                        for (int i = 0;
                                        i < widget.medications.length;
                                        i++) {
                                          widget.medicationsName +=
                                              widget.medications[i] + " , ";
                                        }

                                        int old = widget.currentPage;
                                        widget.currentPage = old + 1;
                                        _controller.animateToPage(old + 1,
                                            duration: new Duration(milliseconds: 300),
                                            curve: Curves.easeIn);

                                        // _controller.animateTo(MediaQuery
                                        //     .of(context)
                                        //     .size
                                        //     .width, duration: new Duration(milliseconds: 300),
                                        //     curve: Curves.easeIn);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        color: Colors.blue,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Text(
                                      "Vitals",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    child: Text(
                                        "Would you like to share your vitals for this visit"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.weight = value;
                                                },
                                                validator: (value) {
                                                  widget.weight = value;
                                                  if (value.isEmpty) {
                                                    return 'Weight in KG';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Weight in KG",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.temperature = value;
                                                },
                                                validator: (value) {
                                                  widget.temperature = value;
                                                  if (value.isEmpty) {
                                                    return 'Temperature';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Temperature",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.bloodPressure = value;
                                                },
                                                validator: (value) {
                                                  widget.bloodPressure = value;
                                                  if (value.isEmpty) {
                                                    return 'Blood Pressure';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Blood Pressure",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        widget.medicationsName = "";
                                        for (int i = 0;
                                        i < widget.medications.length;
                                        i++) {
                                          widget.medicationsName +=
                                              widget.medications[i] + " , ";
                                        }

                                        int old = widget.currentPage;
                                        widget.currentPage = old + 1;
                                        _controller.animateToPage(old + 1,
                                            duration: new Duration(milliseconds: 300),
                                            curve: Curves.easeIn);

                                        // _controller.animateTo(MediaQuery
                                        //     .of(context)
                                        //     .size
                                        //     .width, duration: new Duration(milliseconds: 300),
                                        //     curve: Curves.easeIn);
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        color: Colors.blue,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Text(
                                      "Allargy",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                    child: Text(
                                        "Please write here if you have any allargy"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Container(
                                      child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(0),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  color: Color.fromARGB(255, 189, 62, 68),
                                                ),
                                                initialValue: "",
                                                onChanged: (value) {
                                                  widget.allergy = value;
                                                },
                                                validator: (value) {
                                                  widget.weight = value;
                                                  if (value.isEmpty) {
                                                    return 'Allergyn';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                Color.fromARGB(255, 189, 62, 68),
                                                decoration: InputDecoration(
                                                    fillColor: Color.fromARGB(
                                                        255, 234, 234, 234),
                                                    filled: true,
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Color.fromARGB(
                                                              255, 234, 234, 234),
                                                          width: 10.0),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color.fromARGB(
                                                                255, 234, 234, 234),
                                                            width: 10.0)),
                                                    labelText: "Allargy Information",
                                                    focusColor:
                                                    Color.fromARGB(255, 189, 62, 68),
                                                    labelStyle: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 189, 62, 68))),
                                                keyboardType: TextInputType.emailAddress,
                                                autocorrect: false,
                                              ),
                                            )),
                                      ),
                                      height: 60,
                                    ),
                                  ),


                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>

                                                  Scaffold(
                                                    body: Stack(
                                                      children: [
                                                        Positioned(
                                                          child: Container(
                                                            height: double.infinity,
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                                gradient: LinearGradient(

                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.topRight,
                                                                    colors: [Colors.blue, Colors.deepPurple])),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          left: 0,
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                                                            child: Container(
                                                              height: 60,
                                                              child: Row(

                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(15, 00, 20, 0),
                                                                      child: Icon(Icons.chevron_left,color: Colors.white,size: 30,),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.fromLTRB(10, 00, 20, 0),
                                                                    child: Text("Appointment Details",style: TextStyle(fontSize: 20,color: Colors.white),),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                        ),
                                                        Positioned(
                                                          top: 85,
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 0,
                                                          child:  Card(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),

                                                            color: Colors.white,
                                                            child:SingleChildScrollView(
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Card(
                                                                      elevation: 8,
                                                                      child: Column(
                                                                        children: [



                                                                          Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                            child: Stack(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerLeft,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets
                                                                                        .fromLTRB(
                                                                                        5,
                                                                                        0,
                                                                                        0,
                                                                                        0),
                                                                                    child: Text(
                                                                                        "Patient's Historty"),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerRight,
                                                                                  child: Text(
                                                                                    "Edit",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .blue),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Patient Name"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .name),
                                                                                  )),
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Age and gender"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .age +
                                                                                            " , " +
                                                                                            widget
                                                                                                .gender),
                                                                                  )),
                                                                            ],
                                                                          ),

                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),

                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title:
                                                                                    Text("Date"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .dateLong),
                                                                                  )),
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title:
                                                                                    Text("Time"),
                                                                                    subtitle: Text(
                                                                                        widget.time),
                                                                                  )),
                                                                            ],
                                                                          ),


                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Card(
                                                                      elevation: 8,
                                                                      child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                            child: Stack(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerLeft,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets
                                                                                        .fromLTRB(
                                                                                        5,
                                                                                        0,
                                                                                        0,
                                                                                        0),
                                                                                    child: Text(
                                                                                        "Medical History"),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerRight,
                                                                                  child: Text(
                                                                                    "Edit",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .blue),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Reason for Visit"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .reasonForVisit),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Condition"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .conditions),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Allargy"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .allergy),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Medications"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .medicationsName),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Card(
                                                                      elevation: 8,
                                                                      child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                            child: Stack(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerLeft,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets
                                                                                        .fromLTRB(
                                                                                        5,
                                                                                        0,
                                                                                        0,
                                                                                        0),
                                                                                    child: Text(
                                                                                        "Vitals"),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerRight,
                                                                                  child: Text(
                                                                                    "Edit",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .blue),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Weight"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .weight),
                                                                                  )),
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Temparature"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .temperature),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Blood Pressure"),
                                                                                    subtitle: Text(
                                                                                        widget
                                                                                            .date),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Card(
                                                                      elevation: 8,
                                                                      child: Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                10),
                                                                            child: Stack(
                                                                              children: [
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerLeft,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets
                                                                                        .fromLTRB(
                                                                                        5,
                                                                                        0,
                                                                                        0,
                                                                                        0),
                                                                                    child: Text(
                                                                                        "Doctor's Profile"),
                                                                                  ),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment
                                                                                      .centerRight,
                                                                                  child: Text(
                                                                                    "Edit",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .blue),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title:
                                                                                    Text("Name"),
                                                                                    subtitle: Text(
                                                                                        "Doc name"),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            color: Colors.grey,
                                                                            height: 1,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                  child: ListTile(
                                                                                    title: Text(
                                                                                        "Consultation Fees"),
                                                                                    //subtitle: Text(widget.fees),
                                                                                    subtitle: Text(
                                                                                        "No Fees"),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.all(10),
                                                                    child: Card(
                                                                      color: Colors.blue,
                                                                      elevation: 8,
                                                                      child: InkWell(
                                                                        child: Center(
                                                                          child: Padding(
                                                                            padding:
                                                                            EdgeInsets.all(
                                                                                15),
                                                                            child: Text(
                                                                              "Submit",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontSize: 18),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onTap: () async {

                                                                          String uid =await getPatientID();
                                                                          int appointmentSubmitRespons =
                                                                          await performAppointmentSubmitNewVersion(
                                                                              AUTH_KEY,
                                                                              uid,
                                                                              widget.docID,
                                                                              widget
                                                                                  .conditions,
                                                                              "012",
                                                                              widget.name,
                                                                              null,
                                                                              widget.date,
                                                                              "0",
                                                                              "n",
                                                                              widget.time,
                                                                              widget.age,
                                                                              widget.gender,
                                                                              widget
                                                                                  .reasonForVisit,
                                                                              widget
                                                                                  .conditions,
                                                                              widget
                                                                                  .medicationsName,
                                                                              widget.weight,
                                                                              widget
                                                                                  .temperature,
                                                                              widget
                                                                                  .bloodPressure,
                                                                              widget.fees,
                                                                              widget.dateLong,
                                                                            widget.s_time_key,
                                                                            widget.hospital_id

                                                                          );

                                                                          //show dialog here like 1:30
                                                                          //  oldWidget = widget;

                                                                          String name =
                                                                              widget.name;
                                                                          String date =
                                                                              widget.date;
                                                                          String time =
                                                                              widget.time;
                                                                          String age = widget.age;
                                                                          String gender =
                                                                              widget.gender;
                                                                          String reasonForVisit =
                                                                              widget
                                                                                  .reasonForVisit;
                                                                          String conditions =
                                                                              widget.conditions;
                                                                          String medicationsName =
                                                                              widget
                                                                                  .medicationsName;
                                                                          String weight =
                                                                              widget.weight;
                                                                          String temperature =
                                                                              widget.temperature;
                                                                          String bloodPressure =
                                                                              widget
                                                                                  .bloodPressure;
                                                                          String fees =
                                                                              widget.fees;

                                                                          if (appointmentSubmitRespons ==
                                                                              200) {

                                                                            dynamic d = jsonEncode(
                                                                              <String, dynamic>{
                                                                                'notification': <String, dynamic>{
                                                                                  'title': "New Appointment Request",
                                                                                  'body':  widget.name+" has sent you an Appointment Request at "+widget.date+" "+widget.time
                                                                                },
                                                                                'priority': 'high',
                                                                                'data': <String, dynamic>{
                                                                                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                                                                  // 'doc_id': widget.UID,
                                                                                  // 'doc_name': widget.ownName,
                                                                                  // 'doc_photo': widget.ownPhoto,
                                                                                  'type': 'new_appointment',
                                                                                  //'room': widget.channelName
                                                                                },
                                                                                'to': "/topics/d" + widget.docID
                                                                              },
                                                                            );
                                                                            pushNotification(d);




                                                                            Navigator.of(context)
                                                                                .pop();
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                            Navigator.of(context)
                                                                                .pop();
                                                                            Navigator.of(context)
                                                                                .pop();

                                                                            Navigator.of(context)
                                                                                .pop();


                                                                            showModalBottomSheet(
                                                                                context: context,
                                                                                builder:
                                                                                    (BuildContext
                                                                                bc) {
                                                                                  return Container(
                                                                                    child: new Wrap(
                                                                                      children: <
                                                                                          Widget>[
                                                                                        Padding(
                                                                                          padding:
                                                                                          EdgeInsets
                                                                                              .all(
                                                                                              10),
                                                                                          child:
                                                                                          Stack(
                                                                                            children: [
                                                                                              Align(
                                                                                                alignment:
                                                                                                Alignment
                                                                                                    .centerRight,
                                                                                                child:
                                                                                                Icon(
                                                                                                  Icons
                                                                                                      .close,color: Colors.white,),
                                                                                              ),
                                                                                              Align(
                                                                                                alignment:
                                                                                                Alignment
                                                                                                    .center,
                                                                                                child:
                                                                                                Text(
                                                                                                  "Appointment Booked",
                                                                                                  style: TextStyle(
                                                                                                      color: Colors
                                                                                                          .grey,
                                                                                                      fontSize: 25),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Center(
                                                                                          child: Text(
                                                                                              'Appointment is Successfully Booked'),
                                                                                        ),
                                                                                        Center(
                                                                                          child:
                                                                                          Padding(
                                                                                            padding: EdgeInsets
                                                                                                .fromLTRB(
                                                                                                10,
                                                                                                10,
                                                                                                10,
                                                                                                20),
                                                                                            child:
                                                                                            InkWell(
                                                                                              child:
                                                                                              Container(
                                                                                                width:
                                                                                                double
                                                                                                    .infinity,
                                                                                                height:
                                                                                                50,
                                                                                                child:
                                                                                                Center(
                                                                                                  child: Text(
                                                                                                    "Close",
                                                                                                    style: TextStyle(
                                                                                                        fontSize: 15,
                                                                                                        color: Colors
                                                                                                            .blue,
                                                                                                        fontWeight: FontWeight
                                                                                                            .bold),
                                                                                                  ),
                                                                                                ),
                                                                                                decoration:
                                                                                                ShapeDecoration(
                                                                                                  shape: CustomRoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius
                                                                                                        .only(
                                                                                                      bottomLeft: Radius
                                                                                                          .circular(
                                                                                                          5),
                                                                                                      topLeft: Radius
                                                                                                          .circular(
                                                                                                          5),
                                                                                                      bottomRight: Radius
                                                                                                          .circular(
                                                                                                          5),
                                                                                                      topRight: Radius
                                                                                                          .circular(
                                                                                                          5),
                                                                                                    ),
                                                                                                    topSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    leftSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    bottomLeftCornerSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    topLeftCornerSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    topRightCornerSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    rightSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    bottomRightCornerSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                    bottomSide: BorderSide(
                                                                                                        color: Colors
                                                                                                            .blue),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              onTap:
                                                                                                  () {
                                                                                                    PatientLoginStream.getInstance().signIn("p");

                                                                                                /*
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          Scaffold(
                                                                                            appBar: AppBar(
                                                                                              title: Text(
                                                                                                  "Appointment Details"),
                                                                                              backgroundColor: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                            body: SingleChildScrollView(
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Patient's Historty"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Patient Name"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .name),
                                                                                                                  )),
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Age and gender"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .age +
                                                                                                                            " , " +
                                                                                                                            widget
                                                                                                                                .gender),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Date"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .date),
                                                                                                                  )),
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Time"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .time),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Medical History"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Reason for Visit"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .reasonForVisit),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Condition"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .conditions),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Medications"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .medicationsName),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Vitals"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Weight"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .weight),
                                                                                                                  )),
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Temparature"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .temperature),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Blood Pressure"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .date),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Doctor's Profile"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Name"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .docName),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Consultation Fees"),
                                                                                                                    // subtitle: Text(widget.fees),
                                                                                                                    subtitle: Text(
                                                                                                                        "Fees"),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )));

                                                                               */
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          } else {
                                                                            showThisToast(
                                                                                "API Failed");
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ) ,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )




                                              //change here please
                                              /*
                                                  Scaffold(
                                                    appBar: AppBar(
                                                      title: Text("Appointment Details"),
                                                      backgroundColor: Colors.white,
                                                    ),
                                                    /*
                                                    body: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Card(
                                                              elevation: 8,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                    child: Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .fromLTRB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child: Text(
                                                                                "Patient's Historty"),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child: Text(
                                                                            "Edit",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Patient Name"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .name),
                                                                          )),
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Age and gender"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .age +
                                                                                    " , " +
                                                                                    widget
                                                                                        .gender),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title:
                                                                            Text("Date"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .date),
                                                                          )),
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title:
                                                                            Text("Time"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .time),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Card(
                                                              elevation: 8,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                    child: Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .fromLTRB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child: Text(
                                                                                "Medical History"),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child: Text(
                                                                            "Edit",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Reason for Visit"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .reasonForVisit),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Condition"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .conditions),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Allargy"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .allergy),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Medications"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .medicationsName),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Card(
                                                              elevation: 8,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                    child: Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .fromLTRB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child: Text(
                                                                                "Vitals"),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child: Text(
                                                                            "Edit",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Weight"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .weight),
                                                                          )),
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Temparature"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .temperature),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Blood Pressure"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .date),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Card(
                                                              elevation: 8,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        10),
                                                                    child: Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child: Padding(
                                                                            padding: EdgeInsets
                                                                                .fromLTRB(
                                                                                5,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child: Text(
                                                                                "Doctor's Profile"),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerRight,
                                                                          child: Text(
                                                                            "Edit",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .blue),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title:
                                                                            Text("Name"),
                                                                            subtitle: Text(
                                                                                widget
                                                                                    .docName),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 1,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: ListTile(
                                                                            title: Text(
                                                                                "Consultation Fees"),
                                                                            //subtitle: Text(widget.fees),
                                                                            subtitle: Text(
                                                                                "No Fees"),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Card(
                                                              color: Colors.blue,
                                                              elevation: 8,
                                                              child: InkWell(
                                                                child: Center(
                                                                  child: Padding(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      "Submit",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 18),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () async {
                                                                  int appointmentSubmitRespons =
                                                                  await performAppointmentSubmitNewVersion(
                                                                      AUTH_KEY,
                                                                      UID,
                                                                      widget.docID,
                                                                      widget
                                                                          .conditions,
                                                                      "012",
                                                                      widget.name,
                                                                      null,
                                                                      widget.date,
                                                                      "0",
                                                                      "n",
                                                                      widget.time,
                                                                      widget.age,
                                                                      widget.gender,
                                                                      widget
                                                                          .reasonForVisit,
                                                                      widget
                                                                          .conditions,
                                                                      widget
                                                                          .medicationsName,
                                                                      widget.weight,
                                                                      widget
                                                                          .temperature,
                                                                      widget
                                                                          .bloodPressure,
                                                                      widget.fees);

                                                                  //show dialog here like 1:30
                                                                  //  oldWidget = widget;

                                                                  String name =
                                                                      widget.name;
                                                                  String date =
                                                                      widget.date;
                                                                  String time =
                                                                      widget.time;
                                                                  String age = widget.age;
                                                                  String gender =
                                                                      widget.gender;
                                                                  String reasonForVisit =
                                                                      widget
                                                                          .reasonForVisit;
                                                                  String conditions =
                                                                      widget.conditions;
                                                                  String medicationsName =
                                                                      widget
                                                                          .medicationsName;
                                                                  String weight =
                                                                      widget.weight;
                                                                  String temperature =
                                                                      widget.temperature;
                                                                  String bloodPressure =
                                                                      widget
                                                                          .bloodPressure;
                                                                  String fees =
                                                                      widget.fees;

                                                                  if (appointmentSubmitRespons ==
                                                                      200) {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    Navigator.of(context)
                                                                        .pop();

                                                                    Navigator.of(context)
                                                                        .pop();


                                                                    showModalBottomSheet(
                                                                        context: context,
                                                                        builder:
                                                                            (BuildContext
                                                                        bc) {
                                                                          return Container(
                                                                            child: new Wrap(
                                                                              children: <
                                                                                  Widget>[
                                                                                Padding(
                                                                                  padding:
                                                                                  EdgeInsets
                                                                                      .all(
                                                                                      10),
                                                                                  child:
                                                                                  Stack(
                                                                                    children: [
                                                                                      Align(
                                                                                        alignment:
                                                                                        Alignment
                                                                                            .centerRight,
                                                                                        child:
                                                                                        Icon(
                                                                                          Icons
                                                                                              .close,color: Colors.white,),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment:
                                                                                        Alignment
                                                                                            .center,
                                                                                        child:
                                                                                        Text(
                                                                                          "Appointment Booked",
                                                                                          style: TextStyle(
                                                                                              color: Colors
                                                                                                  .grey,
                                                                                              fontSize: 25),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Center(
                                                                                  child: Text(
                                                                                      'Appointment is Successfully Booked'),
                                                                                ),
                                                                                Center(
                                                                                  child:
                                                                                  Padding(
                                                                                    padding: EdgeInsets
                                                                                        .fromLTRB(
                                                                                        10,
                                                                                        10,
                                                                                        10,
                                                                                        20),
                                                                                    child:
                                                                                    InkWell(
                                                                                      child:
                                                                                      Container(
                                                                                        width:
                                                                                        double
                                                                                            .infinity,
                                                                                        height:
                                                                                        50,
                                                                                        child:
                                                                                        Center(
                                                                                          child: Text(
                                                                                            "Close",
                                                                                            style: TextStyle(
                                                                                                fontSize: 15,
                                                                                                color: Colors
                                                                                                    .blue,
                                                                                                fontWeight: FontWeight
                                                                                                    .bold),
                                                                                          ),
                                                                                        ),
                                                                                        decoration:
                                                                                        ShapeDecoration(
                                                                                          shape: CustomRoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius
                                                                                                .only(
                                                                                              bottomLeft: Radius
                                                                                                  .circular(
                                                                                                  5),
                                                                                              topLeft: Radius
                                                                                                  .circular(
                                                                                                  5),
                                                                                              bottomRight: Radius
                                                                                                  .circular(
                                                                                                  5),
                                                                                              topRight: Radius
                                                                                                  .circular(
                                                                                                  5),
                                                                                            ),
                                                                                            topSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            leftSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            bottomLeftCornerSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            topLeftCornerSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            topRightCornerSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            rightSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            bottomRightCornerSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                            bottomSide: BorderSide(
                                                                                                color: Colors
                                                                                                    .blue),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap:
                                                                                          () {
                                                                                        Navigator.of(useThisContext).pop();
                                                                                        /*
                                                                              Navigator
                                                                                  .push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                      builder: (
                                                                                          context) =>
                                                                                          Scaffold(
                                                                                            appBar: AppBar(
                                                                                              title: Text(
                                                                                                  "Appointment Details"),
                                                                                              backgroundColor: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                            body: SingleChildScrollView(
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Patient's Historty"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Patient Name"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .name),
                                                                                                                  )),
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Age and gender"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .age +
                                                                                                                            " , " +
                                                                                                                            widget
                                                                                                                                .gender),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Date"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .date),
                                                                                                                  )),
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Time"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .time),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Medical History"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Reason for Visit"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .reasonForVisit),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Condition"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .conditions),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Medications"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .medicationsName),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Vitals"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Weight"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .weight),
                                                                                                                  )),
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Temparature"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .temperature),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Blood Pressure"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .date),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: EdgeInsets
                                                                                                        .all(
                                                                                                        10),
                                                                                                    child: Card(
                                                                                                      elevation: 8,
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          Padding(
                                                                                                            padding: EdgeInsets
                                                                                                                .all(
                                                                                                                10),
                                                                                                            child: Stack(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: EdgeInsets
                                                                                                                        .fromLTRB(
                                                                                                                        5,
                                                                                                                        0,
                                                                                                                        0,
                                                                                                                        0),
                                                                                                                    child: Text(
                                                                                                                        "Doctor's Profile"),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Align(
                                                                                                                  alignment: Alignment
                                                                                                                      .centerRight,
                                                                                                                  child: Text(
                                                                                                                    "Edit",
                                                                                                                    style: TextStyle(
                                                                                                                        color: Colors
                                                                                                                            .blue),
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Name"),
                                                                                                                    subtitle: Text(
                                                                                                                        widget
                                                                                                                            .docName),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Divider(
                                                                                                            color: Colors
                                                                                                                .grey,
                                                                                                            height: 1,
                                                                                                          ),
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                  child: ListTile(
                                                                                                                    title: Text(
                                                                                                                        "Consultation Fees"),
                                                                                                                    // subtitle: Text(widget.fees),
                                                                                                                    subtitle: Text(
                                                                                                                        "Fees"),
                                                                                                                  )),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )));

                                                                               */
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          );
                                                                        });
                                                                  } else {
                                                                    showThisToast(
                                                                        "API Failed");
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                     */
                                                  )

                                               */

                                          ));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                        color: Colors.blue,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      /*
      body:
       */
    );
  }
}




//for home visit

//TabBarView
class SimpleDocProfileActivityHomeVisit extends StatefulWidget {
  dynamic profileData;

  SimpleDocProfileActivityHomeVisit(this.profileData);

  @override
  _SimpleDocProfileActivityHomeVisitState createState() =>
      _SimpleDocProfileActivityHomeVisitState();
}

class _SimpleDocProfileActivityHomeVisitState
    extends State<SimpleDocProfileActivityHomeVisit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        _baseUrl_image +
                                            widget.profileData["photo"],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.profileData["name"]
                                                .toString()
                                                .trim(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            widget
                                                .profileData["department_info"]
                                            ["name"],
                                            style: TextStyle(),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Home Visit Fees",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      // child: Text(widget.profileData["video_appointment_rate"].toString() + " £", style: TextStyle(),),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Specialization",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: Text(
                                  widget.profileData["designation_title"] ==
                                      null
                                      ? "No Information"
                                      : widget.profileData["designation_title"],
                                  style: TextStyle(),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConsultationFormActivityHomeVisit(
                                "" +
                                    "-" +
                                    "" +
                                    "-" +
                                    "",
                                "",
                                widget.profileData["id"].toString(),
                                "dr name",

                                " £")));
              },
              child: Card(
                color: Colors.blue,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Book For Home Visit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



void _filterModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text('Music'),
                  onTap: () => {}),
              new ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () => {},
              ),
            ],
          ),
        );
      });
}

class PendingpaymentsActivity extends StatefulWidget {
  @override
  PendingpaymentsActivityState createState() => PendingpaymentsActivityState();
}

class PendingpaymentsActivityState extends State<PendingpaymentsActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Pending Payments"),
      ),
    );
  }
}

Widget AmbulanceBodyWidget(dynamic ambulanceBody) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Ambulance"),
    ),
    body: ListView(
      children: <Widget>[
        Center(
          child: Image.asset(
            "assets/ambulance.png",
            width: 250,
            height: 250,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Title"),
              Text(ambulanceBody["Title"], style: TextStyle(color: tColor)),
              Text("phone"),
              Text(ambulanceBody["phone"], style: TextStyle(color: tColor)),
              Text("area"),
              Text(ambulanceBody["area"], style: TextStyle(color: tColor)),
              Text("address"),
              Text(ambulanceBody["address"], style: TextStyle(color: tColor)),
              Text("District"),
              Text(ambulanceBody["district_info"]["name"],
                  style: TextStyle(color: tColor)),
              Center(
                child: InkWell(
                  onTap: () {
                    launch("tel://" + ambulanceBody["phone"]);
                  },
                  child: Card(
                    color: Color(0xFF34448c),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text("Call Ambulance",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget AmbulanceWidget() {
  return Scaffold(
      appBar: AppBar(
        title: Text("Ambulances"),
      ),
      body: FutureBuilder(
          future: fetchAmbulance(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
              itemCount:
              projectSnap.data == null ? 0 : projectSnap.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AmbulanceBodyWidget(
                                      projectSnap.data[index])));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: Icon(Icons.directions_bus),
                          title: new Text(
                            projectSnap.data[index]["area"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            projectSnap.data[index]["address"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            );
          }));
}







bool isConfirmedLoading = true;

bool isPendingLoading = true;

List data_Confirmd;

Widget ConfirmedList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchConfirmed(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
              itemCount:
              projectSnap.data == null ? 0 : projectSnap.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://api.callgpnow.com/" +
                                    projectSnap.data[index]["dr_info"]
                                    ["photo"],
                              )),
                          title: new Text(
                            projectSnap.data[index]["dr_info"]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            projectSnap.data[index]["date"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            );
          }));
}

Widget PedingList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchPeding(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
              itemCount:
              projectSnap.data == null ? 0 : projectSnap.data.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: CircleAvatar(
                              backgroundImage: (projectSnap.data[index]
                              ["dr_info"] !=
                                  null)
                                  ? NetworkImage(
                                _baseUrl_image +
                                    projectSnap.data[index]
                                    ["dr_info"]["photo"],
                              )
                                  : (NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png"))),
                          title: new Text(
                            (projectSnap.data[index]["dr_info"] != null)
                                ? projectSnap.data[index]["dr_info"]
                            ["name"]
                                : ("No Doctor Name"),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: new Text(
                            projectSnap.data[index]["date"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            );
          }));
}

Future<dynamic> fetchConfirmed() async {
  // showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': USER_ID, 'status': "1"}),
  );

  if (response.statusCode == 200) {
    data_Confirmd = json.decode(response.body);
    isConfirmedLoading = false;
    //  showThisToast("size " + (data_Confirmd.length).toString());
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> fetchPeding() async {
  // showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': USER_ID, 'status': "0"}),
  );

  if (response.statusCode == 200) {
    data_Confirmd = json.decode(response.body);
    isConfirmedLoading = false;
    //  showThisToast("size " + (data_Confirmd.length).toString());
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}



Future<dynamic> fetchAmbulance() async {
  final http.Response response = await http.get(
    _baseUrl + 'view-ambulance',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
  );

  if (response.statusCode == 200) {
    List noti = json.decode(response.body);
    // showThisToast("noti sixe " + noti.length.toString());
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Blog"),
    );
  }
}

Widget myDrawer() {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          color: tColor,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 5),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_baseUrl_image + UPHOTO),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                    child: new Center(
                      child: Text(
                        UNAME,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )),
              ],
            ),
          ),
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/logo2.jpeg"),
          ),
          title: Text('Website'),
          onTap: () {
            const url = "https://abettahealth.com/";

            launch(url);
            //Share.share("https://www.facebook.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/facebook.png"),
          ),
          title: Text('Facebook'),
          onTap: () {
            const url =
                "https://web.facebook.com/Betta-Health-112876333823426/";

            launch(url);
            //Share.share("https://www.facebook.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/twitter.png"),
          ),
          title: Text('Twitter'),
          onTap: () {
            const url = "https://twitter.com/HealthBetta";

            launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/info.png"),
          ),
          title: Text('Privacy Policy'),
          onTap: () {
            const url = "https://abettahealth.com/privacy-policy/";

            launch(url);
            // Share.share("https://www.twitter.com");
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/logout.png"),
          ),
          title: Text('Logout'),
          onTap: () {
            //setLoginStatus(false);
            //runApp(LoginUI());
            UserAuthStream.getInstance().signOut();
          },
        ),
        ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset("assets/logout.png"),
          ),
          title: Text('MOVE TO DOC'),
          onTap: () {
            //setLoginStatus(false);
            //runApp(LoginUI());
            UserAuthStream.getInstance().changeUserTYPE("d");
          },
        ),
      ],
    ),
  );
}

class DeptOnlineActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Department (Online)"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
        ],
      ),
      body: DeptListOnlineDocWidget(),
    );
  }
}

Widget BlogDetailsWidget(blogdata) {
  return Scaffold(
    appBar: AppBar(
      title: Text(blogdata["title"].toString()),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          (blogdata["youtube_video"] == null)
              ? Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Image.network(
                _baseUrl_image + blogdata["photo_info"][0]["photo"]),
          )
              : Container(
            height: 250,
            child: MyHomePageYoutube(),
          ),
          Text(
            blogdata["body"].toString(),
          )
        ],
      ),
    ),
  );
}

class ChatListActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Chat List"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
        ],
      ),
      body: ChatListWidget(context),
    );
  }
}



class BasicProfileActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Information"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
              child: Image.network(
                "https://cdnph.upi.com/svc/sv/upi/7371577364249/2019/1/054ab8e380c0922db843a715455feaf7/Gal-Gadot-to-co-produce-adaptation-of-novel-banned-in-Israeli-schools.jpg",
                width: 150,
                height: 150,
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Card(
              child: ListTile(
                onTap: () {
                  showNameEditDialog(context);
                },
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(00, 00, 00, 00),
                  child: Text(UNAME),
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
            ),
          )
        ],
      ),
    );
  }
}



Future<void> showNameEditDialog(BuildContext context) async {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      initialValue: USER_NAME,
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
                var status = updateDisplayName(AUTH_KEY, UID, newName);
                status.then((value) =>
                    () {
                  prefs.setString("uname", newName);
                  Navigator.of(context).pop();
                });
              }
            },
          ),
        ],
      );
    },
  );
}

Widget ChatListWidget(BuildContext context) {
  // String UID = USER_ID;

  // showThisToast("user id " + UID);

  // FirebaseDatabase.instance.reference().child("xploreDoc").once()
  return Scaffold(
    body: FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child("xploreDoc")
            .child("lastChatHistory")
            .child(UID)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.value != null) {
            List lists = [];
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              lists.add(values);
            });
            //   showThisToast("chat histoory siz " + (lists.length).toString());
            return lists.length > 0
                ? new ListView.builder(
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      String own_id = UID;
                      String own_name = USER_NAME;
                      OWN_PHOTO = USER_PHOTO;
                      String partner_id = "";
                      String partner_name = "";
                      String parner_photo = "";

                      if (UID == (lists[index]["sender_id"])) {
                        partner_id = lists[index]["recever_id"];
                        partner_name = lists[index]["receiver_name"];
                        parner_photo = lists[index]["receiver_photo"];
                      } else {
                        partner_id = lists[index]["sender_id"];
                        partner_name = lists[index]["sender_name"];
                        parner_photo = lists[index]["sender_photo"];
                      }

                      String own_photo = UPHOTO;
                      PARTNER_PHOTO = parner_photo;

                      String chatRoom = createChatRoomName(
                          int.parse(UID), int.parse(partner_id));
                      CHAT_ROOM = chatRoom;
                      //   showThisToast("chat room " + CHAT_ROOM);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(
                                      partner_id,
                                      partner_name,
                                      parner_photo,
                                      UID,
                                      UNAME,
                                      UPHOTO,
                                      chatRoom,
                                      "scheduled")));
                    },
                    child: Card(
                        child: (UID ==
                            ((lists[index]["sender_id"])
                                .toString())) //im this ms sender
                            ? ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://api.callgpnow.com/" +
                                    lists[index]["receiver_photo"],
                              )),
                          title: Text(lists[index]["receiver_name"]),
                          subtitle: (lists[index]["message_body"])
                              .toString()
                              .startsWith("http")
                              ? Text("Photo")
                              : Text((lists[index]["message_body"])
                              .toString()),
                        )
                            : ListTile(
                          leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://api.callgpnow.com/" +
                                    lists[index]["sender_photo"],
                              )),
                          title: Text(lists[index]["sender_name"]),
                          subtitle: (lists[index]["message_body"])
                              .toString()
                              .startsWith("http")
                              ? Text("Photo")
                              : Text((lists[index]["message_body"])
                              .toString()),
                        )),
                  );
                })
                : Center(
              child: Text("No Chat History"),
            );
          } else {
            //showThisToast(snapshot.data.value.toString());
          }
          return Center(
            child: Text("No Chat History"),
          );
        }),
  );
}

String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
  }
}

Widget getChatList() {
  final dbRef = FirebaseDatabase.instance.reference().child("xploreDoc");
}

class DiseasesWidget extends StatefulWidget {
  @override
  _DiseasesWidgetState createState() => _DiseasesWidgetState();
}

class _DiseasesWidgetState extends State<DiseasesWidget> {
  List diseasesList = [];
  DateTime selectedDate = DateTime.now();
  String selctedDate_ = DateTime.now().toIso8601String();
  String dateToUpdate = (DateTime
      .now()
      .year).toString() +
      "-" +
      (DateTime
          .now()
          .month).toString() +
      "-" +
      (DateTime
          .now()
          .day).toString();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selctedDate_ = selectedDate.toIso8601String();
        dateToUpdate = (picked.year).toString() +
            "-" +
            (picked.month).toString() +
            "-" +
            (picked.day).toString();
      });
  }

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'patient-disease-record',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'patient_id': UID}),
    );
    this.setState(() {
      diseasesList = json.decode(response.body);
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diseaes History"),
      ),
      body: (diseasesList != null && diseasesList.length > 0)
          ? new ListView.builder(
        itemCount: diseasesList == null ? 0 : diseasesList.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {},
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(05),
                  child: ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    leading: Icon(Icons.accessible_forward),
                    title: new Text(
                      diseasesList[index]["disease_name"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text(
                      diseasesList[index]["first_notice_date"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
        },
      )
          : Container(
          height: 200,
          child: Center(
            child: Text("No Diseases History"),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // error

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddDiseasesActivity(function: (data) {
                        //  showThisToast("im hit hit hit wioth "+data);
                        setState(() {});
                      })));
/*
          final _formKey = GlobalKey<FormState>();
          String diseaesName, currentStatus, firstNoticeDate;
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Diseases Information'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Diseases name"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                              child: TextFormField(
                                validator: (value) {
                                  diseaesName = value;
                                  if (value.isEmpty) {
                                    return 'Please enter Diseases Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text("First notice date"),
                            RaisedButton(
                              onPressed: () => _selectDate(context),
                              child: Text('Select date'),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                                child: Text(dateToUpdate)),
                            Text("Current status"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                              child: TextFormField(
                                validator: (value) {
                                  currentStatus = value;
                                  if (value.isEmpty) {
                                    return 'Please enter current status';
                                  }
                                  return null;
                                },
                              ),
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
                        var status = addDiseasesHistory(
                            diseaesName, dateToUpdate, currentStatus);

                        status.then((value) => this.closeAndUpdate(context));
                      }
                    },
                  ),
                ],
              );
            },
          );
          */
        },
      ),
    );
  }
}

class PrescriptionsWidget extends StatefulWidget {
  @override
  _PrescriptionsWidgetState createState() => _PrescriptionsWidgetState();
}

class _PrescriptionsWidgetState extends State<PrescriptionsWidget> {
  List prescriptionList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-prescription-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': A_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionList = json.decode(response.body);
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription History"),
      ),
      body: (prescriptionList != null && prescriptionList.length > 0)
          ? new ListView.builder(
        itemCount: prescriptionList == null ? 0 : prescriptionList.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {
                List attachment = prescriptionList[index]["attachment"];
                if (attachment != null && attachment.length > 0) {
                  //  showThisToast("analog");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PrescriptionsodyWidget(
                                  prescriptionList[index])));
                } else {
                  // showThisToast("digital");
                  print(prescriptionList[index]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Scaffold(
                                appBar: AppBar(
                                  title: Text("Digital Prescription"),
                                ),
                                body: ListView(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: Text("Doctor's Comment"),
                                        subtitle: Text(
                                            prescriptionList[index]
                                            ["diseases_name"]),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            15, 10, 10, 10),
                                        child: Text(
                                          "Prescribed Medicines",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    medicinesListOfAPrescriptionWidget(
                                        prescriptionList[index]),
                                  ],
                                ),
                              )));
                }
                print(prescriptionList[index]);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(05),
                  child: ListTile(
                    trailing: Icon(Icons.arrow_right),
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          _baseUrl_image +
                              ((prescriptionList[index]["dr_info"] == null ||
                                  prescriptionList[index]["dr_info"]
                                  ["photo"] ==
                                      null)
                                  ? ""
                                  : prescriptionList[index]["dr_info"]
                              ["photo"]),
                        )),
                    title: new Text(
                      (prescriptionList[index]["dr_info"] == null
                          ? "No Doctor Name"
                          : prescriptionList[index]["dr_info"]["name"]),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text(
                      prescriptionList[index]["created_at"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
        },
      )
          : Container(
          height: 200,
          child: Center(
            child: Text("No Prescription History"),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final _formKey = GlobalKey<FormState>();
          String diseaesName;
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Prescription'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Diseases Name"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(00, 00, 00, 10),
                              child: TextFormField(
                                validator: (value) {
                                  diseaesName = value;
                                  if (value.isEmpty) {
                                    return 'Please enter diseases name';
                                  }
                                  return null;
                                },
                              ),
                            )
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
                      child: Text('Choose Photo From Gallary'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          File image = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          var stream = new http.ByteStream(
                              DelegatingStream.typed(image.openRead()));
                          var length = await image.length();

                          var uri = Uri.parse(
                              _baseUrl + "add_prescription_photo_only");

                          var request = new http.MultipartRequest("POST", uri);
                          var multipartFile = new http.MultipartFile(
                              'photo', stream, length,
                              filename: basename(image.path));
                          //contentType: new MediaType('image', 'png'));

                          request.files.add(multipartFile);
                          request.fields
                              .addAll(<String, String>{'patient_id': UID});
                          request.fields.addAll(
                              <String, String>{'diseases_name': diseaesName});
                          request.headers.addAll(header);
                          //     showThisToast(request.toString());

                          var response = await request.send();

                          print(response.statusCode);
                          //   showThisToast(response.statusCode.toString());
                          this.closeAndUpdate(context);
                        }
                      })
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Widget medicinesListOfAPrescriptionWidget(medicineList) {
  return medicineList != null
      ? ListView.builder(
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
    itemCount: medicineList["medicine_info"] == null
        ? 0
        : medicineList["medicine_info"].length,
    itemBuilder: (BuildContext context, int index2) {
      return new InkWell(
          onTap: () {},
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ListTile(
                  leading: Icon(Icons.label_important),
                  title: new Text(medicineList["medicine_info"][index2]
                  ["medicine_name_info"]["name"]),
                  subtitle: createMedicineDoseWid(
                      medicineList["medicine_info"][index2]["dose"]
                          .toString(),
                      medicineList["medicine_info"][index2]
                      ["duration_type"],
                      medicineList["medicine_info"][index2]
                      ["duration_length"]
                          .toString(),
                      medicineList["medicine_info"][index2]["isAfterMeal"]
                          .toString()),
                ),
              )));
    },
  )
      : Center(
    child: Text("Please Wait"),
  );
}

Widget createMedicineDoseWid(String string, String duration_type,
    String duration_length, String isAfterMeal) {
  String dosesText = "";
  List doses = string.split("-");

  if (doses[0] == "1") dosesText = dosesText + "Morning";
  if (doses[1] == "1") dosesText = dosesText + " Noon";
  if (doses[2] == "1") dosesText = dosesText + " Evening";

  dosesText = dosesText + "\n" + " " + duration_length;
  if (duration_type == 'd') dosesText = dosesText + " Days";
  if (duration_type == 'w') dosesText = dosesText + " Weeks";
  if (duration_type == 'm') dosesText = dosesText + " Months";

  if (isAfterMeal == '1') dosesText = dosesText + "\n After Meal";
  if (isAfterMeal == '0') dosesText = dosesText + "\n Before Meal";

  return Text(dosesText);
}

class PrescriptionsodyWidget extends StatefulWidget {
  dynamic prescriptionBody;

  PrescriptionsodyWidget(this.prescriptionBody);

  @override
  _PrescriptionsBodyWidgetState createState() =>
      _PrescriptionsBodyWidgetState();
}

class _PrescriptionsBodyWidgetState extends State<PrescriptionsodyWidget> {
  List prescriptionList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-prescription-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': USER_ID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionList = json.decode(response.body);
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prescription Body"),
      ),
      body: (widget.prescriptionBody["attachment"] != null
          ? Image.network(
          _baseUrl_image + widget.prescriptionBody["attachment"][0]["file"])
          : Text("Digital Prescription")),
    );
  }
}

Widget PrescriptionsRevieBodyWidget(dynamic reviewRequest) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Review Request"),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Column(
                children: <Widget>[
                  Text("Old Prescription"),
                  ListTile(
                    title: Text("Doctors Comment"),
                    subtitle: Text(""),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class PrescriptionsReviedBodyState extends StatefulWidget {
  dynamic prescriptionReview;

  PrescriptionsReviedBodyState(this.prescriptionReview);

  @override
  _PrescriptionsReviedBodyState createState() =>
      _PrescriptionsReviedBodyState();
}

class _PrescriptionsReviedBodyState
    extends State<PrescriptionsReviedBodyState> {
  List prescriptionReviewList = [];
  dynamic singlePrescription;
  dynamic newPrescription;

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-my-recheck-requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      //showThisToast(prescriptionReviewList.toString());
    });
    return "Success!";
  }

  Future<String> getSinglePrescription() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': widget.prescriptionReview["old_prescription_id"].toString(),
      }),
    );
    this.setState(() {
      print("Single Prescriptin");
      singlePrescription = json.decode(response.body);

      print(singlePrescription);
    });
    return "Success!";
  }

  Future<String> getNewPrescription() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': widget.prescriptionReview["new_prescription_id"].toString(),
      }),
    );
    this.setState(() {
      print("Single Prescriptin");
      newPrescription = json.decode(response.body);

      print(newPrescription);
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    print("review page api hit starts");
    print("orescription id " +
        widget.prescriptionReview["old_prescription_id"].toString());

    this.getData();
    this.getSinglePrescription();
    this.getNewPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Review Request"),
        ),
        body: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(0),
                child: Card(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                          child: Text(
                            "New Prescription",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                        child: ListTile(
                          title: Text("Doctors Comment"),
                          subtitle: Text(newPrescription != null
                              ? newPrescription["diseases_name"]
                              : "Loading"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                        child: Text("Medicines"),
                      ),
                      medicinesListOfAPrescriptionWidget(newPrescription)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: Card(
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                          child: Text(
                            "Old Prescription",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                        child: ListTile(
                          title: Text("Doctors Comment"),
                          subtitle: Text(singlePrescription != null
                              ? singlePrescription["diseases_name"]
                              : "Loading"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                        child: Text("Medicines"),
                      ),
                      medicinesListOfAPrescriptionWidget(singlePrescription)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class TestRecomendationWidget extends StatefulWidget {
  @override
  _TestRecomendationState createState() => _TestRecomendationState();
}

class _TestRecomendationState extends State<TestRecomendationWidget> {
  List prescriptionReviewList = [];

  Future<String> getData() async {
    // showThisToast("user id " + UID);
    final http.Response response = await http.post(
      _baseUrl + 'test-recommendation-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'patient_id': UID}),
    );
    //showThisToast(response.statusCode.toString());
    //showThisToast(response.body);
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      // showThisToast(prescriptionReviewList.toString());
    });
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Test Recommendation"),
      ),
      body: (prescriptionReviewList != null &&
          prescriptionReviewList.length > 0)
          ? new ListView.builder(
        itemCount: prescriptionReviewList == null
            ? 0
            : prescriptionReviewList.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TestRecomendationView(
                                prescriptionReviewList[index])));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(05),
                  child: ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_baseUrl_image +
                          prescriptionReviewList[index]["dr_info"]
                          ["photo"]),
                    ),
                    title: new Text(
                      (prescriptionReviewList[index]["dr_info"] == null
                          ? "No Doctor Name"
                          : prescriptionReviewList[index]["dr_info"]
                      ["name"]),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text(
                      prescriptionReviewList[index]["problems"]
                          .toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
        },
      )
          : Container(
          height: 200,
          child: Center(
            child: Text("No Prescription Review History"),
          )),
    );
  }
}

class TestRecomendationView extends StatefulWidget {
  dynamic testRecomBody;

  TestRecomendationView(this.testRecomBody);

  @override
  _TestRecomendationViewWidgetState createState() =>
      _TestRecomendationViewWidgetState();
}

class _TestRecomendationViewWidgetState extends State<TestRecomendationView> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Recommendation Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text("Problems"),
              subtitle: Text(widget.testRecomBody["problems"]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text("Recommened Tests"),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.testRecomBody["test_recommendation_info"] ==
                    null
                    ? 0
                    : widget.testRecomBody["test_recommendation_info"].length,
                itemBuilder: (BuildContext context, int index) {
                  return new InkWell(
                    onTap: () {
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) =>
//                                  TestRecomendationView(
//                                      prescriptionReviewList[index])));
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(00.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(05),
                          child: ListTile(
                            subtitle: new Text(
                                widget.testRecomBody["test_recommendation_info"]
                                [index]["test_info"]["type"]),
                            // trailing: Icon(Icons.keyboard_arrow_right),
                            leading: Icon(Icons.label_important),
                            title: new Text(
                              widget.testRecomBody["test_recommendation_info"]
                              [index]["test_info"]["name"],
                            ),
                          ),
                        )),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class PrescriptionsReviewWidget extends StatefulWidget {
  @override
  _PrescriptionsReviewWidgetState createState() =>
      _PrescriptionsReviewWidgetState();
}

class _PrescriptionsReviewWidgetState extends State<PrescriptionsReviewWidget> {
  List prescriptionReviewList = [];

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-my-recheck-requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
    );
    //showThisToast(response.statusCode.toString());
    // showThisToast(response.body);
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      // showThisToast(prescriptionReviewList.toString());
    });
    print(response.body);
    return "Success!";
  }

  void closeAndUpdate(BuildContext context) {
    Navigator.of(context).pop();
    this.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Review Request"),
      ),
      body: (prescriptionReviewList != null &&
          prescriptionReviewList.length > 0)
          ? new ListView.builder(
        itemCount: prescriptionReviewList == null
            ? 0
            : prescriptionReviewList.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {
                print(prescriptionReviewList[index]);
                if (prescriptionReviewList[index]["is_reviewed"] == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PrescriptionsReviewBodyWidget2(
                                  prescriptionReviewList[index])));

//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    PrescriptionsReviedBodyState(
//                                        prescriptionReviewList[index])));
                } else
                  showThisToast("Not Reviewed Yet");
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(05),
                  child: ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(_baseUrl_image +
                          prescriptionReviewList[index]["dr_info"]
                          ["photo"]),
                    ),
                    title: new Text(
                      (prescriptionReviewList[index]["dr_info"] == null
                          ? "No Doctor Name"
                          : prescriptionReviewList[index]["dr_info"]
                      ["name"]),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text(
                      prescriptionReviewList[index]["is_reviewed"] == 1
                          ? "Review Done"
                          : "Review Pending",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ));
        },
      )
          : Container(
          height: 200,
          child: Center(
            child: Text("No Prescription Review History"),
          )),
    );
  }
}

class PrescriptionsReviewBodyWidget2 extends StatefulWidget {
  dynamic prescriptionReview;

  PrescriptionsReviewBodyWidget2(this.prescriptionReview);

  @override
  _PrescriptionsReviewBodyWidget2State createState() =>
      _PrescriptionsReviewBodyWidget2State();
}

class _PrescriptionsReviewBodyWidget2State
    extends State<PrescriptionsReviewBodyWidget2> {
  List prescriptionReviewList = [];
  dynamic oldPrescription;
  dynamic newPrescription;

  Future<String> getData() async {
    final http.Response response = await http.post(
      _baseUrl + 'get-my-recheck-requests',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'id': UID, 'user_type': 'patient'}),
    );
    this.setState(() {
      prescriptionReviewList = json.decode(response.body);
      //showThisToast(prescriptionReviewList.toString());
    });
    return "Success!";
  }

  Future<String> getOldPrescription() async {
    // showThisToast(widget.prescriptionReview["old_prescription_id"].toString());

    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': widget.prescriptionReview["old_prescription_id"].toString(),
      }),
    );
    this.setState(() {
      print("Single Prescriptin");
      oldPrescription = json.decode(response.body);

      print(oldPrescription);
    });
    //  showThisToast(response.statusCode.toString());
    return "Success!";
  }

  Future<String> getNewPrescription() async {
    final http.Response response = await http.post(
      _baseUrl + 'get_single_prescription_info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{
        'id': widget.prescriptionReview["new_prescription_id"].toString(),
      }),
    );
    // showThisToast("new pr download "+response.statusCode.toString());

    this.setState(() {
      print("Single Prescriptin");
      newPrescription = json.decode(response.body);

      print(newPrescription);
    });
    return "Success!";
  }

  @override
  void initState() {
    // TODO: implement initState
    print("review page api hit starts");
    print("orescription id " +
        widget.prescriptionReview["old_prescription_id"].toString());

    // this.getData();
    this.getOldPrescription();
    this.getNewPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Review From Doctor"),
              bottom: new PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: new Container(
                  height: 50.0,
                  child: new TabBar(
                    tabs: [
                      Tab(
                        text: "Summery",
                      ),
                      Tab(
                        text: "Old Prescription",
                      ),
                      Tab(text: "New Prescription"),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Patient's Comment :"),
                      Text(widget.prescriptionReview["patient_comment"]),
                      Text("Doctors's Comment :"),
                      Text(widget.prescriptionReview["dr_comment"].toString()),
                    ],
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                      child: ListTile(
                        title: Text("Doctors Comment"),
                        subtitle: Text(oldPrescription != null
                            ? oldPrescription["diseases_name"]
                            : "Loading"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text("Medicines"),
                    ),
                    medicinesListOfAPrescriptionWidget(oldPrescription)
                  ],
                ),
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
                      child: ListTile(
                        title: Text("Doctors Comment"),
                        subtitle: Text(newPrescription != null
                            ? newPrescription["diseases_name"]
                            : "Loading"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                      child: Text("Medicines"),
                    ),
                    medicinesListOfAPrescriptionWidget(newPrescription)
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class HomeVisitViewPagerWid extends StatefulWidget {
  @override
  _HomeVisitViewPagerWidState createState() => _HomeVisitViewPagerWidState();
}

class _HomeVisitViewPagerWidState extends State<HomeVisitViewPagerWid> {
  double latitude;

  double longitude;

  String address;

  int selected = 0;
  String currentLocation = "Current location";

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()
      ..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = p[0];
      //  showThisToast("${place.locality}, ${place.postalCode}, ${place.country}");
      setState(() {
        currentLocation =
        "${place.name}, ${place.postalCode}, ${place.country}";
        //currentLocation = place.locality;
        address = "${place.name}, ${place.postalCode}, ${place.country}";
        //address =place.administrativeArea;
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget buildPageView(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 60,
          child: HomeVisitsDoctorsList(address),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              color: Colors.white,
              height: 60,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (latitude != null)
                        ? Text(currentLocation)
                        : Text("Getting your location"),
                    FlatButton(
                      onPressed: () async {
                        Prediction prediction = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0",
                            mode: Mode.overlay,
                            // Mode.overlay
                            language: "en",
                            components: [Component(Component.country, "bd")]);
                        //    showThisToast((prediction.description).toString());
                        GoogleMapsPlaces _places = new GoogleMapsPlaces(
                            apiKey:
                            "AIzaSyB9H70aVLc4R14l6aUVqkLRhrvJvVszBZ0"); //Same API_KEY as above
                        PlacesDetailsResponse detail = await _places
                            .getDetailsByPlaceId(prediction.placeId);

                        // double latitude = detail.result.geometry.location.lat;
                        // double longitude = detail.result.geometry.location.lng;
                        String address = prediction.description;
                        //  showThisToast(address);

                        setState(() {
                          currentLocation = address;
                          latitude = detail.result.geometry.location.lat;
                          longitude = detail.result.geometry.location.lng;
                        });
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 00, 0),
                          child: Text("Change",
                              style: TextStyle(
                                  color: tColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14))),
                    )
                  ],
                ),
              )),
        ),
        Positioned(
          right: 00,
          bottom: 60,
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: InkWell(
                  onTap: () {
                    final Geolocator geolocator = Geolocator()
                      ..forceAndroidLocationManager;

                    geolocator
                        .getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.best)
                        .then((Position position) {
                      List<LatLng> _sharedMarkerLocations = [];
                      for (int i = 0; i < ALL_HOME_DOC_LIST.length; i++) {
                        if (ALL_HOME_DOC_LIST[i]["home_lat"] > 0 &&
                            ALL_HOME_DOC_LIST[i]["home_log"] > 0) {
                          _sharedMarkerLocations.add(new LatLng(
                              double.parse((ALL_HOME_DOC_LIST[i]["home_lat"]
                                  .toString())),
                              double.parse((ALL_HOME_DOC_LIST[i]["home_log"]
                                  .toString()))));
                        }
                      }
                      print(position.latitude);
                      print(position.longitude);
                      if (position == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePageMapCl(
                                      _sharedMarkerLocations, position),
                            ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomePageMapCl(
                                      _sharedMarkerLocations, position),
                            ));
                      }
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Card(
                      color: tColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                color: Colors.white,
                              ),
                              Text("View on Map",
                                  style: TextStyle(color: Colors.white))
                            ],
                          ))))),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Choose Doctor"),
      ),
      body: buildPageView(context),
    );
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}