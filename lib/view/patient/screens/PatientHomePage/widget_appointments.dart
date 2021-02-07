import 'dart:convert';

import 'package:maulaji/chat/model/chat_screen.dart';
import 'package:maulaji/projPaypal/config.dart';
import 'package:maulaji/view/patient/sharedActivitys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";
class Appointment extends StatefulWidget {
  List pastList = [];
  List upCommingList = [];
  dynamic all_info;

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> with WidgetsBindingObserver {
  getVdoAppDataPast() async {

    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
      var  body = <String, String>{'user_type': "patient", 'id': prefs.getString("uid")};
        String apiResponse =
        await makePostReq("get_video_appointment_past", prefs.getString("auth"), body);
        // showThisToast(apiResponse);
        this.setState(() {
          widget.pastList = json.decode(apiResponse);
          //  showThisToast("past size "+widget.pastList.length.toString());
          // lastApiHitted2 = DateTime.now().millisecondsSinceEpoch;
        });


  }

  getVdoAppDataUpComming() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    body = <String, String>{'user_type': "patient", 'id': prefs.getString("uid")};
    String apiResponse = await makePostReq("get_video_appointment_upcomming", prefs.getString("auth"), body);
        this.setState(() {
          widget.upCommingList = json.decode(apiResponse);
          // showThisToast("upcomming size "+widget.pastList.length.toString());
          // lastApiHitted2 = DateTime.now().millisecondsSinceEpoch;
        });


  }

