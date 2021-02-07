import 'dart:convert';

import 'package:maulaji/view/patient/patient_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
import 'package:shared_preferences/shared_preferences.dart';
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";
class ChooseConsultationDateTimeActivity extends StatefulWidget {
  dynamic docProfile;
  List allSunday = [];
  List allMonday = [];
  List allTuesday = [];
  List allWednesDay = [];
  List allThursDay = [];
  List allFriday = [];
  List allSatDay = [];
  int today = 1;
  int dayIndex = 1;
  int selectedDate = 1;
  int selectedMonth = 1;
  int selectedYear = 1;
  List allDaysSlots = [];
  List allDaysSlotsMorning = [];
  List allDaysSlotsAfterNoon = [];
  List allDaysSlotsevening = [];
  List allDaysSlotsAllDay = [];
  bool daysLoading = true;
  int viewPagePosition = 0;
  String dateLong ;
  String s_time_key ;

  bool allowOldDates = true ;

  ChooseConsultationDateTimeActivity(this.docProfile);

  @override
  _ChooseConsultationDateTimeActivityState createState() =>
      _ChooseConsultationDateTimeActivityState();
}

int getMonthCount(int month) {
  int count = 0;
  if (month == 1) count = 31;
  if (month == 2) count = 29;
  if (month == 3) count = 31;
  if (month == 4) count = 30;
  if (month == 5) count = 31;
  if (month == 6) count = 30;
  if (month == 7) count = 31;
  if (month == 8) count = 31;
  if (month == 9) count = 30;
  if (month == 10) count = 31;
  if (month == 11) count = 30;
  if (month == 12) count = 31;
  return count;
}

