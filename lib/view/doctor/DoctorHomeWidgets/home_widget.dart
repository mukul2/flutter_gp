
import 'dart:convert';

import 'package:maulaji/myCalling/VoiceCall.dart';
import 'package:maulaji/myCalling/call.dart';
import 'package:maulaji/myCalling/jitsiCall.dart';
import 'package:maulaji/myCalling/videoCall.dart';
import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/projPaypal/config.dart';
import 'package:maulaji/view/patient/SubscriptionsActivityPatient.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../RawApi.dart';
import '../../../main.dart';
import '../../patientprofile_d.dart';
import '../doctor_view.dart';
class DoctorHomeWidget extends StatefulWidget {
  List cachedData1 ;
  List cachedData2 ;
  List cachedData3 ;
  int currentPage = 0 ;
  String uname="";
  String photo="";

  DoctorHomeWidget();
  @override
  _DoctorHomeWidgetState createState() =>
      _DoctorHomeWidgetState();
}

class _DoctorHomeWidgetState extends State<DoctorHomeWidget> {
  PageController _controller = PageController(
    initialPage: 0,
  );




  loadSession() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;

    setState(() {
      widget.uname = prefs.getString("uname");
      widget. photo= prefs.getString("uphoto")==null?"https://www.clker.com/cliparts/d/L/P/X/z/i/no-image-icon-md.png":prefs.getString("uphoto");
      print( widget. photo);
      print( widget. uname);
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   this.loadSession();
    downloadMyScheduledList().then((value) => {
      this.setState(() {
        widget.cachedData1 = value;
      })
    });

    downloadMyHomeVisitList().then((value) => {
      this.setState(() {
        widget.cachedData3 = value;
      })
    });

    downloadUrgentList().then((value) => {
      this.setState(() {
        widget.cachedData2 = value;
      })
    });
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        //_navigateToItemDetail(message);
        print("on launch " + message.toString());
        if (message["data"]["type"] == "new_appointment" ) {
         // showThisToast("came 1");

        initState();



        } else {

        }
      },

      onResume: (Map<String, dynamic> message) async {
        print("on resume " + message.toString());

        if (message["data"]["type"] == "new_appointment" ) {
         // showThisToast("came 2");
          initState();
        } else {
          // showThisToast("unknown type");
        }


      },

      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {

        if (message["data"]["type"] == "new_appointment" ) {
          //showThisToast("came 3");
          initState();

        } else {

        }


      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print( "printing");
    print( widget. photo);
    print( widget. uname);
    return Scaffold(
     // backgroundColor: Color.fromARGB(255, 234, 236, 238),

        body : SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                child: Row(

                  children: [
                   // Image.network(widget. photo,width: 50,height: 50,fit: BoxFit.cover,),


                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                          onTap: (){

                            _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },

                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Container(
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Scheduled",style: TextStyle(color: widget.currentPage == 0 ? Colors.white :primaryColor),),
                              )),
                              // height: 5,
                              decoration: BoxDecoration(
                                  color: widget.currentPage == 0
                                      ? primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  shape: BoxShape.rectangle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor,
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ]),
                            ),
                          ),
                        )),
                    Expanded(
                        child: InkWell(
                          onTap: (){
                            _controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Container(
                              child: Center(child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("Urgent Care",style: TextStyle(color: widget.currentPage == 1 ? Colors.white :primaryColor),),
                              )),

                              decoration: BoxDecoration(
                                  color: widget.currentPage == 1
                                      ? primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  shape: BoxShape.rectangle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor,
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ]),
                            ),
                          ),
                        )),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          _controller.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Container(
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Home Visit",style: TextStyle(color: widget.currentPage == 2 ? Colors.white : primaryColor),),
                            )),

                            decoration: BoxDecoration(
                                color: widget.currentPage == 2
                                    ? primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor,
                                    blurRadius: 1.0,
                                    spreadRadius: 1.0,
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: 700,
                  child: PageView(
                  //  physics: new NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        widget.currentPage = index;
                      });
                    },
                    controller: _controller,
                    children: [

                      widget.cachedData1==null?Center(child: CircularProgressIndicator(),): (  true?  ListView.separated(
                          separatorBuilder: (_ , __ ) => Divider(height:1),
                          itemCount:
                          widget.cachedData1 == null ? 0 : widget.cachedData1.length,
                          itemBuilder: (BuildContext context, int index){
                            return ListTile(

                              trailing: Wrap(
                                children: [


                                  InkWell(
                                    onTap: ()async{

                                      String doc_id =await  getDoctor_id();
                                      String uname=await  getUserName();
                                      String uphoto=await  getUserPhoto();
                                      String chatRoom = createChatRoomName(
                                          int.parse(doc_id),
                                          int.parse(widget.cachedData1[index]["patient"].toString())

                                      );
                                      CHAT_ROOM = chatRoom;
                                      chatRoom =widget.cachedData1[index]["patient"].toString()+"-"+doc_id;
                                      // await for camera and mic permissions before pushing video page

                                      await _handleCameraAndMic();
                                      print("roomId="+chatRoom);
                                      //showThisToast(chatRoom);
                                      sendPush(doc_id, uname, uphoto, chatRoom, "p"+widget.cachedData1[index]["patient"].toString(),1);
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JitsiCall(
                                              chatRoom, true
                                          ),
                                        ),
                                      );
                                      // push video page with given channel name
                                      /*

                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CallPageVideo(
                                                  channelName: "roomId="+chatRoom,

                                                  isCameraOn: true,
                                                  UID: doc_id,
                                                  ownName: uname,
                                                  ownPhoto:uphoto,
                                                  partnerID: "p"+widget.cachedData1[index]["patient"].toString(),
                                                  partnerPhoto: widget.cachedData1[index]["patientname"],
                                                  isCaller: true,
                                                  intentType: "",

                                                ),
                                              ),
                                            );

                                       */


                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.video_call,color: Colors.red),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: ()async{







                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PatientProfileViewForDoctor(widget.cachedData1[index]),
                                        ),
                                      );




                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.menu,color: Colors.red),
                                    ),
                                  ),

                                ],
                              ),


                              title: Text(widget.cachedData1[index]["patientname"]),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(widget.cachedData1[index]["time_slot"],style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                              ),
                            );
                          }
                      ):Center(child: Text("No Scheduled Appointments"))),

                      widget.cachedData2==null?Center(child: CircularProgressIndicator(),):(  widget.cachedData2.length>0?  ListView.separated(
                          separatorBuilder: (_ , __ ) => Divider(height:1),
                          itemCount:
                          widget.cachedData2 == null ? 0 :widget.cachedData2.length,
                          itemBuilder: (BuildContext context, int index){
                            return ListTile(
                              trailing: Wrap(
                                children: [

                                  InkWell(
                                    onTap: ()async{
                                      String uid =await  getUserID();
                                      String doc_id =await  getDoctor_id();
                                      String uname=await  getUserName();
                                      String uphoto=await  getUserPhoto();
                                      String chatRoom = createChatRoomName(
                                          int.parse(uid),
                                          int.parse(widget.cachedData2[index]["patient_id"].toString())

                                      );
                                      CHAT_ROOM = chatRoom;
                                     // showThisToast("p"+widget.cachedData2[index]["patient"].toString());
                                      // await for camera and mic permissions before pushing video page
                                      await _handleCameraAndMic();
                                      print("roomId="+chatRoom);


                                      // push video page with given channel name
                                     // showThisToast("p"+widget.cachedData2[index]["patient_id"].toString());
                                      chatRoom =widget.cachedData2[index]["patient_id"].toString()+"-"+doc_id;
                                      sendPush(doc_id, uname, uphoto, chatRoom, "p"+widget.cachedData2[index]["patient_id"].toString(),1);

                                      //  showThisToast(chatRoom);
                                     // showThisToast(chatRoom);
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JitsiCall(
                                              chatRoom,true
                                          ),
                                        ),
                                      );

                                      /*
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CallPageVideo(
                                            channelName: "roomId="+chatRoom,

                                            isCameraOn: true,
                                            UID: uid,
                                            ownName: uname,
                                            ownPhoto:uphoto,
                                            partnerID: "p"+widget.cachedData2[index]["patient_id"].toString(),
                                            partnerPhoto: widget.cachedData2[index]["patientname"],
                                            isCaller: true,
                                            intentType: "",

                                          ),
                                        ),
                                      );

                                       */


                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.video_call,color: Colors.red),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: ()async{
                                      String uid =await  getUserID();
                                      String doc_id =await  getDoctor_id();
                                      String uname=await  getUserName();
                                      String uphoto=await  getUserPhoto();
                                      String chatRoom = createChatRoomName(
                                          int.parse(uid),
                                          int.parse(widget.cachedData2[index]["patient_id"].toString())

                                      );
                                      CHAT_ROOM = chatRoom;
                                      chatRoom =widget.cachedData2[index]["patient_id"].toString()+"-"+doc_id;

                                     // showThisToast(chatRoom);
                                      // await for camera and mic permissions before pushing video page
                                      await _handleCameraAndMic();
                                      print("roomId="+chatRoom);
                                      // push video page with given channel name
                                      sendPush(doc_id, uname, uphoto, chatRoom, "p"+widget.cachedData2[index]["patient_id"].toString(),0);

                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JitsiCall(
                                              chatRoom, false
                                          ),
                                        ),
                                      );
                                      /*

                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CallPageAudio(
                                            channelName: "roomId="+chatRoom,

                                            isCameraOn: true,
                                            UID: uid,
                                            ownName: uname,
                                            ownPhoto:uphoto,
                                            partnerID:"p"+ widget.cachedData2[index]["patient_id"].toString(),
                                            partnerPhoto: widget.cachedData2[index]["patientname"],
                                            isCaller: true,
                                            intentType: "",

                                          ),
                                        ),
                                      );

                                       */


                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.call,color: Colors.red),
                                    ),
                                  ),



                                ],
                              ),
                              title: Text(widget.cachedData2[index]["patient_name"]),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text( widget.cachedData2[index]["created_at"] ,style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                              ),
                            );
                          }
                      ):Center(child: Text("No Urgent Appointments"))),
                      widget.cachedData3==null?Center(child: CircularProgressIndicator(),): (  widget.cachedData3.length>0? ListView.separated(
                          separatorBuilder: (_ , __ ) => Divider(height:1),
                          itemCount:
                          widget.cachedData3 == null ? 0 : widget.cachedData3.length,
                          itemBuilder: (BuildContext context, int index){
                            return ListTile(
                              trailing: Wrap(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Icon(Icons.call,color: Colors.blue),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Icon(Icons.message,color: Colors.blue),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Icon(Icons.note_add,color: Colors.blue),
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Icon(Icons.navigate_next,color: Colors.blue),
                                  // ),
                                ],
                              ),
                              title: Text(widget.cachedData3[index]["patient_name"]),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(widget.cachedData3[index]["problems"]!=null?widget.cachedData3[index]["problems"]:"No Data",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                              ),
                            );
                          }
                      ):Center(child: Text("No Home Visit Requests")))


                    ],
                  ))
            ],
          ),
        )
      /*
      body:
       */
    );
  }
}
Future<void> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions(
    [PermissionGroup.camera, PermissionGroup.microphone],
  );
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
sendPush(String docID,String docname,String docPhoto,String channel,String targetUser,int isVideo) async {
  //send push
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(
        sound: true, badge: true, alert: true, provisional: false),
  );
  dynamic d = jsonEncode(
    <String, dynamic>{
      'notification': <String, dynamic>{
        'title': "Incomming Call",
        'body': 'Call from ' + docname
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'doc_id': docID,
        'doc_name': docname,
        'doc_photo': docPhoto,
        'type': isVideo==1?'incomming_call':"incomming_call_voice_only",
        'room': channel
      },
      'to': "/topics/" + targetUser
    },
  );


  pushNotification(d);
}