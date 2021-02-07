import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/view/doctor/DoctorHomeWidgets/home_widget.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/stream.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class DOCCCCAPPNew extends StatefulWidget {
  String photo ="";
  String name ="Loading";
  //this is the main wid for patient ui
  int  bottomSelectedIndex =0;
  // This widget is the root of your application.
  @override
  _DOCCCCAPPNewState createState() => _DOCCCCAPPNewState();
}
PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);
class _DOCCCCAPPNewState extends State<DOCCCCAPPNew> {

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
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  loadSession()async{
    //showThisToast("session loading");

    String p = await getUserPhoto();
    String n  = await getUserName();
    this.setState(() {
      widget.photo = p ;
      widget.name = n ;
    });
    //showThisToast(widget.name);
    String docId =await getDoctor_id();
    FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
    firebaseMessaging.subscribeToTopic("d"+docId);

  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSession();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        //_navigateToItemDetail(message);
        print("on launch " + message.toString());
        if (message["data"]["type"] == "new_appointment" ) {
          this.initState();

        } else {

        }
      },

      onResume: (Map<String, dynamic> message) async {
        print("on resume " + message.toString());

        if (message["data"]["type"] == "new_appointment" ) {

        } else {
          // showThisToast("unknown type");
        }


      },

      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {

        if (message["data"]["type"] == "new_appointment" ) {


        } else {

        }


      },
    );



  }
  onBackPress() {
    Navigator.pop(this.context, false);
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
                    color: primaryColor,

                    child: Center(
                      child: Column(
                        children: <Widget>[
                          //showDisplayUserPhoto(),

                        //  showDisplayUserName(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ListTile(
                      leading: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/logout.png"),
                      ),
                      title: Text('Logout'),
                      onTap: () async{
                        UserAuthStream.getInstanceNoCheck().signOut();
                        DoctorLoginStream.getInstance().signOut();
                        FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
                        String docId =await getDoctor_id();
                        firebaseMessaging.unsubscribeFromTopic("d"+docId);
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


            appBar: AppBar(title: Text("Maulaji"),),
            body: PageView(
              controller: pageController,
              onPageChanged: (index) {
                pageChanged(index);
                //showThisToast("changed now to " + index.toString());
              },
              children: <Widget>[
                //Home(),
                //openHomeWidget(),

                DoctorHomeWidget(),
                //DoctorHomeWidget(),
               // Text("WORK"),

                //  Appointment(),
                //  BlogActivityWithState(),
              ],
            ),
            /*
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:widget. bottomSelectedIndex,
              onTap: bottomTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: new Icon(
                      Icons.home,
                      color:widget. bottomSelectedIndex == 0 ? Colors.orange : Colors.grey,
                    ),
                    title: new Text(
                      'Home',
                      style: TextStyle(color: Colors.blue),
                    )),
               /*
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.notification_important,
                    color: widget.bottomSelectedIndex == 1 ? Colors.orange : Colors.grey,
                  ),
                  title: new Text(
                    'Notification',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.supervised_user_circle,
                      color: widget.bottomSelectedIndex == 2 ? Colors.orange : Colors.grey,
                    ),
                    title: Text(
                      'Profile',
                      style: TextStyle(color: Colors.blue),
                    )),
                BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.calendar_today,
                    color: widget.bottomSelectedIndex == 3 ? Colors.orange : Colors.grey,
                  ),
                  title: new Text(
                    'Appointment',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.book,
                      color: widget.bottomSelectedIndex == 4 ? Colors.orange : Colors.grey,
                    ),
                    title: Text(
                      'Blog',
                      style: TextStyle(color: Colors.blue),
                    ))

                */
              ],
            )

             */
        ),


      ),
    );
  }
  int homeWidCount = 0 ;

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