import 'package:maulaji/view/login_view.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/ui.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/ui.dart';
import 'package:maulaji/view/patient/screens/userSelection/bloc.dart';
import 'package:maulaji/view/patient/screens/userSelection/widgets.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';

class SelectUserScreen extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      return Future.value(false);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
          body: Container(

              child: Stack(
                children: [
                  backGroundImage(),
                  // Positioned(top: 0,left:0,right: 0,bottom: 0, child: Center(child: Image.asset("assets/nurse.png",fit: BoxFit.fill,),),),
                 // backGroundColor(),
                  twoButton(context),

                ],
              ))),
    );
    return WillPopScope(
      onWillPop: _onWillpop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(fontFamily: 'Poppins'),
        home: Scaffold(
            body: Container(
                child: Stack(
                  children: [
                    backGroundImage(),
                    // Positioned(top: 0,left:0,right: 0,bottom: 0, child: Center(child: Image.asset("assets/nurse.png",fit: BoxFit.fill,),),),
                    backGroundColor(),
                    twoButton(context),

                  ],
                ))),
      ),
    );
  }
}