import 'package:maulaji/view/patient/screens/DoctorLogin/ui.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widgets.dart';
import 'package:maulaji/view/patient/screens/PatientLogin/ui.dart';
import 'package:maulaji/view/patient/screens/Pharmacey/ui.dart';
import 'package:flutter/material.dart';

class BlockClickManager{
  static BlockClickManager block ;

  clickedImPatient (BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewPatientLoginForm()));


/*
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PatientAPPNew()));

 */
    });
  }

  clickedImDoctor (BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewDoctorLoginForm()));
    });
  }
  clickedOpenPharmacey (BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PharmaceyActivity()));
    });
  }

 static BlockClickManager getInstance(){
    if (block == null) {
      block = new BlockClickManager();

      return block;
    } else {

      return block;
    }

  }
}



