import 'package:maulaji/view/patient/screens/PatientHomePage/stream.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_home.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widgets.dart';
import 'package:flutter/material.dart';

class PatientAPP extends StatelessWidget {
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
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent),
      home:  StreamBuilder<Status>(
          stream: PatientHomeStream.getInstance().onAuthChanged,
          initialData: Status.initialState,
          builder: (c, snapshot) {
            final state = snapshot.data;
            /*
            print("some state came "+state.toString());
            if (state == LoginStatus.loggedAsPat) {
              return PatientAPP();
            } else if (state == LoginStatus.loggedAsDoc) {
              return DoctorAPP();
            } else if (state == LoginStatus.loggedOut) {
              return  SelectUserScreen();
            } else if (state == LoginStatus.unknown) {
              return Scaffold(
                body: Center(child: Image.asset("assets/my_gp_logo.jpeg",height: 200,width: 200,),),
              );

            }



            return  Scaffold(
              body: Center(child: Image.asset("assets/my_gp_logo.jpeg",height: 200,width: 200,),),
            );

            */
            return  PatientAPPNew();
           // return  HomeViewPager();
            //return  MyHomePageP(title: 'Flutter Demo Home Page');
          }),

    );
  }
}