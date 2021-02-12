import 'dart:convert';

import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_appointments.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_blog.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_home.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_my_appointments.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_notice.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_profile.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_only.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/stream.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);

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

class HomeViewPager extends StatefulWidget {
  @override
  _HomeViewPagerState createState() => _HomeViewPagerState();
}

class _HomeViewPagerState extends State<HomeViewPager> {
  List _titles = ["Home", "Notifications", "Profile", "Appointments", "Blog"];
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(
            Icons.home,
            color: Colors.blue,
          ),
          title: new Text(
            'Home',
            style: TextStyle(color: Colors.blue),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.notification_important,
          color: Colors.blue,
        ),
        title: new Text(
          'Notification',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.blue,
          ),
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.blue),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.calendar_today,
          color: Colors.blue,
        ),
        title: new Text(
          'Appointment',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: Colors.blue,
          ),
          title: Text(
            'Blog',
            style: TextStyle(color: Colors.blue),
          ))
    ];
  }
  int bottomSelectedIndex = 0;
  int _page = 0;
  Widget buildPageView() {




    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
        //showThisToast("changed now to " + index.toString());
      },
      children: <Widget>[
        Home(),
        Home(),
        Home(),
        Home(),
        Home(),
        //   ProjNotification(),
        //  Profile(),
        //  Appointment(),
        //  BlogActivityWithState(),
      ],
    );
  }

  void pageChanged(int index) {
    //CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
    //navBarState.setPage(index);
    setState(() {
      bottomSelectedIndex = index;
      _page = index;
    });
    //showThisToast("changed to " + index.toString());
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: Text(
            _titles[bottomSelectedIndex],
            style: TextStyle(color: Colors.white),
          ),
          // backgroundColor: Colors.white,
          elevation: 10,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.message,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(useThisContext,
                MaterialPageRoute(builder: (context) => ChatListActivity()));
          },
        ),
        drawer: myDrawer(),
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: bottomTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  color: bottomSelectedIndex == 0 ? Colors.orange : Colors.grey,
                ),
                title: new Text(
                  'Home',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.notification_important,
                color: bottomSelectedIndex == 1 ? Colors.orange : Colors.grey,
              ),
              title: new Text(
                'Notification',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle,
                  color: bottomSelectedIndex == 2 ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.calendar_today,
                color: bottomSelectedIndex == 3 ? Colors.orange : Colors.grey,
              ),
              title: new Text(
                'Appointment',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.book,
                  color: bottomSelectedIndex == 4 ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  'Blog',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ));
  }
}

//new

class PatientAPPNew extends StatefulWidget {
  //this is the main wid for patient ui
  int  bottomSelectedIndex =0;
  // This widget is the root of your application.
  @override
  _PatientAPPNewState createState() => _PatientAPPNewState();
}

class _PatientAPPNewState extends State<PatientAPPNew> {

 void pageChanged(int index) {
   //CurvedNavigationBarState navBarState = _bottomNavigationKey.currentState;
   //navBarState.setPage(index);
   setState(() {
    widget. bottomSelectedIndex = index;

   });
   //showThisToast("changed to " + index.toString());
 }

 void bottomTapped(int index) {
   setState(() {
     widget. bottomSelectedIndex = index;
     pageController.animateToPage(index,
         duration: Duration(milliseconds: 500), curve: Curves.ease);
   });
 }
 onBackPress() {
   Navigator.pop(this.context, false);
 }
 loadSession()async{
   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
   prefs = await _prefs;
   String patient_id =await getPatientID();
   FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
   firebaseMessaging.subscribeToTopic("p"+patient_id);
   firebaseMessaging.subscribeToTopic("ccc");
  // showThisToast(prefs.getString("p"+patient_id));
 }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadSession();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      // onBackgroundMessage: myBackgroundMessageHandler,

      onLaunch: (Map<String, dynamic> message) async {
        //_navigateToItemDetail(message);
        print("on launch " + message.toString());
        if (message["data"]["type"] == "incomming_call" ) {

          // isCallShowing = true ;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivity(message["data"])));
        } else  if (message["data"]["type"] == "incomming_call_voice_only" ){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivityVoice(message["data"])));
        }

      },

      onResume: (Map<String, dynamic> message) async {
        print("on resume " + message.toString());
        if (message["data"]["type"] == "incomming_call" ) {

          // isCallShowing = true ;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivity(message["data"])));
        } else  if (message["data"]["type"] == "incomming_call_voice_only" ){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivityVoice(message["data"])));
        }

      },

      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        // _navigateToItemDetail(message);
        //  this.displayIncomingCall();

        showThisToast("Really this");
        print("on message " + message.toString());
        showThisToast(message["data"]["room"]);
