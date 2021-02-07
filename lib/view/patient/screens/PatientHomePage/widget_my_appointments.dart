import 'dart:convert';

import 'package:maulaji/myCalling/call.dart';
import 'package:maulaji/myCalling/jitsiCall.dart';
import 'package:maulaji/myCalling/videoCall.dart';
import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/projPaypal/config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../RawApi.dart';
import '../../patient_view.dart';

String NO_IMAGE = "https://lh3.googleusercontent.com/proxy/pWQdkpJ0GjIKfJoudLTf5y1gIVkERydH-iAWc4MExdTwGCmI4TukOgbUfDTaBsonBhVG4B18dkqLPN8wWrikpid6MSjjjhTXJ95tYb5KU1ESnheeV0w";






Future<void> _handleCameraAndMic() async {
  await PermissionHandler().requestPermissions(
    [PermissionGroup.camera, PermissionGroup.microphone],
  );
}





class AppointmentsActivityWidget extends StatefulWidget {
  int currentPage = 0 ;
  List cachedData1 ;
  List cachedData2 ;
  List cachedData3 ;
  @override
  _AppointmentsActivityWidgetState createState() => _AppointmentsActivityWidgetState();
}
PageController _controller = PageController(
  initialPage: 0,
);
class _AppointmentsActivityWidgetState extends State<AppointmentsActivityWidget> {





  @override
  void initState() {



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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Stack(
            children: [
              Positioned(top: 0,left: 0,right: 0,bottom: 50, child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0,20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 00, 10, 10),
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
                                      child: Text("Scheduled",style: TextStyle(color: widget.currentPage == 0 ? Colors.white : primaryColor),),
                                    )),
                                    // height: 5,
                                    decoration: BoxDecoration(
                                        color: widget.currentPage == 0
                                            ?primaryColor
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
                                      child: Text("Urgent Care",style: TextStyle(color: widget.currentPage == 1 ? Colors.white : primaryColor),),
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
                                          ?primaryColor
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
                    SingleChildScrollView(
                      child: Container(
                          height: 500,
                          child: PageView(
                            //  physics: new NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                widget.currentPage = index;
                              });
                            },
                            controller: _controller,
                            children: [

                              widget.cachedData1==null?Center(child: CircularProgressIndicator(),): ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (_ , __ ) => Divider(height:1),
                                  itemCount:
                                  widget.cachedData1 == null ? 0 : widget.cachedData1.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return ListTile(
                                      trailing: InkWell(
                                        onTap: () async {

                                          String uid =await  getUserID();
                                          String patient_id =await  getPatientID();
                                          String uname=await  getUserName();
                                          String uphoto=await  getUserPhoto();

                                          String chatRoom = createChatRoomName(
                                              int.parse(uid),
                                              int.parse(widget.cachedData1[index]["doctor_id"]!=null? widget.cachedData1[index]["doctor_id"].toString():"0")

                                          );
                                          print(chatRoom);
                                          CHAT_ROOM = chatRoom;

                                          chatRoom = patient_id+"-"+widget.cachedData1[index]["doctor_id"].toString();



                                          // await for camera and mic permissions before pushing video page
                                          await _handleCameraAndMic();
                                          print("roomId="+chatRoom);
                                          // push video page with given channel name

                                        //  showThisToast(chatRoom);
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => JitsiCall(
                                                  chatRoom, true
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
                                                partnerID: "d"+widget.cachedData1[index]["doctor"].toString(),
                                                partnerPhoto: widget.cachedData1[index]["doctor_name"],
                                                isCaller: true,
                                                intentType: "",

                                              ),
                                            ),
                                          );

                                           */


                                          // launch("https://simra.org/imran"+chatRoom);

                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(

                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(13.0),
                                              ),
                                              color: primaryColor,
                                              child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                  child:Text("Join Call",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)


                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      leading: Image.network(widget.cachedData1[index]["img_url"]!=null? "https://callgpnow.com/public/"+widget.cachedData1[index]["img_url"]:NO_IMAGE,width: 50,height: 50,fit: BoxFit.cover,),

                                      title: Text(widget.cachedData1[index]["doctor_name"]==null?"No Doctor Name":widget.cachedData1[index]["doctor_name"]),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(widget.cachedData1[index]["time_slot"],style: TextStyle(color:primaryColor,fontWeight: FontWeight.bold),),
                                      ),
                                    );
                                  }
                              ),