  @override
  void initState() {
    // TODO: implement initState

    // this.myFun();

    super.initState();
    this.getVdoAppDataPast();
    this.getVdoAppDataUpComming();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        //showThisToast("app in resumed 2");
        this.getVdoAppDataPast();
        this.getVdoAppDataUpComming();

        break;
      case AppLifecycleState.inactive:
        print("app in inactive");

        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        print("app in detached");

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: new Container(
                color: Colors.blue,
                height: 50.0,
                child: new TabBar(
                  indicatorColor: Colors.pink,
                  tabs: [
                    Tab(text: "Upcomming",),
                    Tab(text: "Past"),
                  ],
                ),
              ),
            ),
            body: TabBarView(

              children: [
                // ConfirmedList(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.upCommingList == null
                        ? 0
                        : widget.upCommingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        onTap: () async{
                          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;
                          widget.all_info =
                              json.decode(widget
                                  .upCommingList[index]["all_info"]);

                          String chatRoom = createChatRoomName(int.parse(prefs.getString("uid")),
                              widget.upCommingList[index]["dr_info"]["id"]);
                          CHAT_ROOM = chatRoom;
                          // showThisToast(chatRoom);
                          // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child: Text(
                                                                    "Patient's Historty"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                        .upCommingList[
                                                                    index]["name"]),
                                                              )),
                                                          Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                    "Age and gender"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info["age"]
                                                                        .toString() +
                                                                        " , " +
                                                                        widget
                                                                            .all_info[
                                                                        "gender"]),
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
                                                                    "Date"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .upCommingList[
                                                                    index]["date"]),
                                                              )),
                                                          Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                    "Time"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .upCommingList[
                                                                    index]["time"]),
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child: Text(
                                                                    "Medical History"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                        .all_info[
                                                                    "reasonToVisit"]),
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
                                                                Text(
                                                                    "Condition"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info[
                                                                    "condition"]),
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
                                                                Text(
                                                                    "Medications"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info[
                                                                    "medications"]),
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child:
                                                                Text("Vitals"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                        .all_info[
                                                                    "weight"]),
                                                              )),
                                                          Expanded(
                                                              child: ListTile(
                                                                title:
                                                                Text(
                                                                    "Temparature"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info[
                                                                    "temparature"]),
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
                                                                        .all_info[
                                                                    "bloodPressure"]),
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child: Text(
                                                                    "Doctor's Profile"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                    "Name"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .upCommingList[
                                                                    index]
                                                                    ["dr_info"]
                                                                    ["name"]),
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
                                                                subtitle:
                                                                Text("No Fees"),
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
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(widget.upCommingList[index]
                                        ["date"] +
                                            " " +
                                            widget
                                                .upCommingList[index]["time"]),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(widget.upCommingList[index]
                                        ["status"] ==
                                            1
                                            ? "Compleated"
                                            : "Pending"),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.upCommingList[index]["dr_info"]
                                        ["photo"] ==
                                            null
                                            ? ""
                                            : _baseUrl_image +
                                            widget.upCommingList[index]
                                            ["dr_info"]["photo"]),
                                  ),
                                  title: Text(
                                      widget.upCommingList[index]["dr_info"]
                                      ["name"]),
                                  subtitle: Text(
                                    "View Details",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  trailing: InkWell(
                                    onTap: () async{
                                      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                                      SharedPreferences prefs = await _prefs;
                                      String chatRoom = createChatRoomName(

                                          int.parse(prefs.getString("uid")),
                                          widget.upCommingList[index]["dr_info"]
                                          ["id"]);
                                      CHAT_ROOM = chatRoom;
                                      //showThisToast(chatRoom);
                                      // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatScreen(
                                                      widget
                                                          .upCommingList[index]
                                                      ["dr_info"]["id"]
                                                          .toString(),
                                                      widget
                                                          .upCommingList[index]
                                                      ["dr_info"]["name"],
                                                      _baseUrl_image +
                                                          widget
                                                              .upCommingList[index]
                                                          ["dr_info"]["photo"],
                                                      prefs.getString("uid"),
                                                      prefs.getString("uname"),
                                                      prefs.getString("uphoto"),
                                                      chatRoom,
                                                      "scheduled")));
                                    },
                                    child: Text(
                                      "Open Chat",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ),
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //PedingList(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.pastList == null ? 0 : widget.pastList
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        onTap: () async{
                          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                          SharedPreferences prefs = await _prefs;
                          widget.all_info =
                              json.decode(widget.pastList[index]["all_info"]);

                          String chatRoom = createChatRoomName(int.parse(prefs.getString("uid")),
                              widget.pastList[index]["dr_info"]["id"]);
                          CHAT_ROOM = chatRoom;
                          // showThisToast(chatRoom);
                          // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child: Text(
                                                                    "Patient's Historty"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                        .pastList[index]
                                                                    ["name"]),
                                                              )),
                                                          Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                    "Age and gender"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info["age"]
                                                                        .toString() +
                                                                        " , " +
                                                                        widget
                                                                            .all_info[
                                                                        "gender"]),
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
                                                                    "Date"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .pastList[index]
                                                                    ["date"]),
                                                              )),
                                                          Expanded(
                                                              child: ListTile(
                                                                title: Text(
                                                                    "Time"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .pastList[index]
                                                                    ["time"]),
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child: Text(
                                                                    "Medical History"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                        .all_info[
                                                                    "reasonToVisit"]),
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
                                                                Text(
                                                                    "Condition"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info[
                                                                    "condition"]),
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
                                                                Text(
                                                                    "Medications"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info[
                                                                    "medications"]),
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child:
                                                                Text("Vitals"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                        .all_info[
                                                                    "weight"]),
                                                              )),
                                                          Expanded(
                                                              child: ListTile(
                                                                title:
                                                                Text(
                                                                    "Temparature"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .all_info[
                                                                    "temparature"]),
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
                                                                        .all_info[
                                                                    "bloodPressure"]),
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
                                                        padding: EdgeInsets.all(
                                                            10),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    5, 0, 0, 0),
                                                                child: Text(
                                                                    "Doctor's Profile"),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                "",
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
                                                                    "Name"),
                                                                subtitle: Text(
                                                                    widget
                                                                        .pastList[index]
                                                                    [
                                                                    "dr_info"]["name"]),
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
                                                                subtitle:
                                                                Text("No Fees"),
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
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                            widget.pastList[index]["date"] +
                                                " " +
                                                widget.pastList[index]["time"]),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                            widget.pastList[index]["status"] ==
                                                1
                                                ? "Compleated"
                                                : "Pending"),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.pastList[index]["dr_info"]
                                        ["photo"] ==
                                            null
                                            ? ""
                                            : _baseUrl_image +
                                            widget.pastList[index]["dr_info"]
                                            ["photo"]),
                                  ),
                                  title: Text(
                                      widget
                                          .pastList[index]["dr_info"]["name"]),
                                  subtitle: Text(
                                    "Send a Message",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  trailing: InkWell(
                                    onTap: () async{
                                      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                                      SharedPreferences prefs = await _prefs;
                                      String chatRoom = createChatRoomName(
                                          int.parse(prefs.getString("uid")),
                                          widget
                                              .pastList[index]["dr_info"]["id"]);
                                      CHAT_ROOM = chatRoom;
                                      //showThisToast(chatRoom);
                                      // showThisToast(_baseUrl_image+data[index]["dr_info"]["photo"]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatScreen(
                                                      widget
                                                          .pastList[index]["dr_info"]
                                                      ["id"]
                                                          .toString(),
                                                      widget
                                                          .pastList[index]["dr_info"]
                                                      ["name"],
                                                      _baseUrl_image +
                                                          widget.pastList[index]
                                                          ["dr_info"]["photo"],
                                                      prefs.getString("uid"),
                                                      prefs.getString("uname"),
                                                      prefs.getString("uphoto"),
                                                      chatRoom,
                                                      "scheduled")));
                                    },
                                    child: Text(
                                      "Open Chat",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ),
                                ]),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}