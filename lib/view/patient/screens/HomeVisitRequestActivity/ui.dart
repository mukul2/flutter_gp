import 'dart:convert';

import 'package:maulaji/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maulaji/view/patient/screens/HomeVisitDocListActivity/ui.dart';
import 'package:maulaji/view/patient/screens/SimpleDoctorProfileActivity/ui.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";


class HomeVisitRequestActivity extends StatefulWidget {

  String selctedDate_ = DateTime.now().toIso8601String();
  String selctedDate_Birthdate = DateTime.now().toIso8601String();
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateBirthDate = DateTime.now();
  String dateToUpdate = (DateTime.now().year).toString() + "-" + (DateTime.now().month).toString() + "-" + (DateTime.now().day).toString();
  String dateToUpdateBirthDay = (DateTime.now().year).toString() + "-" + (DateTime.now().month).toString() + "-" + (DateTime.now().day).toString();
  String fomatedDate;
  String fomatedDateBirth;
  var currentPageValue = 0.0;
  bool isSearching = true ;
  String id;
  List downloadedData ;
  bool _enabled2 = true;
  String selectedHospital;
  String selectedHospitalName="Select";
  bool isLoading = true ;
  bool isSubmitting = false ;
  String name,reason,chosenDate,birthdate,hospital,email,phone,address;
  String doc_ID ;
  HomeVisitRequestActivity(this.doc_ID);
  @override
  _ChooseDoctorChamberState createState() => _ChooseDoctorChamberState();
}

