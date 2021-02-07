import 'package:maulaji/main.dart';
import 'package:maulaji/view/doctor/DoctorHomePage/stream.dart';
import 'package:maulaji/view/doctor/DoctorHomePage/widgets.dart';
import 'package:maulaji/view/doctor/DoctorHomeWidgets/home_widget.dart';
import 'package:maulaji/view/doctor/doctor_view.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_home.dart';
import 'package:flutter/material.dart';

class DOCCAPP extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      // Navigator.of(context).pop(true);
      // showThisToast("backpressed");

      return Future.value(false);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: primaryColor,
          accentColor: primaryColor),
      home:  StreamBuilder<Status>(
          stream: DoctorHomeStream.getInstance().onAuthChanged,
          initialData: Status.initialState,
          builder: (c, snapshot) {
            Status state = snapshot.data;

            print("some state came xx"+state.toString());
          /*
            if (state == Status.loginSuccess) {
              return DoctorHomeWidget();
            }



            return  Scaffold(
              body: Center(child: Image.asset("assets/my_gp_logo.jpeg",height: 200,width: 200,),),
            );

           */


            return  DOCCCCAPPNew();
            //return  HomeViewPager();
            //return  MyHomePageP(title: 'Flutter Demo Home Page');
          }),

    );
  }
}