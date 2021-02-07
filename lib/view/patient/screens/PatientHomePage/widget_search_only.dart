import 'dart:convert';

import 'package:maulaji/cachedData.dart';
import 'package:maulaji/view/patient/OnlineDoctorsList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DoctorSearchActivityNew extends StatefulWidget {
  List downloadedData = [];
  List showData = [];
  List deptList = null;
  int selectedPosition = -1;

  bool _enabled2 = true;

  @override
  _DoctorSearchActivityNewState createState() =>
      _DoctorSearchActivityNewState();
}

class _DoctorSearchActivityNewState extends State<DoctorSearchActivityNew> {
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

  getDeptListData() async {
    SharedPreferences prefs;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    prefs = await _prefs;
    if (cachedDeptList == null) {
      print("api hit => " + "department-list");
      final http.Response response = await http.post(
        "https://api.callgpnow.com/api/" + 'department-list',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': prefs.getString("auth"),
        },
      );
      setState(() {
        cachedDeptList = json.decode(response.body);
        widget.deptList = json.decode(response.body);
        widget.deptList = widget.deptList.sublist(0, 10);
      });
    } else {
      setState(() {
        print("loaded from cache");
        widget.deptList = cachedDeptList;
        widget.deptList = widget.deptList.sublist(0, 10);
      });
    }

    // data_ = json.decode(response.body);

    // showThisToast("dept size "+response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //this.getData();
  }

  @override
  Widget build(BuildContext context) {
    var _crossAxisSpacing = 8;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 3;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 35;
    var _aspectRatio = _width / cellHeight;
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          Container(
            height: 250,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(15),
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
                              Text("Speciality or doctor"),
                              Text(
                                widget.selectedPosition != -1
                                    ? widget.deptList[widget.selectedPosition]
                                        ["name"]
                                    : "Tap to select speciality or doctor",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                              ),
                              Text("Select Location"),
                              Text(
                                "Tap to pick a location",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChooseDoctorOnline(
                                  (widget.deptList[widget.selectedPosition]["id"]).toString())));
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
          ListTile(
            title: Text("Commonly Searched Specialities",
                style: TextStyle(fontSize: 14)),
            trailing: Text(
              "More Specialities",
              style: TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: FutureBuilder(
                future: getDeptListData(),
                builder: (context, projectSnap) {
                   return widget.deptList!=null? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossAxisCount,
                        childAspectRatio: _aspectRatio),
                    shrinkWrap: true,
                    itemCount:
                    widget.deptList == null ? 0 : widget.deptList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Padding(
                        padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        child: Card(
                          color: widget.selectedPosition == index
                              ? Colors.green
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                widget.selectedPosition = index;
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
                                      widget.deptList[index]["name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: widget.selectedPosition == index
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
                  ):CircularProgressIndicator();
                }),
          )
        ],
      ),
    );
  }
}