class _ChooseConsultationDateTimeActivityState
    extends State<ChooseConsultationDateTimeActivity> {
  getAlldays() {
    DateTime dateTimereal = new DateTime.now();

    setState(() {
      widget.selectedMonth = dateTimereal.month;
      widget.selectedYear = dateTimereal.year;
      widget.today = dateTimereal.day;
      widget.selectedDate = dateTimereal.day;
      widget.dayIndex = dateTimereal.weekday;
    });
    DateTime dateTime = new DateTime.now();
    int thisMonth = dateTime.month;
    dateTime = new DateTime(dateTimereal.year, dateTimereal.month, 1);
    for (int i = 0; i <= getMonthCount(dateTimereal.month); i++) {
      if (dateTime.weekday == 1) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
          }

          widget.allMonday.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 2) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
          }
          widget.allTuesday.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 3) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
          }
          widget.allWednesDay.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 4) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
          }
          widget.allThursDay.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 5) {
        setState(() {
          if (i == 0) {
            //widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
            widget.allThursDay.add(0);
          }
          widget.allFriday.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 6) {
        setState(() {
          if (i == 0) {
            // widget.allSunday.add(0);
            widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
            widget.allThursDay.add(0);
            widget.allFriday.add(0);
          }
          widget.allSatDay.add(dateTime.day);
        });
      }
      if (dateTime.weekday == 7) {
        setState(() {
          if (i == 0) {
            //  widget.allMonday.add(0);
            widget.allTuesday.add(0);
            widget.allWednesDay.add(0);
            widget.allThursDay.add(0);
            widget.allFriday.add(0);
            widget.allSatDay.add(0);
          }
          widget.allSunday.add(dateTime.day);
        });
      }
      dateTime = dateTime.add(new Duration(days: 1));
    }
    print(widget.allSunday.toString());
  }


  Future<dynamic> getslots() async {
    // getslotsevening();
    // getslotsAftarnoon();
    // getslotsMorning();
    getAllSlots();
  }
  Future<dynamic> getAllSlots() async {
    setState(() {
      widget.daysLoading = true ;
    });

    print("going to hit slot api");
    String d =  new DateTime(widget.selectedYear,widget.selectedMonth,widget.selectedDate).millisecondsSinceEpoch.toString();
    setState(() {
      widget.dateLong = d;
    });
    //showThisToast(d);
    String reqUrl = _baseUrl +'free_slots_doctors_call_gp?day='+widget.dayIndex.toString()+'&&date='+d+'&&doctor='+ widget.docProfile["id"].toString();

    //showThisToast(reqUrl);
    print(reqUrl);
    final http.Response response = await http.get(
      reqUrl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

    );
    //showThisToast(response.body.toString());

    print(response.body);
    setState(() {
      widget.allDaysSlotsAllDay = jsonDecode(response.body);
      widget.daysLoading = false ;
    });
  }
  Future<dynamic> getslotsMorning() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    var body_ = jsonEncode(<String, String>{
      'dr_id': widget.docProfile["id"].toString(),
      'patient_id': prefs.getString("uid"),
      'date': widget.selectedYear.toString() +
          "-" +
          widget.selectedMonth.toString() +
          "-" +
          widget.selectedDate.toString(),
      'day': widget.dayIndex.toString()
    });
    print("going to hit slot api");
    print(body_);
    final http.Response response = await http.post(
      _baseUrl + 'get_vdo_appointment_slot_morning',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body_,
    );
    // showThisToast(response.statusCode.toString());

    print(response.body);
    setState(() {
      widget.allDaysSlotsMorning = jsonDecode(response.body);
    });
  }

  Future<dynamic> getslotsAftarnoon() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    var body_ = jsonEncode(<String, String>{
      'dr_id': widget.docProfile["id"].toString(),
      'patient_id':  prefs.getString("uid"),
      'date': widget.selectedYear.toString() +
          "-" +
          widget.selectedMonth.toString() +
          "-" +
          widget.selectedDate.toString(),
      'day': widget.dayIndex.toString()
    });
    print("going to hit slot api");
    print(body_);
    final http.Response response = await http.post(
      _baseUrl + 'get_vdo_appointment_slot_afternoon',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body_,
    );
    // showThisToast(response.statusCode.toString());

    print(response.body);
    setState(() {
      widget.allDaysSlotsAfterNoon = jsonDecode(response.body);
    });
  }

  Future<dynamic> getslotsevening() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    var body_ = jsonEncode(<String, String>{
      'dr_id': widget.docProfile["id"].toString(),
      'patient_id':  prefs.getString("uid"),
      'date': widget.selectedYear.toString() +
          "-" +
          widget.selectedMonth.toString() +
          "-" +
          widget.selectedDate.toString(),
      'day': widget.dayIndex.toString()
    });
    print("going to hit slot api");
    print(body_);
    final http.Response response = await http.post(
      _baseUrl + 'get_vdo_appointment_slot_evening',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body_,
    );
    // showThisToast(response.statusCode.toString());

    print(response.body);
    setState(() {
      widget.allDaysSlotsevening = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getAlldays();
    this.getslots();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController2 = PageController(
      initialPage: 0,
      keepPage: true,
    );
    return Scaffold(

      body:  Stack(
        children: [
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(

                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor, Colors.white])),
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
                      child: Text("Appointment Date & Time",style: TextStyle(fontSize: 18,color: Colors.white),),
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
                child:SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Container(

                          // decoration: BoxDecoration(
                          //     color:  Colors.white
                          //     ,
                          //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          //     shape: BoxShape.rectangle,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey,
                          //         blurRadius: 1.0,
                          //         spreadRadius: 1.0,
                          //       ),
                          //     ]),



                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.all(8)),
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Icon(Icons.chevron_left),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.chevron_right),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text("This Month"),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                          child: Text("Mon"),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Text("Tue"),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Text("Wed"),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Text("Thu"),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Text("Fri"),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Text("Sat"),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: Text("Sun"),
                                        )),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allMonday == null
                                                ? 0
                                                : widget.allMonday.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allMonday[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allowOldDates | (widget.allMonday[index] >= widget.today)) {
                                                        widget.selectedDate =
                                                        widget.allMonday[index];
                                                        widget.dayIndex = 1;
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget.allMonday[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget.allMonday[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allMonday[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allMonday[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allTuesday == null
                                                ? 0
                                                : widget.allTuesday.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allTuesday[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allowOldDates |(widget.allTuesday[index] >= widget.today)) {
                                                        widget.selectedDate =
                                                        widget.allTuesday[index];
                                                        widget.dayIndex = 2;
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget.allTuesday[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget.allTuesday[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allTuesday[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allTuesday[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allWednesDay == null
                                                ? 0
                                                : widget.allWednesDay.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allWednesDay[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allowOldDates |(widget.allWednesDay[index] >= widget.today)) {
                                                        widget.selectedDate =
                                                        widget.allWednesDay[index];
                                                        widget.dayIndex = 3;
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget
                                                                    .allWednesDay[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget
                                                                    .allWednesDay[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allWednesDay[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allWednesDay[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allThursDay == null
                                                ? 0
                                                : widget.allThursDay.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allThursDay[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allowOldDates |(widget.allThursDay[index] >= widget.today)) {
                                                        //  showThisToast("thursday");
                                                        widget.dayIndex = 4;
                                                        widget.selectedDate =
                                                        widget.allThursDay[index];
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget.allThursDay[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget.allThursDay[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allThursDay[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allThursDay[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allFriday == null
                                                ? 0
                                                : widget.allFriday.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allFriday[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allFriday[index] >=
                                                          widget.today) {
                                                        widget.selectedDate =
                                                        widget.allFriday[index];
                                                        widget.dayIndex = 5;
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget.allFriday[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget.allFriday[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allFriday[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allFriday[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allSatDay == null
                                                ? 0
                                                : widget.allSatDay.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allSatDay[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allowOldDates |(widget.allSatDay[index] >= widget.today)) {
                                                        widget.selectedDate =
                                                        widget.allSatDay[index];
                                                        widget.dayIndex = 6;
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget.allSatDay[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget.allSatDay[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allSatDay[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allSatDay[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                    Expanded(
                                        child: Center(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: widget.allSunday == null
                                                ? 0
                                                : widget.allSunday.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return widget.allSunday[index] == 0
                                                  ? Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                ),
                                              )
                                                  : InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (widget.allowOldDates |(widget.allSunday[index] >= widget.today)) {
                                                        widget.selectedDate =
                                                        widget.allSunday[index];
                                                        widget.dayIndex = 7;
                                                        getslots();
                                                      }
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(0),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(3),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration: BoxDecoration(
                                                                color: widget.allSunday[
                                                                index] ==
                                                                    widget.today
                                                                    ? Colors.blue
                                                                    : (widget.allSunday[
                                                                index] <
                                                                    widget.today
                                                                    ? Colors.grey
                                                                    : Color.fromARGB(
                                                                    255,
                                                                    236,
                                                                    236,
                                                                    236)),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    0),
                                                                shape: BoxShape.rectangle,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: widget
                                                                        .allSunday[
                                                                    index] ==
                                                                        widget
                                                                            .selectedDate
                                                                        ? Colors.blue
                                                                        : Color.fromARGB(
                                                                        255,
                                                                        236,
                                                                        236,
                                                                        236),
                                                                    blurRadius: 1.0,
                                                                    spreadRadius: 1.0,
                                                                  ),
                                                                ]),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(3),
                                                              child: Center(
                                                                child: Text(widget
                                                                    .allSunday[index]
                                                                    .toString()),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ));
                                            },
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Center(
                          child: Text(
                            "Choose Slot",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      widget.daysLoading?Center(child: CircularProgressIndicator()):  widget.allDaysSlotsAllDay.length == 0
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text("Sorry No Slots for "+widget.selectedDate.toString()+"/"+widget.selectedMonth.toString()+"/"+widget.selectedYear.toString(),style: TextStyle(color: Colors.red),),),
                      )
                          : GridView.builder(
                        shrinkWrap: true,
                        itemCount: widget.allDaysSlotsAllDay.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: MediaQuery
                                .of(context)
                                .size
                                .width /
                                (MediaQuery
                                    .of(context)
                                    .size
                                    .height / 6),
                            crossAxisCount: (MediaQuery
                                .of(context)
                                .orientation ==
                                Orientation.portrait)
                                ? 2
                                : 3),
                        itemBuilder: (BuildContext context, int index_) {
                          return new InkWell(
                            onTap: () {
                             // showThisToast(widget.docProfile["ion_user_id"].toString());
                              if (true) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConsultationFormActivity2(
                                                widget.selectedYear.toString() + "-" + widget.selectedMonth.toString() + "-" + widget.selectedDate.toString(),
                                                widget.allDaysSlotsAllDay[index_]['s_time'],
                                                widget.allDaysSlotsAllDay[index_]['hospital_id'],
                                                widget.docProfile["id"].toString(),
                                                widget.docProfile["name"],
                                                "500 £",
                                                widget.dateLong,
                                                widget.allDaysSlotsAllDay[index_]['s_time_key']
                                            )));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color:  Colors.white
                                    ,
                                    borderRadius: BorderRadius.circular(3),
                                    shape: BoxShape.rectangle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ]),
                                height: 50,
                                child: Center(
                                  child: new Text(
                                      widget.allDaysSlotsAllDay[index_]
                                      ['s_time']),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
/*
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                //color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(15, 10, 10, 15),
                        //   child: Text(
                        //     "Upcomming Appointment",
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    this.setState(() {
                                      if (true) {
                                        widget.viewPagePosition = 0;
                                        pageController2.animateToPage(0,
                                            duration:
                                            new Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      //index == 0 ? widget.first = true :false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.viewPagePosition == 0
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Morning",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.viewPagePosition ==
                                                  0
                                                  ? Colors.white
                                                  : Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    this.setState(() {
                                      if (true) {
                                        widget.viewPagePosition = 1;
                                        pageController2.animateToPage(1,
                                            duration:
                                            new Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      //index == 0 ? widget.first = true :false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.viewPagePosition == 1
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Afternoon",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.viewPagePosition ==
                                                  1
                                                  ? Colors.white
                                                  : Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    this.setState(() {
                                      if (true) {
                                        widget.viewPagePosition = 2;
                                        pageController2.animateToPage(2,
                                            duration:
                                            new Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      //index == 0 ? widget.first = true :false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.viewPagePosition == 2
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Evening",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.viewPagePosition ==
                                                  2
                                                  ? Colors.white
                                                  : Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ])),
            ),

            Container(
              height: 500,
              child: PageView(
                controller: pageController2,
                onPageChanged: (index) {
                  //   showThisToast("changed to " + index.toString());

                  this.setState(() {
                    widget.viewPagePosition = index;
                  });
                },
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: widget.allDaysSlotsMorning.length == 0
                        ? Text("Chamber Closed at Morning")
                        : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allDaysSlotsMorning.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .width /
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6),
                          crossAxisCount: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                          onTap: () {
                            if (widget.allDaysSlotsMorning[index_]['status']) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationFormActivity(
                                              widget.selectedYear.toString() +
                                                  "-" +
                                                  widget.selectedMonth
                                                      .toString() +
                                                  "-" +
                                                  widget.selectedDate
                                                      .toString(),
                                              widget.allDaysSlotsMorning[index_]
                                              ['message'],
                                              widget.docProfile["id"]
                                                  .toString(),
                                              widget.docProfile["name"],
                                              widget.docProfile[
                                              "video_appointment_rate"]
                                                  .toString() +
                                                  " £")));
                            }
                          },
                          child: Container(
                            height: 50,
                            child: Card(
                              color: widget
                                  .allDaysSlotsMorning[index_]['status']
                                  ? Colors.white
                                  : Colors.grey,
                              child: Center(
                                child: new Text(
                                    widget.allDaysSlotsMorning[index_]
                                    ['status']
                                        ? widget
                                        .allDaysSlotsMorning[index_]['message']
                                        : "Taken"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: widget.allDaysSlotsAfterNoon.length == 0
                        ? Text("Chamber Closed at Afternoon")
                        : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allDaysSlotsAfterNoon.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .width /
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6),
                          crossAxisCount: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                          onTap: () {
                            if (widget
                                .allDaysSlotsAfterNoon[index_]['status']) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationFormActivity(
                                              widget.selectedYear.toString() +
                                                  "-" +
                                                  widget.selectedMonth
                                                      .toString() +
                                                  "-" +
                                                  widget.selectedDate
                                                      .toString(),
                                              widget
                                                  .allDaysSlotsAfterNoon[index_]
                                              ['message'],
                                              widget.docProfile["id"]
                                                  .toString(),
                                              widget.docProfile["name"],
                                              widget.docProfile[
                                              "video_appointment_rate"]
                                                  .toString() +
                                                  " £")));
                            }
                          },
                          child: Container(
                            height: 50,
                            child: Card(
                              color: widget
                                  .allDaysSlotsAfterNoon[index_]['status']
                                  ? Colors.white
                                  : Colors.grey,
                              child: Center(
                                child: new Text(
                                    widget.allDaysSlotsAfterNoon[index_]
                                    ['status']
                                        ? widget
                                        .allDaysSlotsAfterNoon[index_]['message']
                                        : "Taken"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: widget.allDaysSlotsevening.length == 0
                        ? Text("Chamber Closed at Evening")
                        : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allDaysSlotsevening.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .width /
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6),
                          crossAxisCount: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                          onTap: () {
                            if (widget.allDaysSlotsevening[index_]['status']) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationFormActivity(
                                              widget.selectedYear.toString() +
                                                  "-" +
                                                  widget.selectedMonth
                                                      .toString() +
                                                  "-" +
                                                  widget.selectedDate
                                                      .toString(),
                                              widget.allDaysSlotsevening[index_]
                                              ['message'],
                                              widget.docProfile["id"]
                                                  .toString(),
                                              widget.docProfile["name"],
                                              widget.docProfile[
                                              "video_appointment_rate"]
                                                  .toString() +
                                                  " £")));
                            }
                          },
                          child: Container(
                            height: 50,
                            child: Card(
                              color: widget
                                  .allDaysSlotsevening[index_]['status']
                                  ? Colors.white
                                  : Colors.grey,
                              child: Center(
                                child: new Text(
                                    widget.allDaysSlotsevening[index_]
                                    ['status']
                                        ? widget
                                        .allDaysSlotsevening[index_]['message']
                                        : "Taken"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

 */


                    ],
                  ),
                ) ,
              ),
            ),
          )
        ],
      ),
      /*
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.chevron_left),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.chevron_right),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Text("This Month"),
                            ),
                          )
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                                child: Text("Mon"),
                              )),
                          Expanded(
                              child: Center(
                                child: Text("Tue"),
                              )),
                          Expanded(
                              child: Center(
                                child: Text("Wed"),
                              )),
                          Expanded(
                              child: Center(
                                child: Text("Thu"),
                              )),
                          Expanded(
                              child: Center(
                                child: Text("Fri"),
                              )),
                          Expanded(
                              child: Center(
                                child: Text("Sat"),
                              )),
                          Expanded(
                              child: Center(
                                child: Text("Sun"),
                              )),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allMonday == null
                                      ? 0
                                      : widget.allMonday.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allMonday[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allMonday[index] >=
                                                widget.today) {
                                              widget.selectedDate =
                                              widget.allMonday[index];
                                              widget.dayIndex = 1;
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allMonday[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget.allMonday[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allMonday[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allMonday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allTuesday == null
                                      ? 0
                                      : widget.allTuesday.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allTuesday[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allTuesday[index] >=
                                                widget.today) {
                                              widget.selectedDate =
                                              widget.allTuesday[index];
                                              widget.dayIndex = 2;
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allTuesday[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget.allTuesday[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allTuesday[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allTuesday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allWednesDay == null
                                      ? 0
                                      : widget.allWednesDay.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allWednesDay[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allWednesDay[index] >=
                                                widget.today) {
                                              widget.selectedDate =
                                              widget.allWednesDay[index];
                                              widget.dayIndex = 3;
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget
                                                          .allWednesDay[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget
                                                          .allWednesDay[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allWednesDay[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allWednesDay[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allThursDay == null
                                      ? 0
                                      : widget.allThursDay.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allThursDay[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allThursDay[index] >=
                                                widget.today) {
                                              //  showThisToast("thursday");
                                              widget.dayIndex = 4;
                                              widget.selectedDate =
                                              widget.allThursDay[index];
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allThursDay[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget.allThursDay[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allThursDay[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allThursDay[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allFriday == null
                                      ? 0
                                      : widget.allFriday.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allFriday[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allFriday[index] >=
                                                widget.today) {
                                              widget.selectedDate =
                                              widget.allFriday[index];
                                              widget.dayIndex = 5;
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allFriday[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget.allFriday[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allFriday[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allFriday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allSatDay == null
                                      ? 0
                                      : widget.allSatDay.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allSatDay[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allSatDay[index] >=
                                                widget.today) {
                                              widget.selectedDate =
                                              widget.allSatDay[index];
                                              widget.dayIndex = 6;
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allSatDay[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget.allSatDay[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allSatDay[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allSatDay[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                          Expanded(
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.allSunday == null
                                      ? 0
                                      : widget.allSunday.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return widget.allSunday[index] == 0
                                        ? Padding(
                                      padding: EdgeInsets.all(3),
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                        : InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (widget.allSunday[index] >=
                                                widget.today) {
                                              widget.selectedDate =
                                              widget.allSunday[index];
                                              widget.dayIndex = 7;
                                              getslots();
                                            }
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                              padding: EdgeInsets.all(0),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: widget.allSunday[
                                                      index] ==
                                                          widget.today
                                                          ? Colors.blue
                                                          : (widget.allSunday[
                                                      index] <
                                                          widget.today
                                                          ? Colors.grey
                                                          : Color.fromARGB(
                                                          255,
                                                          236,
                                                          236,
                                                          236)),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          0),
                                                      shape: BoxShape.rectangle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: widget
                                                              .allSunday[
                                                          index] ==
                                                              widget
                                                                  .selectedDate
                                                              ? Colors.blue
                                                              : Color.fromARGB(
                                                              255,
                                                              236,
                                                              236,
                                                              236),
                                                          blurRadius: 1.0,
                                                          spreadRadius: 1.0,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: Text(widget
                                                          .allSunday[index]
                                                          .toString()),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ));
                                  },
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                "Choose Slot",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            widget.allDaysSlotsAllDay.length == 0
                ? Text("Chamber Closed This Day")
                : GridView.builder(
              shrinkWrap: true,
              itemCount: widget.allDaysSlotsAllDay.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: MediaQuery
                      .of(context)
                      .size
                      .width /
                      (MediaQuery
                          .of(context)
                          .size
                          .height / 6),
                  crossAxisCount: (MediaQuery
                      .of(context)
                      .orientation ==
                      Orientation.portrait)
                      ? 2
                      : 3),
              itemBuilder: (BuildContext context, int index_) {
                return new InkWell(
                  onTap: () {
                    if (widget.allDaysSlotsAllDay[index_]['status']) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ConsultationFormActivity(
                                      widget.selectedYear.toString() +
                                          "-" +
                                          widget.selectedMonth
                                              .toString() +
                                          "-" +
                                          widget.selectedDate
                                              .toString(),
                                      widget.allDaysSlotsAllDay[index_]
                                      ['message'],
                                      widget.docProfile["id"]
                                          .toString(),
                                      widget.docProfile["name"],
                                      widget.docProfile[
                                      "video_appointment_rate"]
                                          .toString() +
                                          " £")));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color:  Colors.white
                             ,
                          borderRadius: BorderRadius.circular(3),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                      height: 50,
                      child: Center(
                        child: new Text(
                            widget.allDaysSlotsAllDay[index_]
                            ['s_time']),
                      ),
                    ),
                  ),
                );
              },
            ),
/*
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                //color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.fromLTRB(15, 10, 10, 15),
                        //   child: Text(
                        //     "Upcomming Appointment",
                        //     style: TextStyle(fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    this.setState(() {
                                      if (true) {
                                        widget.viewPagePosition = 0;
                                        pageController2.animateToPage(0,
                                            duration:
                                            new Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      //index == 0 ? widget.first = true :false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.viewPagePosition == 0
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Morning",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.viewPagePosition ==
                                                  0
                                                  ? Colors.white
                                                  : Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    this.setState(() {
                                      if (true) {
                                        widget.viewPagePosition = 1;
                                        pageController2.animateToPage(1,
                                            duration:
                                            new Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      //index == 0 ? widget.first = true :false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.viewPagePosition == 1
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Afternoon",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.viewPagePosition ==
                                                  1
                                                  ? Colors.white
                                                  : Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    this.setState(() {
                                      if (true) {
                                        widget.viewPagePosition = 2;
                                        pageController2.animateToPage(2,
                                            duration:
                                            new Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      }

                                      //index == 0 ? widget.first = true :false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.viewPagePosition == 2
                                            ? Colors.blue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(0),
                                        shape: BoxShape.rectangle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ]),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Evening",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: widget.viewPagePosition ==
                                                  2
                                                  ? Colors.white
                                                  : Colors.blue),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(0),
                      shape: BoxShape.rectangle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ])),
            ),

            Container(
              height: 500,
              child: PageView(
                controller: pageController2,
                onPageChanged: (index) {
                  //   showThisToast("changed to " + index.toString());

                  this.setState(() {
                    widget.viewPagePosition = index;
                  });
                },
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: widget.allDaysSlotsMorning.length == 0
                        ? Text("Chamber Closed at Morning")
                        : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allDaysSlotsMorning.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .width /
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6),
                          crossAxisCount: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                          onTap: () {
                            if (widget.allDaysSlotsMorning[index_]['status']) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationFormActivity(
                                              widget.selectedYear.toString() +
                                                  "-" +
                                                  widget.selectedMonth
                                                      .toString() +
                                                  "-" +
                                                  widget.selectedDate
                                                      .toString(),
                                              widget.allDaysSlotsMorning[index_]
                                              ['message'],
                                              widget.docProfile["id"]
                                                  .toString(),
                                              widget.docProfile["name"],
                                              widget.docProfile[
                                              "video_appointment_rate"]
                                                  .toString() +
                                                  " £")));
                            }
                          },
                          child: Container(
                            height: 50,
                            child: Card(
                              color: widget
                                  .allDaysSlotsMorning[index_]['status']
                                  ? Colors.white
                                  : Colors.grey,
                              child: Center(
                                child: new Text(
                                    widget.allDaysSlotsMorning[index_]
                                    ['status']
                                        ? widget
                                        .allDaysSlotsMorning[index_]['message']
                                        : "Taken"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: widget.allDaysSlotsAfterNoon.length == 0
                        ? Text("Chamber Closed at Afternoon")
                        : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allDaysSlotsAfterNoon.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .width /
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6),
                          crossAxisCount: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                          onTap: () {
                            if (widget
                                .allDaysSlotsAfterNoon[index_]['status']) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationFormActivity(
                                              widget.selectedYear.toString() +
                                                  "-" +
                                                  widget.selectedMonth
                                                      .toString() +
                                                  "-" +
                                                  widget.selectedDate
                                                      .toString(),
                                              widget
                                                  .allDaysSlotsAfterNoon[index_]
                                              ['message'],
                                              widget.docProfile["id"]
                                                  .toString(),
                                              widget.docProfile["name"],
                                              widget.docProfile[
                                              "video_appointment_rate"]
                                                  .toString() +
                                                  " £")));
                            }
                          },
                          child: Container(
                            height: 50,
                            child: Card(
                              color: widget
                                  .allDaysSlotsAfterNoon[index_]['status']
                                  ? Colors.white
                                  : Colors.grey,
                              child: Center(
                                child: new Text(
                                    widget.allDaysSlotsAfterNoon[index_]
                                    ['status']
                                        ? widget
                                        .allDaysSlotsAfterNoon[index_]['message']
                                        : "Taken"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: widget.allDaysSlotsevening.length == 0
                        ? Text("Chamber Closed at Evening")
                        : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.allDaysSlotsevening.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .width /
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .height / 6),
                          crossAxisCount: (MediaQuery
                              .of(context)
                              .orientation ==
                              Orientation.portrait)
                              ? 2
                              : 3),
                      itemBuilder: (BuildContext context, int index_) {
                        return new InkWell(
                          onTap: () {
                            if (widget.allDaysSlotsevening[index_]['status']) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ConsultationFormActivity(
                                              widget.selectedYear.toString() +
                                                  "-" +
                                                  widget.selectedMonth
                                                      .toString() +
                                                  "-" +
                                                  widget.selectedDate
                                                      .toString(),
                                              widget.allDaysSlotsevening[index_]
                                              ['message'],
                                              widget.docProfile["id"]
                                                  .toString(),
                                              widget.docProfile["name"],
                                              widget.docProfile[
                                              "video_appointment_rate"]
                                                  .toString() +
                                                  " £")));
                            }
                          },
                          child: Container(
                            height: 50,
                            child: Card(
                              color: widget
                                  .allDaysSlotsevening[index_]['status']
                                  ? Colors.white
                                  : Colors.grey,
                              child: Center(
                                child: new Text(
                                    widget.allDaysSlotsevening[index_]
                                    ['status']
                                        ? widget
                                        .allDaysSlotsevening[index_]['message']
                                        : "Taken"),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

 */


          ],
        ),
      ),

       */
    );
  }
}
class ConsultationFormActivity2 extends StatefulWidget {

  String date ;
  String s_time ;
  String hospital_id ;
  String doc_id ;
  String doc_name ;
  String doc_fees ;
  String dateLong ;
  String s_time_key ;
  String reasonForAppointment;
  String anyHealthCondition;
  String anyAllergy;
  bool isProcessing = false ;

  ConsultationFormActivity2(this.date,this.s_time,this.hospital_id,this.doc_id,this.doc_name,this.doc_fees,this.dateLong,this.s_time_key);
  @override
  _ConsultationFormActivity2State createState() => _ConsultationFormActivity2State();
}

class _ConsultationFormActivity2State extends State<ConsultationFormActivity2> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Stack(
        children: [
          Positioned(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(

                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryColor, Colors.white])),
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
                      child: Text("Consultation Form",style: TextStyle(fontSize: 20,color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),

          ),
         widget.isProcessing?Center(child: CircularProgressIndicator(),): Positioned(
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
                child:SingleChildScrollView(
                  child:    Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListTile(title: Text("Date : "+widget.date),subtitle: Text("Time : "+widget.s_time),),

                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 00, 10, 0),
                          child: TextFormField(
                            initialValue: "",
                            validator: (value) {
                              widget.reasonForAppointment = value;
                              if (value.isEmpty) {
                                return 'Please enter reason for appointment';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Reason for appointment",
                                ),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 00, 10, 0),
                          child: TextFormField(
                            initialValue: "",
                            validator: (value) {
                              widget.anyHealthCondition = value;
                              if (value.isEmpty) {
                                return 'Please enter your health condition';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Any health condition",
                            ),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 00, 10, 0),
                          child: TextFormField(
                            initialValue: "",
                            validator: (value) {
                              widget.anyAllergy = value;
                              if (value.isEmpty) {
                                return 'Please enter your allary(if any)';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Any allergy history",
                            ),
                            keyboardType: TextInputType.text,
                            autocorrect: false,
                          ),
                        ),
                        InkWell(
                          onTap: ()async{
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                widget.isProcessing = true;

                              });

                              Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                              SharedPreferences prefs = await _prefs;
                              final http.Response response = await http.post(
                                "https://api.callgpnow.com/api/" + 'add-appointment-info',
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': AUTH_KEY,
                                },
                                body: jsonEncode(<String, String>{
                                  'patient_id': prefs.getString("uid"),
                                  'dr_id': widget.doc_id,
                                  'problems': widget.reasonForAppointment,
                                  'reasonToVisit': widget.reasonForAppointment,
                                  'date_app': widget.date,
                                  'status': "1",
                                  's_time': widget.s_time,
                                  'e_time': widget.s_time,
                                  'time_slot': widget.s_time,
                                  'dateLong': widget.dateLong,
                                  's_time_key': widget.s_time_key,
                                  'hospital_id': widget.hospital_id,
                                  'appointment_for': "0",
                                  'allergy':widget.anyAllergy,
                                }),
                              );
                              setState(() {
                                widget.isProcessing = false ;
                              });

                             Navigator.pop(context);
                             Navigator.pop(context);
                             Navigator.pop(context);
                             Navigator.pop(context);

                            }else{
                              showThisToast("Form is not ready");
                            }




                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                            child: Card(
                              color: primaryColor,
                              child: Container(height: 45,child: Center(child: Text("Book Now",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) ,
              ),
            ),
          )
        ],
      ),

    );
  }
}
