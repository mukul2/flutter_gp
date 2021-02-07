import 'dart:convert';

import 'package:maulaji/cachedData.dart';
import 'package:maulaji/chat/model/chat_screen.dart';
import 'package:maulaji/projPaypal/config.dart';
import 'package:maulaji/view/patient/OnlineDoctorsList.dart';
import 'package:maulaji/view/patient/departments_for_online_doc.dart';
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/GPlistSearchActivity/ui.dart';
import 'package:maulaji/view/patient/sharedActivitys.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";
var OWN_PHOTO;
String AUTH_KEY;
String A_KEY;
String UPHOTO;
String UEMAIL;
String UID;
String UNAME;
String UPHONE;
var PARTNER_PHOTO;
class Home extends StatefulWidget {

  List deptList = [];
  List videoAppList = [];
  List upCommingList = [];
  dynamic all_info;

  @override
  _HomeState createState() => _HomeState();
}

bool _enabled = true;
int apiHitCount = 0;

class _HomeState extends State<Home> {
  getData() async {
    if(cachedDeptList==null){
      print("api hit => "+"department-list");
      final http.Response response = await http.post(
        "https://api.callgpnow.com/api/" + 'department-list',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': AUTH_KEY,
        },
      );
      setState(() {
        cachedDeptList = json.decode(response.body);
        widget.deptList = json.decode(response.body);
        widget.deptList = widget.deptList.sublist(0, 4);
      });
    }else{
      setState(() {
        print("loaded from cache");
        widget.deptList = cachedDeptList;
        widget.deptList = widget.deptList.sublist(0, 4);
      });
    }




    // data_ = json.decode(response.body);

    // showThisToast("dept size "+response.body);
  }

  getVdoAppDataUpComming() async {
    print("api hit => "+"get_video_appointment_upcomming");
    var  body = <String, String>{'user_type': "patient", 'id': UID};
        String apiResponse = await makePostReq(
            "get_video_appointment_upcomming", AUTH_KEY, body);
        // showThisToast(apiResponse);
        this.setState(() {
          widget.upCommingList = json.decode(apiResponse);
          // showThisToast("upcomming size "+widget.pastList.length.toString());
          // lastApiHitted2 = DateTime.now().millisecondsSinceEpoch;
        });


  }

  getVdoAppData() async {

    print("api hit => "+"get_video_appointment_list");
        body = <String, String>{
          'user_type': "patient",
          'isFollowup': "0",
          'id': UID
        };
        String apiResponse =
        await makePostReq("get_video_appointment_list", AUTH_KEY, body);
        this.setState(() {
          widget.videoAppList = json.decode(apiResponse);
          // showThisToast("this time video app size "+widget.videoAppList.length.toString());
        });


  }

  myFun() {
    //showThisToast("Im hit");

  }

  final _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.myFun();
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 60;
    var _aspectRatio = _width / cellHeight;
    return SingleChildScrollView(
        child: Column(

          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                elevation: 10,
                child: ListTile(
                  onTap: () {
                    /*
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecialistDoctorSearchActivity(),
                        ));

                     */
                  },
                  leading: Icon(Icons.search),
                  title: Text("Search Doctor"),
                ),
              ),
            ),

            Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RealtimeOnlineDoctors(),
                          ));

                    },
                    title: Text("Get Urgent Care"),
                    leading: Icon(
                      Icons.work,
                      color: Colors.orange,
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      color: Colors.orange,
                    ),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                )),
            Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeVisitViewPagerWid(),
                          ));
                    },
                    title: Text("Home Care"),
                    leading: Icon(
                      Icons.work,
                      color: Colors.orange,
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      color: Colors.orange,
                    ),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ]),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                      title: Text("Consult a Physician"),
                      leading: Icon(
                        Icons.work,
                        color: Colors.orange,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeptListOnlineDocWidget(),
                              ));
                        },
                        child: Text(
                          "See All",
                          style: TextStyle(color: Colors.orange),
                        ),
                      )),
                  FutureBuilder(
                      future: getData(),
                      builder: (context, projectSnap) {
                        return new GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              childAspectRatio: _aspectRatio),
                          shrinkWrap: true,
                          itemCount:
                          widget.deptList == null ? 0 : widget.deptList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChooseDoctorOnline(
                                                    (widget
                                                        .deptList[index]["id"])
                                                        .toString())));
                                  },
                                  child: Container(
                                    height: 50,
                                    child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: new Text(
                                            widget.deptList[index]["name"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(00, 0, 0, 0),
              child: ListTile(
                title: Text("Appointments"),
                leading: Icon(
                  Icons.calendar_today,
                  color: Colors.orange,
                ),
                trailing: Text(
                  "See All",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
            FutureBuilder(
                future: getVdoAppDataUpComming(),
                builder: (context, projectSnap) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: widget.upCommingList == null
                        ? 0
                        : widget.upCommingList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                        onTap: () {
                          widget.all_info =
                              json.decode(widget
                                  .upCommingList[index]["all_info"]);

                          String chatRoom = createChatRoomName(int.parse(UID),
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
                                    onTap: () {
                                      String chatRoom = createChatRoomName(
                                          int.parse(UID),
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
                                                      UID,
                                                      UNAME,
                                                      UPHOTO,
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
                  );
                }),

          ],
        ));
  }
}





String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
  }
}