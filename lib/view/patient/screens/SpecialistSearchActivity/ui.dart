import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maulaji/view/patient/screens/SimpleDoctorProfileActivity/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";
class DoctorSearchActivity extends StatefulWidget {
  List downloadedData = [];
  List showData = [];

  bool _enabled2 = true;

  @override
  _DoctorSearchActivityState createState() => _DoctorSearchActivityState();
}

class _DoctorSearchActivityState extends State<DoctorSearchActivity> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: TextFormField(
            onChanged: (text) {
              // print("First text field: $text");
              //  showThisToast("First text field: $text");
              if (text
                  .trim()
                  .length > 0) {
                widget.showData.clear();
                for (int i = 0; i < widget.downloadedData.length; i++) {
                  if (widget.downloadedData[i]["name"].toString()
                      .toLowerCase()
                      .contains(text.toLowerCase())) {
                    setState(() {
                      widget.showData.add(widget.downloadedData[i]);
                    });
                  }
                }
              } else {
                setState(() {
                  widget.showData.clear();
                  widget.showData.addAll(widget.downloadedData);
                });
              }
            },
            style: TextStyle(
              color: Color.fromARGB(255, 189, 62, 68),
            ),
            initialValue: "",
            validator: (value) {
              key = value;
              if (value.isEmpty) {
                return 'Please enter Email';
              }
              return null;
            },
            cursorColor: Colors.black,
            decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 234, 234, 234),
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 234, 234, 234), width: 10.0),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234),
                        width: 10.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 234, 234, 234),
                        width: 10.0)),
                focusColor: Color.fromARGB(255, 189, 62, 68),
                labelStyle: TextStyle(color: Colors.black)),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return Container(
                      child: new Wrap(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    " Filters",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                          new ListTile(
                            leading: new Icon(Icons.settings),
                            title: new Text('Setting 1'),
                            onTap: () => {},
                          ),
                          new ListTile(
                            leading: new Icon(Icons.settings),
                            title: new Text('Setting 2'),
                            onTap: () => {},
                          ),
                          new ListTile(
                            leading: new Icon(Icons.settings),
                            title: new Text('Setting 3'),
                            onTap: () => {},
                          ),
                          Center(
                            child: Card(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    "Filter",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          )
                        ],
                      ),
                    );
                  });
            },
            child: Icon(Icons.sort),
          ),
        ),
      ),
      body: widget.showData.length == 0
          ? Container(
        width: double.infinity,
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Center(
          child: Text("Loading"),
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: widget.showData == null
            ? 0
            : widget.showData.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Container(
                child: InkWell(
                    onTap: () {
                      //

                      print(widget.showData[index]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SimpleDocProfileActivity(
                                      widget.showData[index])));
                    },
                    child: ListTile(
                      //  trailing: Text(widget.downloadedData[index]["video_appointment_rate"].toString() + " £"),
                      trailing: Text("Free"),
                      subtitle: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                        child: new Text(
                          widget.showData[index]["department_info"]
                          ["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                        child: new Text(
                          widget.showData[index]["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage((_baseUrl_image +
                            widget.showData[index]["photo"])),
                      ),
                    )),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ])),
          );
        },
      ),
    );
  }
}