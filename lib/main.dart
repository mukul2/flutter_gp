import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/utils/mySharedPreffManager.dart';
import 'package:maulaji/view/doctor/DoctorHomePage/ui.dart';
import 'package:maulaji/view/doctor/DoctorHomeWidgets/home_widget.dart';
import 'package:maulaji/view/doctor/doctor_view.dart';
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/ui.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widgets.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/bloc.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/ui.dart';
import 'package:maulaji/view/patient/screens/loginMainScrn.dart';
import 'package:maulaji/view/patient/screens/userSelection/bloc.dart';
import 'package:maulaji/view/patient/screens/userSelection/ui.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/login_view.dart';
//Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//?LoginUI:Center(child: Text("Logged user"))) );
Color primaryColor = Colors.red;
void main() => runApp(
    MyApp()
);

var allreadyAtPatient = false;
var allreadyAtDoc = false;

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
         // fontFamily: 'Poppins',
          primaryColor:primaryColor,
          accentColor: primaryColor,
        ),
        title: 'My GP',
        // home: projectWidget(context));
        home: StreamBuilder<LoginStatus>(
            stream: UserAuthStream.getInstance().onAuthChanged,
            initialData: LoginStatus.unknown,
            builder: (c, snapshot) {
              final state = snapshot.data;
              print("main some state came "+state.toString());
              if (state == LoginStatus.loggedAsPat  ) {
                return PatientAPP();
              } else if (state == LoginStatus.loggedAsDoc ) {

                return DOCCAPP();
                return DOCCAPP();
              } else if (state == LoginStatus.loggedOut) {

                return  SelectUserScreen();
              } else if (state == LoginStatus.unknown) {

                 return Scaffold(
                  body: Center(child: Image.asset("assets/my_gp_logo.jpeg",height: 200,width: 200,),),
                );

              }

              return  Scaffold(body: Center(child:Text("Default Route"),),);
            })
    );
  }
}











Widget projectWidget(BuildContext context) {
  //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginUI()));
  //runApp(LoginUI());
  //runApp(MyApp());
  //getLoginStatus();

  if (true) {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      //getLoginStatus();
      bool isLoggedIn = false;
      String type = "";
      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      SharedPreferences prefs = await _prefs;
      isLoggedIn = ((prefs.getBool("isLoggedIn") == null) |
                  prefs.getBool("isLoggedIn") ==
              false)
          ? true
          : (isLoggedIn = true);

      print("1");

      if (isLoggedIn) {
        print("2");
        type = prefs.getString("userType");
        print(type);
        if (type == "d") {
          print("3");
          mainD();
        } else if (type == "p") {
          print("4");
          mainP();
        } else {
          print("5");
          LoginUI();
        }
      } else {
        print("6");
        LoginUI();
      }

      runApp(LoginUI());
    });

  }

  return new Scaffold(
      body: Container(
          child: Stack(
    children: [
      Image.asset(
        "assets/nurse.png",
        fit: BoxFit.cover,
      ),
      // Positioned(top: 0,left:0,right: 0,bottom: 0, child: Center(child: Image.asset("assets/nurse.png",fit: BoxFit.fill,),),),
      Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(80, 240, 248, 255),
              Color.fromARGB(90, 240, 248, 255),
              Colors.orange,
              Colors.deepOrange

              //Color.fromARGB(95, 227, 182, 0),
              // Color.fromARGB(95, 208, 167, 0),
              //  Colors.or,
              // Colors.orange,

              // Colors.deepOrangeAccent,
              // Colors.orangeAccent
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 100,
        child: Center(
          child: Text(
            "Welcome to My Gp",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    ],
  )));

//  return FutureBuilder(
//    builder: (context, projectSnap) {
//      return (((projectSnap.data == null) | (projectSnap.data == false))
//          ? LoginUI()
//          : navigateUser());
//    },
//    future: getLoginStatus(),
//  );
}

Widget navigateUser() {
//  print("trying");
//
// Future<String> type =  getUserType();
//
// type.then((value) =>(){
//   print(value);
// });
//  getUserType().then((value) => () {
//    print("are- "+value);
//        if (value == "d") {
//          mainD();
//          print("D");
//        } else {
//          if (value == "p") {
//            mainP();
//            print("p");
//          }
//          print("dead");
//        }
//      });
  return Scaffold(
    body: Center(
      child: Text("Please wait"),
    ),
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