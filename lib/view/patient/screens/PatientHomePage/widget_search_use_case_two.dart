import 'dart:convert';

import 'package:maulaji/cachedData.dart';
import 'package:maulaji/chat/model/chat_screen.dart';
import 'package:maulaji/view/patient/OnlineDoctorsList.dart';
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/GPlistSearchActivity/ui.dart';
import 'package:maulaji/view/patient/screens/HomeVisitDocListActivity/ui.dart';
import 'package:maulaji/view/patient/screens/HomeVisitRequestActivity/ui.dart';
import 'package:maulaji/view/patient/screens/UrgentCareDocListActivity/ui.dart';
import 'package:maulaji/view/patient/screens/UrgentVisitRequestActivity/ui.dart';
import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
String PHOTO_BASE_PHARMACY = "https://callgpnow.com/images/";
Color primaryColor = Colors.red;
class DoctorSearchActivityUseCaseTwo extends StatefulWidget {
  List downloadedData = [];
  List showData = [];
  List deptList = null;
  List lookingForList = [];
  int selectedPosition = -1;
  int typeSelectedPosition = 0;
  double boxHeight = 200;

  List chooseLocationObject = [];
  int selectedCoutry = 223;

  int selectedCity = 0;

  int selectedHospital = -1;

  String locationData =
      '[{"country":"United Kingdom","levels":[{"name":"First level 1","levels":["Second Level 1","Second Level 2"]},{"name":"First level 2","levels":["Second Level 1","Second Level 2"]},{"name":"First level 3","levels":["Second Level 1","Second Level 2"]}]},{"country":"United States","levels":[{"name":"First level 1","levels":["Second Level 1","Second Level 2"]},{"name":"First level 2","levels":["Second Level 1","Second Level 2"]},{"name":"First level 3","levels":["Second Level 1","Second Level 2"]}]}]';
  List country = [];
  List city = [];
  List hospitals = [];
  bool _enabled2 = true;

  @override
  _DoctorSearchActivityUseCaseTwoState createState() =>
      _DoctorSearchActivityUseCaseTwoState();
}