                              widget.cachedData2==null?Center(child: CircularProgressIndicator(),):  ListView.separated(
                                  separatorBuilder: (_ , __ ) => Divider(height:1),
                                  itemCount:
                                  widget.cachedData2 == null ? 0 : widget.cachedData2.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return ListTile(
                                      trailing: Wrap(
                                        children: [
                                          InkWell(
                                            onTap: ()async{



                                              print(widget.cachedData2[index]);
                                              String uid =await  getUserID();
                                              String patient_id =await  getPatientID();
                                              String uname=await  getUserName();
                                              String uphoto=await  getUserPhoto();
                                              String chatRoom = createChatRoomName(
                                                  int.parse(uid),
                                                  int.parse(widget.cachedData2[index][""]!=null? widget.cachedData2[index]["doctor_id"].toString():"0")

                                              );
                                              CHAT_ROOM = chatRoom;

                                        chatRoom = patient_id+"-"+widget.cachedData2[index]["doctor_id"].toString();

                                        //showThisToast(chatRoom);
                                              await _handleCameraAndMic();
                                        await Navigator.push(context,MaterialPageRoute(builder: (context) => JitsiCall(chatRoom, true),),);






                                              // await for camera and mic permissions before pushing video page
                                             // showThisToast(chatRoom);

                                              print("roomId="+chatRoom);



                                              // push video page with given channel name
                                              // launch("https://simra.org/imran"+chatRoom);

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
                                                    partnerID: "d"+widget.cachedData2[index]["doctor_id"].toString(),
                                                    partnerPhoto: widget.cachedData2[index]["doctor_name"],
                                                    isCaller: true,
                                                    intentType: "",

                                                  ),
                                                ),
                                              );

                                               */
                                                                           },

                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(

                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(13.0),
                                                  ),
                                                  color: primaryColor,
                                                  child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                      child:Text("Join Call",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)


                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      leading: Image.network(widget.cachedData2[index]["img_url"]!=null? "https://callgpnow.com/public/"+widget.cachedData2[index]["img_url"]:NO_IMAGE,width: 50,height: 50,fit: BoxFit.cover,),
                                      title: Text(widget.cachedData2[index]["doctor_name"]==null?"No Doctor Assigned Yet":widget.cachedData2[index]["doctor_name"]),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text( widget.cachedData2[index]["inserted_at"] ,style: TextStyle(color:primaryColor,fontWeight: FontWeight.bold),),
                                      ),
                                    );
                                  }
                              ),

                              widget.cachedData3==null?Center(child: CircularProgressIndicator(),):  ListView.separated(
                                  separatorBuilder: (_ , __ ) => Divider(height:1),
                                  itemCount:
                                  widget.cachedData3 == null ? 0 : widget.cachedData3.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return ListTile(
                                      trailing:  Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.navigate_next,color:primaryColor),
                                      ),
                                      leading: Image.network(widget.cachedData3[index]["img_url"]!=null? "https://callgpnow.com/public/"+widget.cachedData3[index]["img_url"]:NO_IMAGE,width: 50,height: 50,fit: BoxFit.cover,),

                                      title: Text(widget.cachedData3[index]["doctor_name"]==null?"No Doctor Assigned Yet":widget.cachedData3[index]["doctor_name"]),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(widget.cachedData3[index]["home_address"],style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                                      ),
                                    );
                                  }
                              )


                            ],
                          )),
                    )

                  ],
                ),
              ),),
              Positioned(bottom: 0,
                  left:0,
                  right: 0,
                  child: InkWell(onTap: (){
                setState(() {
                  widget. cachedData1 = null;
                  widget.cachedData2 = null;
                  widget.cachedData3 = null;
                });

                downloadMyScheduledList();
                downloadUrgentList();
                downloadMyHomeVisitList();

                },
                child: Center(child :Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Text("Refresh",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),),
                )),))
            ],
          ),
        ),
      ),
    );
  }
}

 const batteryChannel = const MethodChannel('battery');

Future<void> _getBatteryInformation() async {
  String batteryPercentage;
  try {
    var result = await batteryChannel.invokeMethod('getBatteryLevel');
    batteryPercentage = 'Battery level at $result%';
  } on PlatformException catch (e) {
    batteryPercentage = "Failed to get battery level: '${e.message}'.";
  }

  showThisToast(batteryPercentage);


}
sendPush(String docname,String docID,String docPhoto,String channel,String targetUser) async {
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
        'type': 'incomming_call',
        'room':channel
      },
      'to': "/topics/" + targetUser
    },
  );


  pushNotification(d);

  //send push ends
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
