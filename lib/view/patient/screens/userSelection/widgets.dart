import 'package:maulaji/streams/AuthControllerStream.dart';
import 'package:maulaji/view/patient/screens/HomeVisitDocListActivity/ui.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/stream.dart';
import 'package:maulaji/view/patient/screens/userSelection/bloc.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';

Widget backGroundImage(){
  return Container(
    height: double.infinity,
    child: Image.asset(
      "assets/mother_child_bg2.png",
      fit: BoxFit.cover,
    ),
  );
}
Widget backGroundColor(){
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Color.fromARGB(80, 240, 248, 255),
          Color.fromARGB(90, 240, 248, 255),
          primaryColor,
          primaryColor

        ],
      ),
    ),
  );
}
Widget twoButton(BuildContext context){
  return Positioned(
    left: 0,
    right: 0,
    bottom: 20,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: SizedBox(
              height: 50,
              width: double.infinity, // match_parent
              child: RaisedButton(
                onPressed:(){
                  //UserAuthStream.getInstanceNoCheck().moveToPatientLogin();
                 // PatientLoginStream.getInstance().patientGuestLogin();
                  BlockClickManager.getInstance().clickedImPatient(context);
                  },
                color: primaryColor,
                child: Text(
                  "I'm a Patient",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: InkWell(
            onTap:(){BlockClickManager.getInstance().clickedImDoctor(context);},
            child: Container(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  "I'm a Doctor",
                  style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: ShapeDecoration(

                shape: CustomRoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),

                  topSide: BorderSide(color:primaryColor),
                  leftSide: BorderSide(color: primaryColor),
                  bottomLeftCornerSide: BorderSide(color: primaryColor),
                  topLeftCornerSide: BorderSide(color: primaryColor),
                  topRightCornerSide: BorderSide(color:primaryColor),
                  rightSide: BorderSide(color: primaryColor),
                  bottomRightCornerSide: BorderSide(color:primaryColor),
                  bottomSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: InkWell(
              onTap:(){BlockClickManager.getInstance().clickedOpenPharmacey(context);},
              child: Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    "Pharmacy Store",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: ShapeDecoration(
                  shape: CustomRoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    topSide: BorderSide(color: Colors.white),
                    leftSide: BorderSide(color: Colors.white),
                    bottomLeftCornerSide: BorderSide(color: Colors.white),
                    topLeftCornerSide: BorderSide(color: Colors.white),
                    topRightCornerSide: BorderSide(color: Colors.white),
                    rightSide: BorderSide(color: Colors.white),
                    bottomRightCornerSide: BorderSide(color: Colors.white),
                    bottomSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}