class _DoctorSearchActivityUseCaseTwoState
    extends State<DoctorSearchActivityUseCaseTwo> {
  String key;

  getData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    final http.Response response = await http.post(
      "https://api.callgpnow.com/api/" + 'doctor-search',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("auth"),
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    // showThisToast(response.statusCode.toString());

    setState(() {
      widget.downloadedData = json.decode(response.body);
      //showThisToast("doc size "+widget.downloadedData.length.toString());
      widget.showData.clear();
      widget.showData.addAll(widget.downloadedData);
    });

    //showThisToast(downloadedData.length.toString());
  }

  getCountryData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    final http.Response response = await http.get(
      "https://api.callgpnow.com/api/" + 'country-list',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("auth"),
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    print(response.body);
    // showThisToast(response.statusCode.toString());

    setState(() {
      widget.country.clear();
      widget.country = json.decode(response.body);
      widget.city.clear();
      getCity(widget.country[widget.selectedCoutry]["iso3"]);
      //showThisToast("doc size "+widget.downloadedData.length.toString());
      //  widget.showData.clear();
      //  widget.showData.addAll(widget.downloadedData);
    });

    //showThisToast(downloadedData.length.toString());
  }

  getHospitalData() async {
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
    // showThisToast(response.statusCode.toString());

    setState(() {
      widget.hospitals.clear();
      widget.hospitals = json.decode(response.body);
    });

    //showThisToast(downloadedData.length.toString());
  }

  getCity(String country) async {
    print("fetch city of " + country);

    //  showThisToast("fetch city of "+country);
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    final http.Response response = await http.get(
      "https://api.callgpnow.com/api/" +
          'city-list-by-country?country=' +
          country,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("auth"),
      },
      // body: jsonEncode(<String, String>{'department_id': "17"}),
    );
    print(response.body);
    // showThisToast(response.statusCode.toString());
    setState(() {
      widget.city = json.decode(response.body);
      //showThisToast("city size  "+widget.city.length.toString());

      //showThisToast("doc size "+widget.downloadedData.length.toString());
      //  widget.showData.clear();
      //  widget.showData.addAll(widget.downloadedData);
    });

    //showThisToast(downloadedData.length.toString());
  }

  getDeptListData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    if (cachedDeptList == null) {
      print("api hit => " + "department-list");
      final http.Response response = await http.get(
        "https://api.callgpnow.com/api/" + 'department-list',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': prefs.getString("auth"),
        },
      );
      print(response.body);
      setState(() {
        cachedDeptList = json.decode(response.body);
        widget.deptList = cachedDeptList;
        // widget.deptList = widget.deptList.sublist(0, 10);
      });
    } else {
      setState(() {
        print("loaded from cache");
        widget.deptList = cachedDeptList;
        // widget.deptList = widget.deptList.sublist(0, 10);
      });
    }

    // data_ = json.decode(response.body);

    // showThisToast("dept size "+response.body);
  }

  showDepartmentChooseBottomSheet() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.getData();
    this.getCountryData();
    this.getHospitalData();

    setState(() {
      /*  widget.lookingForList.add("GP");
      widget.lookingForList.add("Specialist");
      widget.lookingForList.add("Urgent Care");
      widget.lookingForList.add("Home Visit");

     */
      widget.chooseLocationObject = jsonDecode(widget
          .locationData); // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 50;
    var _aspectRatio = _width / cellHeight;
    var _aspectRatio2 = _width / 50;
    setState(() {
      widget.lookingForList.clear();
      widget.lookingForList.add("Doctor");
      widget.lookingForList.add("Specialist");
      widget.lookingForList.add("Urgent Care");
      widget.lookingForList.add("Home Visit");
    });
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.white,
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Image.asset(
                            "assets/wide_logo.png",
                            height: 70,
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Text(
                            "Goodbye doubts",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Text(
                            "Find and Book Doctors",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          height: 15,
                          color: Colors.red,
                        ),
                        Card(
                          color: primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Text("Available 24x7 Consultation",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: widget.boxHeight,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        color: Colors.white,
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Im Looking for"),
                                widget.lookingForList != null
                                    ? GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: _crossAxisCount,
                                                childAspectRatio:
                                                    _aspectRatio2),
                                        shrinkWrap: true,
                                        itemCount: widget.lookingForList == null
                                            ? 0
                                            : widget.lookingForList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return new Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 2, 5, 2),
                                            child: Card(
                                              color:
                                                  widget.typeSelectedPosition ==
                                                          index
                                                      ?primaryColor
                                                      : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (index == 1) {
                                                      widget.boxHeight = 250;
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (ctx) {
                                                            return Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  1,
                                                              child: Scaffold(
                                                                appBar: AppBar(
                                                                  elevation: 0,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  title: Text(
                                                                    "Choose Depatment",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  iconTheme: IconThemeData(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                body: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    ListTile(
                                                                      title: Text(
                                                                          "Commonly Searched Specialities",
                                                                          style:
                                                                              TextStyle(fontSize: 14)),
                                                                      trailing:
                                                                          Text(
                                                                        "More Specialities",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              5,
                                                                              0,
                                                                              5,
                                                                              0),
                                                                      child: FutureBuilder(
                                                                          future: getDeptListData(),
                                                                          builder: (context, projectSnap) {
                                                                            return widget.deptList != null
                                                                                ? GridView.builder(
                                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _crossAxisCount, childAspectRatio: _aspectRatio),
                                                                                    shrinkWrap: true,
                                                                                    itemCount: widget.deptList == null ? 0 : widget.deptList.length,
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return new Padding(
                                                                                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                                                                                        child: Card(
                                                                                          color: widget.selectedPosition == index ? Colors.blue : Colors.white,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(30.0),
                                                                                          ),
                                                                                          child: InkWell(
                                                                                            onTap: () {
                                                                                              setState(() {
                                                                                                widget.selectedPosition = index;
                                                                                              });
                                                                                              Navigator.pop(context);

                                                                                              /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChooseDoctorOnline(
                                          (widget.deptList[index]["id"])
                                              .toString())));

                               */
                                                                                            },
                                                                                            child: Container(
                                                                                              height: 25,
                                                                                              child: Center(
                                                                                                  child: Padding(
                                                                                                padding: EdgeInsets.all(0),
                                                                                                child: new Text(
                                                                                                  widget.deptList[index]["speciality"],
                                                                                                  textAlign: TextAlign.center,
                                                                                                  style: TextStyle(
                                                                                                    color: widget.selectedPosition == index ? Colors.white : Colors.black,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ),
                                                                                              )),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  )
                                                                                : Center(child: CircularProgressIndicator());
                                                                          }),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    } else {
                                                      widget.boxHeight = 200;
                                                    }
                                                    widget.typeSelectedPosition =
                                                        index;
                                                  });

                                                  /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChooseDoctorOnline(
                                          (widget.deptList[index]["id"])
                                              .toString())));

                               */
                                                },
                                                child: Container(
                                                  height: 25,
                                                  child: Center(
                                                      child: Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 0, 15, 0),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.done,
                                                              color:
                                                                  widget.typeSelectedPosition ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .white,
                                                            ),
                                                          ),
                                                        ),
                                                        new Text(
                                                          widget.lookingForList[
                                                              index],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                widget.typeSelectedPosition ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : CircularProgressIndicator(),
                                widget.typeSelectedPosition == 1
                                    ? InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (ctx) {
                                                return Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      1,
                                                  child: Scaffold(
                                                    appBar: AppBar(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.white,
                                                      title: Text(
                                                        "Choose Depatment",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      iconTheme: IconThemeData(
                                                          color: Colors.black),
                                                    ),
                                                    body: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                              "Commonly Searched Specialities",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          trailing: Text(
                                                            "More Specialities",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 0, 5, 0),
                                                          child: FutureBuilder(
                                                              future:
                                                                  getDeptListData(),
                                                              builder: (context,
                                                                  projectSnap) {
                                                                return widget
                                                                            .deptList !=
                                                                        null
                                                                    ? GridView
                                                                        .builder(
                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                            crossAxisCount:
                                                                                _crossAxisCount,
                                                                            childAspectRatio:
                                                                                _aspectRatio),
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: widget.deptList ==
                                                                                null
                                                                            ? 0
                                                                            : widget.deptList.length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          return new Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                5,
                                                                                2,
                                                                                5,
                                                                                2),
                                                                            child:
                                                                                Card(
                                                                              color: widget.selectedPosition == index ? Colors.blue : Colors.white,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(30.0),
                                                                              ),
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    widget.selectedPosition = index;
                                                                                  });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  height: 25,
                                                                                  child: Center(
                                                                                      child: Padding(
                                                                                    padding: EdgeInsets.all(0),
                                                                                    child: new Text(
                                                                                      widget.deptList[index]["speciality"],
                                                                                      textAlign: TextAlign.center,
                                                                                      style: TextStyle(
                                                                                        color: widget.selectedPosition == index ? Colors.white : Colors.black,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            CircularProgressIndicator());
                                                              }),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 20, 0, 0),
                                            ),
                                            Text("Speciality or doctor"),
                                            Text(
                                              widget.selectedPosition != -1
                                                  ? widget.deptList[widget
                                                          .selectedPosition]
                                                      ["speciality"]
                                                  : "Tap to select speciality or doctor",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 1,
                                      ),
                                Visibility(
                                  visible: false,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text("Prefered Location"),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: InkWell(
                                          onTap: () {
                                            //this.getCountryData();
                                            setState(() {
                                              widget.chooseLocationObject =
                                                  jsonDecode(widget
                                                      .locationData); // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                              // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                            });
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        1,
                                                    child: Scaffold(
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        title: Text(
                                                          "Choose Country",
                                                          style: TextStyle(
                                                              color: Colors.black),
                                                        ),
                                                        iconTheme: IconThemeData(
                                                            color: Colors.black),
                                                      ),
                                                      body: FutureBuilder(
                                                          future: getCountryData(),
                                                          builder: (context,
                                                              projectSnap) {
                                                            return widget.country !=
                                                                    null
                                                                ? ListView.builder(
                                                                    itemCount: widget
                                                                                .country ==
                                                                            null
                                                                        ? 0
                                                                        : widget
                                                                            .country
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return new InkWell(
                                                                          onTap:
                                                                              () {
                                                                            this.getCity(widget.country[widget.selectedCoutry]
                                                                                [
                                                                                "iso3"]);
                                                                            this.setState(
                                                                                () {
                                                                              widget.selectedCoutry =
                                                                                  index;
                                                                              widget.selectedCity =
                                                                                  -1;
                                                                              widget.selectedHospital =
                                                                                  -1;
                                                                              Navigator.pop(
                                                                                  context);
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
                                                                                trailing: widget.selectedCoutry == index
                                                                                    ? Icon(Icons.done, color: Colors.blue)
                                                                                    : Icon(Icons.done, color: Colors.white),

                                                                                title:
                                                                                    new Text(
                                                                                  widget.country[index]["nicename"],
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
                                                          }),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Card(
                                            elevation: 5,
                                            color:
                                                Color.fromARGB(255, 248, 248, 248),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(03.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            widget.country.length >
                                                                    0
                                                                ? widget.selectedCoutry !=
                                                                        -1
                                                                    ? widget.country[
                                                                            widget
                                                                                .selectedCoutry]
                                                                        ["nicename"]
                                                                    : "Choose"
                                                                : "Choose",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .fromLTRB(
                                                              10, 0, 0, 0),
                                                          child: Icon(Icons
                                                              .arrow_drop_down),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text("Country"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: InkWell(
                                          onTap: () {
                                            //this.getCountryData();

                                            showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        1,
                                                    child: Scaffold(
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        title: Text(
                                                          "Choose City",
                                                          style: TextStyle(
                                                              color: Colors.black),
                                                        ),
                                                        iconTheme: IconThemeData(
                                                            color: Colors.black),
                                                      ),
                                                      body: widget.city != null
                                                          ? ListView.builder(
                                                              itemCount:
                                                                  widget.city ==
                                                                          null
                                                                      ? 0
                                                                      : widget.city
                                                                          .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return new InkWell(
                                                                    onTap: () {
                                                                      this.setState(
                                                                          () {
                                                                        widget.selectedCity =
                                                                            index;
                                                                        widget.selectedHospital =
                                                                            -1;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    },
                                                                    child: Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                0.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets
                                                                                .all(0),
                                                                        child:
                                                                            ListTile(
                                                                          // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                                                          trailing: widget.selectedCity ==
                                                                                  index
                                                                              ? Icon(Icons.done,
                                                                                  color: Colors
                                                                                      .blue)
                                                                              : Icon(
                                                                                  Icons.done,
                                                                                  color: Colors.white),

                                                                          title:
                                                                              new Text(
                                                                            widget.city[index]
                                                                                [
                                                                                "city"],
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                              },
                                                            )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Card(
                                            elevation: 5,
                                            color:
                                                Color.fromARGB(255, 248, 248, 248),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(03.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            widget.city.length > 0
                                                                ? widget.selectedCity !=
                                                                        -1
                                                                    ? widget.city[widget
                                                                            .selectedCity]
                                                                        ["city"]
                                                                    : "Choose"
                                                                : "Choose",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .fromLTRB(
                                                              10, 0, 0, 0),
                                                          child: Icon(Icons
                                                              .arrow_drop_down),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text("city"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: InkWell(
                                          onTap: () {
                                            //this.getCountryData();

                                            showModalBottomSheet(
                                                context: context,
                                                builder: (ctx) {
                                                  return Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        1,
                                                    child: Scaffold(
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        title: Text(
                                                          "Choose Hospital",
                                                          style: TextStyle(
                                                              color: Colors.black),
                                                        ),
                                                        iconTheme: IconThemeData(
                                                            color: Colors.black),
                                                      ),
                                                      body: widget.hospitals != null
                                                          ? ListView.builder(
                                                              itemCount:
                                                                  widget.hospitals ==
                                                                          null
                                                                      ? 0
                                                                      : widget
                                                                          .hospitals
                                                                          .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return new InkWell(
                                                                    onTap: () {
                                                                      this.setState(
                                                                          () {
                                                                        widget.selectedHospital =
                                                                            index;

                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    },
                                                                    child: Card(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                0.0),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets
                                                                                .all(0),
                                                                        child:
                                                                            ListTile(
                                                                          // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                                                          trailing: widget.selectedHospital ==
                                                                                  index
                                                                              ? Icon(Icons.done,
                                                                                  color: Colors
                                                                                      .blue)
                                                                              : Icon(
                                                                                  Icons.done,
                                                                                  color: Colors.white),

                                                                          title:
                                                                              new Text(
                                                                            widget.hospitals[index]
                                                                                [
                                                                                "name"],
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ));
                                                              },
                                                            )
                                                          : Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                    ),
                                                  );
                                                });
                                          },
                                          child: Card(
                                            elevation: 5,
                                            color:
                                                Color.fromARGB(255, 248, 248, 248),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(03.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            widget.hospitals
                                                                        .length >
                                                                    0
                                                                ? widget.selectedHospital !=
                                                                        -1
                                                                    ? widget.hospitals[
                                                                            widget
                                                                                .selectedHospital]
                                                                        ["name"]
                                                                    : "Choose"
                                                                : "Choose",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .fromLTRB(
                                                              10, 0, 0, 0),
                                                          child: Icon(Icons
                                                              .arrow_drop_down),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text("Hospital"),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // InkWell(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       widget.chooseLocationObject = jsonDecode(widget.locationData); // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                      //
                                      //       // showThisToast("location object size "+widget.chooseLocationObject.length.toString());
                                      //     });
                                      //     if (widget.selectedCoutry != -1) {
                                      //       showModalBottomSheet(
                                      //           context: context,
                                      //           builder: (ctx) {
                                      //             return Container(
                                      //               height: MediaQuery.of(context)
                                      //                       .size
                                      //                       .height *
                                      //                   1,
                                      //               child: Scaffold(
                                      //                 appBar: AppBar(
                                      //                   backgroundColor:
                                      //                       Colors.white,
                                      //                   title: Text(
                                      //                     "Choose City",
                                      //                     style: TextStyle(
                                      //                         color:
                                      //                             Colors.black),
                                      //                   ),
                                      //                   iconTheme: IconThemeData(
                                      //                       color: Colors.black),
                                      //                 ),
                                      //                 body: ListView.builder(
                                      //                   itemCount: widget.chooseLocationObject[
                                      //                                   widget
                                      //                                       .selectedCoutry]
                                      //                               ["levels"] ==
                                      //                           null
                                      //                       ? 0
                                      //                       : widget
                                      //                           .chooseLocationObject[
                                      //                               widget
                                      //                                   .selectedCoutry]
                                      //                               ["levels"]
                                      //                           .length,
                                      //                   itemBuilder:
                                      //                       (BuildContext context,
                                      //                           int index) {
                                      //                     return new InkWell(
                                      //                         onTap: () {
                                      //                           this.setState(() {
                                      //                             widget.selectedCity =
                                      //                                 index;
                                      //                             widget.selectedHospital =
                                      //                                 -1;
                                      //                             Navigator.pop(
                                      //                                 context);
                                      //                           });
                                      //                         },
                                      //                         child: Card(
                                      //                           shape:
                                      //                               RoundedRectangleBorder(
                                      //                             borderRadius:
                                      //                                 BorderRadius
                                      //                                     .circular(
                                      //                                         0.0),
                                      //                           ),
                                      //                           child: Padding(
                                      //                             padding:
                                      //                                 EdgeInsets
                                      //                                     .all(0),
                                      //                             child: ListTile(
                                      //                               // trailing: Icon(Icons.done,color: widget.selectedCoutry==index?Colors.green:Colors.white,),
                                      //                               trailing: widget
                                      //                                           .selectedCity ==
                                      //                                       index
                                      //                                   ? Icon(
                                      //                                       Icons
                                      //                                           .done,
                                      //                                       color: Colors
                                      //                                           .blue)
                                      //                                   : Icon(
                                      //                                       Icons
                                      //                                           .done,
                                      //                                       color:
                                      //                                           Colors.white),
                                      //
                                      //                               title:
                                      //                                   new Text(
                                      //                                 widget.chooseLocationObject[widget.selectedCoutry]["levels"]
                                      //                                         [
                                      //                                         index]
                                      //                                     [
                                      //                                     "name"],
                                      //                                 style: TextStyle(
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .bold,
                                      //                                     color: Colors
                                      //                                         .black),
                                      //                               ),
                                      //                             ),
                                      //                           ),
                                      //                         ));
                                      //                   },
                                      //                 ),
                                      //               ),
                                      //             );
                                      //           });
                                      //     } else {
                                      //       showThisToast("Select Country First");
                                      //     }
                                      //   },
                                      //   child: Card(
                                      //     elevation: 5,
                                      //     color:
                                      //         Color.fromARGB(255, 248, 248, 248),
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(03.0),
                                      //     ),
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Stack(
                                      //         children: [
                                      //           Align(
                                      //             alignment: Alignment.centerLeft,
                                      //             child: Row(
                                      //               children: [
                                      //                 Text(
                                      //                     widget.selectedCity !=
                                      //                             -1
                                      //                         ? widget.chooseLocationObject[widget
                                      //                                         .selectedCoutry]
                                      //                                     [
                                      //                                     "levels"]
                                      //                                 [
                                      //                                 widget
                                      //                                     .selectedCity]
                                      //                             ["name"]
                                      //                         : "Choose",
                                      //                     style: TextStyle(
                                      //                         fontWeight:
                                      //                             FontWeight
                                      //                                 .bold)),
                                      //                 Padding(
                                      //                   padding: const EdgeInsets
                                      //                           .fromLTRB(
                                      //                       10, 0, 0, 0),
                                      //                   child: Icon(Icons
                                      //                       .arrow_drop_down),
                                      //                 )
                                      //               ],
                                      //             ),
                                      //           ),
                                      //           Align(
                                      //             alignment:
                                      //                 Alignment.centerRight,
                                      //             child: Text("City"),
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        //showThisToast();
                        if (widget.typeSelectedPosition == 0) {
                          //gp

                          Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: GPSearchActivity()));
/*
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GPSearchActivity()));

 */
                        } else if (widget.typeSelectedPosition == 1) {
                          //specialist

                          Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: ChooseDoctorOnline(
                                      (widget.deptList[widget.selectedPosition]
                                              ["id"])
                                          .toString())));
                          /*
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseDoctorOnline(
                                      (widget.deptList[widget.selectedPosition]
                                      ["id"])
                                          .toString())));

                           */
                        } else if (widget.typeSelectedPosition == 2) {
                          //urgent
/*
                          Navigator.push(context,
                              EnterExitRoute(exitPage: this.widget, enterPage: UrgentSearchActivity()));

 */

                          Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: UrgentSearchActivity()));
                          /*
                          Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: UrgentRequestActivity()));
                          */
                        } else if (widget.typeSelectedPosition == 3) {
                          //Home
                          Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: HomeVisitDocSearchActivity()));
                          /*
                          Navigator.push(
                              context,
                              EnterExitRoute(
                                  exitPage: this.widget,
                                  enterPage: HomeVisitRequestActivity()));

                           */
                        }
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Wrap(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                  "FIND DOCTOR",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_alt,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/pharmacy10.jpeg",
                          fit: BoxFit.cover,
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Start Shopping",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShopActivity()));
              },
            ),
            widget.typeSelectedPosition == 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text("Commonly Searched Specialities",
                            style: TextStyle(fontSize: 14)),
                        trailing: Text(
                          "More Specialities",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: FutureBuilder(
                            future: getDeptListData(),
                            builder: (context, projectSnap) {
                              return widget.deptList != null
                                  ? GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: _crossAxisCount,
                                              childAspectRatio: _aspectRatio),
                                      shrinkWrap: true,
                                      itemCount: widget.deptList == null
                                          ? 0
                                          : widget.deptList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return new Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 2, 5, 2),
                                          child: Card(
                                            color:
                                                widget.selectedPosition == index
                                                    ? Colors.blue
                                                    : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  widget.selectedPosition =
                                                      index;
                                                });

                                                /*
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChooseDoctorOnline(
                                          (widget.deptList[index]["id"])
                                              .toString())));

                               */
                                              },
                                              child: Container(
                                                height: 25,
                                                child: Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(0),
                                                  child: new Text(
                                                    widget.deptList[index]
                                                        ["speciality"],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:
                                                          widget.selectedPosition ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(child: CircularProgressIndicator());
                            }),
                      )
                    ],
                  )
                : Container(
                    height: 1,
                  ),
          ],
        ),
      ),
    );
  }
}

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(-1.0, 0.0),
                ).animate(animation),
                child: exitPage,
              ),
              SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: enterPage,
              )
            ],
          ),
        );
}

class ShopActivity extends StatefulWidget {
  var currentPageValue = 0;

  @override
  _ShopActivityState createState() => _ShopActivityState();
}

class _ShopActivityState extends State<ShopActivity> {
  PageController controller = PageController(
    initialPage: 0,
  );

  Future<List> getCategoryList() async {
    final http.Response response = await http.post(
      "https://callgpnow.com/api_callgpnow/" + 'getCategory.php',
      headers: <String, String>{
        'Content-Type': 'application/json',

      },
    );
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }

  Future<List> getBrands() async {
    final http.Response response = await http.post(
      "https://callgpnow.com/api_callgpnow/" + 'getBrands.php',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }
  Future<List<ProductModel>> getproductsFromConditions(String condition) async {
    var body = jsonEncode(<String, String>{
      'key': condition,
    });
    final http.Response response = await http.post(
      "https://callgpnow.com/api_callgpnow/" + 'all_medicines.php',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body
    );
    List<ProductModel> allProducts = [];
    List jsonData = jsonDecode(response.body);
    print("size " + jsonData.length.toString());
    for (int i = 0; i < jsonData.length; i++) {
      allProducts.add(ProductModel.fromJson(jsonData[i]));
    }
    print(jsonDecode(response.body));
    return allProducts;
  }
  Future<List<ProductModel>> getproductsFromBrand(String condition) async {
    var body = jsonEncode(<String, String>{
      'key': condition,
    });
    final http.Response response = await http.post(
      "https://callgpnow.com/api_callgpnow/" + 'all_med_by_brand.php',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body
    );
    List<ProductModel> allProducts = [];
    List jsonData = jsonDecode(response.body);
    print("size " + jsonData.length.toString());
    for (int i = 0; i < jsonData.length; i++) {
      allProducts.add(ProductModel.fromJson(jsonData[i]));
    }
    print(jsonDecode(response.body));
    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Maulaji",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/pharmacy10.jpeg",
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              color: Colors.red,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        child: Text("Search Prescription or OTC product"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.red,
                        )),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.currentPageValue = 0;
                                    controller.animateToPage(0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  });
                                },
                                child: Container(
                                  color: widget.currentPageValue == 0
                                      ? Colors.red
                                      : Colors.white,
                                  child: Center(
                                    child: Text(
                                      "Non Prescription",
                                      style: TextStyle(
                                          color: widget.currentPageValue == 0
                                              ? Colors.white
                                              : Colors.red),
                                    ),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.currentPageValue = 1;
                                    controller.animateToPage(1,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  });
                                },
                                child: Container(
                                  color: widget.currentPageValue == 1
                                      ? Colors.red
                                      : Colors.white,
                                  child: Center(
                                    child: Text("Prescription",
                                        style: TextStyle(
                                            color: widget.currentPageValue == 1
                                                ? Colors.white
                                                : Colors.red)),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 200,
              child: PageView(
                controller: controller,
                onPageChanged: (number) {
                  setState(() {
                    widget.currentPageValue = number;
                  });
                },
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(00.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              List<String> byConditions = [];
                              List<String> byBrand = [];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                            body: DefaultTabController(
                                              length: 2,
                                              child: Scaffold(
                                                appBar: AppBar(
                                                  backgroundColor: primaryColor,
                                                  bottom: TabBar(
                                                    isScrollable: true,
                                                    tabs: [
                                                      Tab(
                                                        text: "By Conditions",
                                                      ),
                                                      Tab(
                                                        text: "By Brands",
                                                      )
                                                    ],
                                                  ),
                                                  title: Text("Medicines"),
                                                ),
                                                body: TabBarView(
                                                  children: [
                                                    FutureBuilder<List>(
                                                        future:
                                                            getCategoryList(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<List>
                                                                snapshot) {
                                                          return new ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                snapshot.data ==
                                                                        null
                                                                    ? 0
                                                                    : snapshot
                                                                        .data
                                                                        .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              if (snapshot
                                                                  .data.isEmpty)
                                                                return Text(
                                                                    "Please wait");
                                                              else
                                                                return ListTile(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>Scaffold(
                                                                              appBar: AppBar(backgroundColor: primaryColor,title:Text( snapshot.data[index]),),
                                                                              body: FutureBuilder<List<ProductModel>>(
                                                                                  future: getproductsFromConditions(snapshot.data[index]),
                                                                                  builder:
                                                                                      (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot2) {
                                                                                    return new GridView.builder(
                                                                                      gridDelegate:
                                                                                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                                                                      shrinkWrap: true,
                                                                                      itemCount: snapshot2.data == null ? 0 : snapshot2.data.length,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        if (snapshot.data.isEmpty)
                                                                                          return Text("Please wait");
                                                                                        else
                                                                                          return Center(
                                                                                            child: Container(
                                                                                              width: double.infinity,
                                                                                              height: double.infinity,
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(0),
                                                                                                child: Card(
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Image.network(
                                                                                                        PHOTO_BASE_PHARMACY +
                                                                                                            snapshot2.data[index].img +
                                                                                                            ".jpg",
                                                                                                        height: 130,
                                                                                                        width: 150,
                                                                                                      ),
                                                                                                      Text(snapshot2.data[index].name)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                      },
                                                                                    );
                                                                                  }),
                                                                            )));
                                                                  },
                                                                  title: Text(
                                                                      snapshot.data[
                                                                          index]),
                                                                  leading: Icon(
                                                                      Icons
                                                                          .label_important_sharp),
                                                                );
                                                            },
                                                          );
                                                        }),
                                                    FutureBuilder<List>(
                                                        future: getBrands(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<List>
                                                                snapshot) {
                                                          return new ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                snapshot.data ==
                                                                        null
                                                                    ? 0
                                                                    : snapshot
                                                                        .data
                                                                        .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              if (snapshot
                                                                  .data.isEmpty)
                                                                return Text(
                                                                    "Please wait");
                                                              else
                                                                return ListTile(
                                                                  onTap: (){
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>Scaffold(
                                                                              appBar: AppBar(backgroundColor :primaryColor,title:Text( snapshot.data[index]),),
                                                                              body: FutureBuilder<List<ProductModel>>(
                                                                                  future: getproductsFromBrand(snapshot.data[index]),
                                                                                  builder:
                                                                                      (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot2) {
                                                                                    return new GridView.builder(
                                                                                      gridDelegate:
                                                                                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                                                                      shrinkWrap: true,
                                                                                      itemCount: snapshot2.data == null ? 0 : snapshot2.data.length,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        if (snapshot.data.isEmpty)
                                                                                          return Text("Please wait");
                                                                                        else
                                                                                          return Center(
                                                                                            child: Container(
                                                                                              width: double.infinity,
                                                                                              height: double.infinity,
                                                                                              child: Padding(
                                                                                                padding: EdgeInsets.all(0),
                                                                                                child: Card(
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Image.network(
                                                                                                        PHOTO_BASE_PHARMACY +
                                                                                                            snapshot2.data[index].img +
                                                                                                            ".jpg",
                                                                                                        height: 130,
                                                                                                        width: 150,
                                                                                                      ),
                                                                                                      Text(snapshot2.data[index].name)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                      },
                                                                                    );
                                                                                  }),
                                                                            )));
                                                                  },
                                                                  title: Text(
                                                                      snapshot.data[
                                                                          index]),
                                                                  leading: Icon(
                                                                      Icons
                                                                          .label_important_sharp),
                                                                );
                                                            },
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Medicines",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Divider(
                            height: 3,
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              //SecondlevelShop
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SecondlevelShop(1, "Personal Care")));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Personal Care",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Divider(
                            height: 3,
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              //SecondlevelShop
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecondlevelShop(
                                          2, "Wellbeing and Fitness")));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Wellbeing and Fitness",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Divider(
                            height: 3,
                            color: Colors.grey,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SecondlevelShop(
                                          3, "Medical Devices")));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Medical Devices",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Upload your prescription"),
                        Text("2. We will collect your prescription"),
                        Text("3. Get medicine delivered at your door step"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Card(
                            color: Colors.red,
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              child: Center(
                                  child: Text(
                                "Upload Prescription",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondlevelShop extends StatefulWidget {
  List<Tab> allTabls = [];
  List<Widget> allVews = [];
  int menu_position = 0;

  List<String> category = [];
  String title;

  SecondlevelShop(this.menu_position, this.title);

  @override
  _SecondlevelShopState createState() => _SecondlevelShopState();
}

class _SecondlevelShopState extends State<SecondlevelShop> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.menu_position == 1) {
      widget.category = [
        "Baby & child health",
        "Eye Care",
        "Foot Care",
        "First aid",
        "Hair loss",
        "Hand Wash & Sanitizers",
        "Men's health",
        "Men's toiletries",
        "Mouth, lips & oral cares",
        "Sexual wellbeing",
        "Skin care",
        "Women's health",
        "Women's toiletries",
        "Skin rejuvenation",
        "Covid"
      ];
    } else if (widget.menu_position == 2) {
      widget.category = [
        "Anti Aging",
        "Baby & child vitamins",
        "Brain supplements",
        "Immune health",
        "Men's health supplements",
        "Hand Wash & Sanitizers",
        "Men's health",
        "Multivitamins",
        "Pregnancy supplements",
        "Skin, Nail & Hair Care",
        "Women's health supplements",
        "Bone & Jointment Care",
      ];
    } else if (widget.menu_position == 3) {
      widget.category = [
        "Blood Pressure Apparatus",
        "Glucose Monitors",
        "Nebulizers",
      ];
    }

    for (int i = 0; i < widget.category.length; i++) {
      widget.allTabls.add(Tab(
        text: widget.category[i],
      ));
    }

    setState(() {
      for (int j = 0; j < widget.category.length; j++) {
        widget.allVews.add(makeTabView(widget.category[j]));
        // widget.allVews.add(Text("OK"));
      }
    });
  }

  Future<List<ProductModel>> getData(String key) async {
    print(key);

    var body = jsonEncode(<String, String>{
      'key': key,
    });

    final http.Response response = await http.post(
        "https://callgpnow.com/api_callgpnow/" + 'all_medicines.php',
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body);
    print(body);
    List<ProductModel> allProducts = [];
    List jsonData = jsonDecode(response.body);
    print("size " + jsonData.length.toString());
    for (int i = 0; i < jsonData.length; i++) {
      allProducts.add(ProductModel.fromJson(jsonData[i]));
    }

    return allProducts;
  }

  Widget makeTabView(String key) {


    //return Text(key);
    return FutureBuilder<List<ProductModel>>(
        future: getData(key),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          return new GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            shrinkWrap: true,
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (snapshot.data.isEmpty)
                return Text("Please wait");
              else
                return Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(
                              PHOTO_BASE_PHARMACY +
                                  snapshot.data[index].img +
                                  ".jpg",
                              height: 130,
                              width: 150,
                            ),
                            Text(snapshot.data[index].name)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 40;
    var _aspectRatio = _width / cellHeight;
    var _aspectRatio2 = _width / 45;
    return Scaffold(
      body: DefaultTabController(
        length: widget.allTabls.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: widget.allTabls,
            ),
            title: Text(widget.title),
          ),
          body: widget.allVews == null
              ? Center(
                  child: Text("Please wait"),
                )
              : TabBarView(
                  children: widget.allVews,
                ),
        ),
      ),
    );
  }
}

class ProductModel {
  String id;
  String name;
  String img;
  String price;
  String category;
  String subcategory;
  String description;

  ProductModel(
      {this.id,
      this.name,
      this.img,
      this.price,
      this.category,
      this.subcategory,
      this.description});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
    price = json['price'];
    category = json['category'];
    subcategory = json['subcategory'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['img'] = this.img;
    data['price'] = this.price;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['description'] = this.description;
    return data;
  }
}
