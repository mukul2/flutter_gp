//TabBarView
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/ChooseDateSlotActivity/ui.dart';
import 'package:flutter/material.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://callgpnow.com/public/";
class SimpleDocProfileActivity extends StatefulWidget {
  dynamic profileData;

  SimpleDocProfileActivity(this.profileData);

  @override
  _SimpleDocProfileActivityState createState() =>
      _SimpleDocProfileActivityState();
}

class _SimpleDocProfileActivityState extends State<SimpleDocProfileActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body :  Stack(
          children: [
            Positioned(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(

                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.red, Colors.white])),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Container(
                  height: 60,
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 00, 20, 0),
                          child: Icon(Icons.chevron_left,color: Colors.white,size: 30,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 00, 20, 0),
                        child: Text("Profile",style: TextStyle(fontSize: 20,color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ),

            ),
            Positioned(
              top: 85,
              left: 0,
              right: 0,
              bottom: 0,
              child:  Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),

                color: Colors.white,
                child: Container(
                  height: double.infinity,
                  //here
                  child:Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Container(
                                  /*
                                    decoration: BoxDecoration(
                                        color:  Colors.white
                                        ,
                                        borderRadius: BorderRadius.circular(5),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 3.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),

                                   */
                                    child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Card(

                                                  child: Image.network(_baseUrl_image + widget.profileData["img_url"],width: 70,height: 70,fit: BoxFit.cover,),
                                                  color: Colors.grey,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        widget.profileData["name"]
                                                            .toString()
                                                            .trim(),
                                                        style: TextStyle(fontSize: 18,
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight.bold),
                                                      ),

                                                      Text(
                                                        "MBBS , California University",
                                                        style: TextStyle(),
                                                      ),
                                                      Card(
                                                        color: Colors.orange,
                                                        child:  Padding(
                                                          padding: const EdgeInsets.all(5.0),
                                                          child: Text(
                                                            widget
                                                                .profileData["department"],
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                        ) ,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Stack(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "Consultation Fees",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerRight,
                                                  // child: Text(widget.profileData["video_appointment_rate"].toString() + " £", style: TextStyle(),),
                                                  child: Text(
                                                    "Free",
                                                    style: TextStyle(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Text(
                                              "Specialization",
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                            child: Text(
                                              widget.profileData["department"] ==
                                                  null
                                                  ? "No Information"
                                                  : widget.profileData["department"],
                                              style: TextStyle(),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChooseConsultationDateTimeActivity(
                                            widget.profileData)));
                          },
                          child: Card(
                            color: primaryColor,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Book Appointment",
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ) ,
                ),
              ),
            )
          ],
        )
/*
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Card(

                                      child: Image.network(_baseUrl_image + widget.profileData["img_url"],width: 70,height: 70,fit: BoxFit.cover,),
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.profileData["name"]
                                                .toString()
                                                .trim(),
                                            style: TextStyle(fontSize: 18,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),

                                          Text(
                                            "MBBS , California Medical University",
                                            style: TextStyle(),
                                          ),
                                          Card(
                                            color: Colors.orange,
                                          child:  Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              widget
                                                  .profileData["department"],
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ) ,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Consultation Fees",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      // child: Text(widget.profileData["video_appointment_rate"].toString() + " £", style: TextStyle(),),
                                      child: Text(
                                        "Free",
                                        style: TextStyle(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "Specialization",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: Text(
                                  widget.profileData["department"] ==
                                      null
                                      ? "No Information"
                                      : widget.profileData["department"],
                                  style: TextStyle(),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChooseConsultationDateTimeActivity(
                                widget.profileData)));
              },
              child: Card(
                color: Colors.blue,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Book Appointment",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),

 */


    );
  }
}