/*
        Navigator.push(
            useThisContext,
            MaterialPageRoute(
                builder: (context) => IncomingCallActivity(message["data"])));

 */





        if (message["data"]["type"] == "incomming_call" ) {

          // isCallShowing = true ;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivity(message["data"])));
        } else  if (message["data"]["type"] == "incomming_call_voice_only" ){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallActivityVoice(message["data"])));
        }


        /*
        if (message["data"]["type"] == "reject_call" && isCallShowing ==true ) {
          //this.onBackPress();
          //mainP();
          isCallShowing = false ;
          isCallingEngagged = false ;
          showThisToast("Call is terminated by the caller");
        }
         */
        if (message["data"]["type"] == "end_call" ) {
          //this.onBackPress();
          //mainP();

          showThisToast("Call is finished");
        }
        if (message["data"]["type"] == "cancel_call" ) {
          this.onBackPress();
          //mainP();

          showThisToast("Call is canceled");
        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      // Navigator.of(context).pop(true);
      // showThisToast("backpressed");

      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: _onWillpop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(fontFamily: 'Poppins',primaryColor: primaryColor),
        home: Scaffold(

         drawer: Drawer(
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

                      // showDisplayUserPhoto(),
                      // showDisplayUserName(),
                     ],
                   ),
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                 child: ListTile(
                   leading: SizedBox(
                     height: 25,
                     width: 25,
                     child: Image.asset("assets/logout.png"),
                   ),
                   title: Text('Logout'),
                   onTap: () async{
                     UserAuthStream.getInstanceNoCheck().signOut();
                     PatientLoginStream.getInstance().signOut();
                     String patient_id =await getPatientID();
                     FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
                     firebaseMessaging.unsubscribeFromTopic("p"+patient_id);
                     //showThisToast("me ??");
                     //setLoginStatus(false);
                     //runApp(LoginUI());
                     // UserAuthStream.getInstance().signOut();
                   },
                 ),
               ),
               /*
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
                 title: Text('MOVE TO DOC'),
                 onTap: () {
                   //setLoginStatus(false);
                   //runApp(LoginUI());
                   UserAuthStream.getInstance().changeUserTYPE("d");
                 },
               ),

                */
             ],
           ),
         ) ,


          appBar: AppBar(actions: [
            IconButton(
                icon: const Icon(Icons.exit_to_app,color: Colors.red,),
                onPressed: ()async {
                  UserAuthStream.getInstanceNoCheck().signOut();
                  PatientLoginStream.getInstance().signOut();
                  String patient_id =await getPatientID();
                  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
                  firebaseMessaging.unsubscribeFromTopic("p"+patient_id);
                }),

          ],centerTitle: true,title: Text("Maulaji",style: TextStyle(color: Colors.red),),elevation: 1,backgroundColor: Colors.white,),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              pageChanged(index);
              //showThisToast("changed now to " + index.toString());
            },
            children: <Widget>[
              //Home(),
              //openHomeWidget(),

             // DoctorSearchActivityNew(),
              DoctorSearchActivityUseCaseTwo(),
              AppointmentsActivityWidget(),

              //NoticeListWidget(),
              Profile(),
              Appointment(),
              //BlogActivityWithState(),
              //   ProjNotification(),
                Profile(),
               // Profile(),
              //  Appointment(),
              //  BlogActivityWithState(),
            ],
          ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:widget. bottomSelectedIndex,
              onTap: bottomTapped,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                    icon: new Icon(
                      Icons.home,
                      color:widget. bottomSelectedIndex == 0 ? primaryColor : Colors.grey,
                    ),
                    title: new Text(
                      'Search Doctor',
                      style: TextStyle(color: widget. bottomSelectedIndex == 0 ? primaryColor : Colors.grey),
                    )),

                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.notification_important,
                    color:widget. bottomSelectedIndex == 1 ?primaryColor : Colors.grey,
                  ),
                  title: new Text(
                    'My Appointments',
                    style: TextStyle(color:widget. bottomSelectedIndex == 1 ?primaryColor : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.supervised_user_circle,
                      color:widget. bottomSelectedIndex == 2 ? primaryColor: Colors.grey,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(color: widget. bottomSelectedIndex == 2 ? primaryColor : Colors.grey),
                    )),

              ],
            )
        ),


      ),
    );
  }
int homeWidCount = 0 ;
 Widget openHomeWidget() {
   if(homeWidCount ==0){
     print("hitting home wid");
     homeWidCount++;
     return  Home();
   }else {
     return Center(
       child: Text("STOP"),
     );
   }

  }
}

showDisplayUserName()async{
  String userName =await  getUserName();
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 20, 25),
      child: new Center(
        child: Text(
          userName,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ));
}
showDisplayUserPhoto()async{
  String photo =await  getUserPhoto();
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 5),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(photo),
      ));
}



