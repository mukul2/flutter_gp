import 'dart:async';

import 'package:maulaji/models/login_response.dart';
import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/utils/commonWidgets.dart';
import 'package:maulaji/utils/mySharedPreffManager.dart';
import 'package:maulaji/view/doctor/doctor_view.dart';
import 'package:maulaji/view/login_view.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/stream.dart';
import 'package:maulaji/view/patient/screens/DoctorLogin/widgets.dart';
import 'package:maulaji/view/patient/screens/Pharmacey/slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmaceyActivity extends StatefulWidget {
  @override
  PharmaceyActivitystate createState() {
    return PharmaceyActivitystate();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class PharmaceyActivitystate extends State<PharmaceyActivity> {



  @override
  Widget build(BuildContext context) {

  return  Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 220,
              color: Colors.orange,
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Icon(Icons.notification_important,color: Colors.white,),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text("Welcome",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),


                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.search,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Search"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 60,

            right: 15,
            child: Icon(Icons.shopping_cart,color: Colors.white,),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: sliderAndOtherWidgets(context),
          )
        ],
      ),
    );

  }
}