class _ChooseDoctorChamberState extends State<HomeVisitRequestActivity> {
  final _formKey = GlobalKey<FormState>();
  PageController _controller = PageController(
      initialPage: 0, viewportFraction: 0.8
  );
Future<List>  getHospitalData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    final http.Response response = await http.get(
      "https://api.callgpnow.com/api/" + 'hospital_list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("auth"),
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    print(response.body);

    return json.decode(response.body);

    //showThisToast(downloadedData.length.toString());
  }
  @override
  void initState() {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
   // SharedPreferences  prefs = await _prefs;
    _prefs.then((prefs) {
      setState(() {
        widget.name = prefs.getString("uname");
      });

    });
setState(() {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat.yMMMMd('en_US');
  final String formatted = formatter.format(now);
   widget.fomatedDate = formatted;
   widget.fomatedDateBirth = formatted;
});

  }
  Future<Null> _selectBirthDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDateBirthDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDateBirthDate)
      setState(() {
        widget. selectedDateBirthDate = picked;
        widget.selctedDate_Birthdate = widget.selectedDateBirthDate.toIso8601String();
        widget. dateToUpdateBirthDay = (picked.year).toString() +
            "-" +
            (picked.month).toString() +
            "-" +
            (picked.day).toString();


        final DateFormat formatter = DateFormat.yMMMMd('en_US');
        final String formatted = formatter.format(picked);
        widget.fomatedDateBirth = formatted;
      });
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != widget.selectedDate)
      setState(() {
        widget. selectedDate = picked;
        widget.selctedDate_ = widget.selectedDate.toIso8601String();
        widget. dateToUpdate = (picked.year).toString() +
            "-" +
            (picked.month).toString() +
            "-" +
            (picked.day).toString();


        final DateFormat formatter = DateFormat.yMMMMd('en_US');
        final String formatted = formatter.format(picked);
        widget.fomatedDate = formatted;
      });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // appBar: AppBar(title: Text("Choose Doctor"),),

      body: Stack(
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
                      child: Text("Home Visits",style: TextStyle(fontSize: 20,color: Colors.white),),
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

                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 00, 0, 0),
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEAECEE),
                                borderRadius:  BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                initialValue: widget.name,
                                validator: (value) {
                                  widget.name = value;
                                  if (value.isEmpty) {
                                    return "Please enter patient's name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText: "Patient's Name",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffEAECEE),
                              borderRadius:  BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              minLines: 3,
                              maxLines: 5,
                              validator: (value) {
                                widget.reason = value;
                                if (value.isEmpty) {
                                  return 'Please enter reason for Visit';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 14),
                                hintText: "Reason for Visit",

                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),

                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffEAECEE),
                              borderRadius:  BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.fomatedDate,),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Icon(Icons.arrow_drop_down),
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(onTap:(){
                                      _selectDate(context);
                                    },child: Text("Prefared Date",style: TextStyle(color: Colors.blue),)),
                                  )
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 00, 0, 0),
                          ),

                          Visibility(
                            visible: false,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xffEAECEE),
                                borderRadius:  BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.fomatedDateBirth,),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Icon(Icons.arrow_drop_down),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(onTap:(){
                                        _selectBirthDate(context);
                                      },child: Text("Birth Date",style: TextStyle(color: Colors.blue),)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) {
                                    return Container(
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          1,
                                      child: Scaffold(

                                        body: FutureBuilder(
                                          future: getHospitalData(),
                                          builder: (context, projectSnap) {
                                          return projectSnap.data!=null? ListView.builder(
                                            itemCount: projectSnap.data == null ? 0 : projectSnap.data.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return new InkWell(
                                                  onTap:
                                                      () {
                                                    this.setState(
                                                            () {
                                                              widget.selectedHospitalName = projectSnap.data[index]["name"];

                                                          widget.selectedHospital =  projectSnap.data[index]["id"];

                                                          Navigator.pop(context);
                                                        });
                                                  },
                                                  child:
                                                  Card(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(0.0),
                                                    ),
                                                    child:
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.all(0),
                                                      child:
                                                      ListTile(
                                                        // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                                        // trailing: widget.selectedHospital == index
                                                        //     ? Icon(Icons.done, color: Colors.blue)
                                                        //     : Icon(Icons.done, color: Colors.white),

                                                        title:
                                                        new Text(
                                                          projectSnap.data[index]["name"],
                                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            },
                                          )
                                              : Center(
                                              child:
                                              CircularProgressIndicator());
                                          }

                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xffEAECEE),
                                borderRadius:  BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.selectedHospitalName,),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Icon(Icons.arrow_drop_down),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(onTap:(){
                                       // _selectDate(context);
                                      },child: Text("Hospital",style: TextStyle(color: Colors.blue),)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEAECEE),
                                borderRadius:  BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  widget.email = value;
                                  if (value.isEmpty) {
                                    return 'Please enter Email address';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText: "Email",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEAECEE),
                                borderRadius:  BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                validator: (value) {
                                  widget.phone = value;
                                  if (value.isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText: "Phone",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          Visibility(
                            visible: false,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffEAECEE),
                                borderRadius:  BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                minLines: 3,
                                maxLines: 5,
                                validator: (value) {
                                  widget.address = value;
                                  if (value.isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 14),
                                  hintText: "Address",

                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          ),
                          InkWell(

                            onTap: ()async{

                              Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                              SharedPreferences prefs = await _prefs;
                              String uid =await getPatientID();
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  widget.isSubmitting = true ;
                                });
                                homeVisitRequest(widget.doc_ID,
                                    uid,
                                    widget.reason,
                                    prefs.getString("uname"),
                                    widget.reason,
                                    widget.fomatedDateBirth,
                                    widget.selectedHospital,
                                    prefs.getString("umail"),
                                    widget.address,
                                    widget.dateToUpdate,
                                    prefs.getString("uphone")).then((value) {
                                    setState(() {
                                    widget.isSubmitting = false ;
                                  });
                                    Navigator.pop(context);
                                  print(value);
                                });
                              }
                            },
                            child: Card(
                              color: primaryColor,

                              child: Container(width: double.infinity,height:50,child: Center(child: Text("Submit Request",style: TextStyle(color: Colors.white),))),
                            ),
                          )

                        ],

                      ),
                    ),
                  ),
                ),

                //  convert this

              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: widget.isSubmitting?Card(
              child: Container(
                height: 100,
                width: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Please Wait"),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ):Text("")
          ),

        ],
      ),





    );
  }
}