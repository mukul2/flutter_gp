import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/view/patient/screens/Pharmacey/horizontal_category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

PageController _controller =
    PageController(initialPage: 1, viewportFraction: 0.8);
//
Widget sliderAndOtherWidgets(BuildContext context) {
  int total = 3;
  int current = 0;

  Timer.periodic(new Duration(seconds: 5), (timer) {
    debugPrint(timer.tick.toString());
    double total_width = _controller.position.maxScrollExtent + 320;
    double one_width = total_width / 4;
    _controller.animateTo(
      one_width * current,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 1000),
    );
    current++;
    if (current > total) {
      current = 0;
    }
  });
  return Column(
    children: <Widget>[
      Container(
        height: 150,
        child: PageView(
          controller: _controller,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
              child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Container(
                    child: Center(
                      child: Image.asset(
                        "assets/banner1.png",
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Container(
                    child: Center(
                      child: Image.asset(
                        "assets/banner2.png",
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(0),
              child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Container(
                    child: Center(
                      child: Image.asset(
                        "assets/banner3.png",
                        fit: BoxFit.cover,
                        height: 150,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          File image = await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 500,maxWidth: 500);
          //work here uplaod prescription
          List<File> fileList = [image];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChoosePrescriptionsDocument(fileList)));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            color: Colors.blue,
            child: Center(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Upload a Prescription",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: horizontal_list(),
      ),
    ],
  );
}

// start
class ChoosePrescriptionsDocument extends StatefulWidget {
  Function function;
  List<File> fileList = [];

  //ChooseDeptActivity(this.deptList__, this.function);
  ChoosePrescriptionsDocument(this.fileList, {Key key, this.function})
      : super(key: key);

  @override
  _ChooseDocumentState createState() => _ChooseDocumentState();
}

class _ChooseDocumentState extends State<ChoosePrescriptionsDocument> {
  @override
  void initState() {
    // TODO: implement initState
    //  this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add at least 1 Document"),
        actions: [
          GestureDetector(
              onTap: () {
                //widget.function(widget.fileList);
                // Navigator.of(context).pop(true);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SubmitPrescriptionRequestWithPhoto(
                                widget.fileList)));
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            File image = await FilePicker.getFile();
//        final Map<String, File> data =
//        new Map<String, File>();
//        data['link'] = image;
            setState(() {
              widget.fileList.add(image);
            });
          },
          label: Text("Pick from Device")),
      body: true
          ? ListView.builder(
              itemCount: widget.fileList == null ? 0 : widget.fileList.length,
              itemBuilder: (BuildContext context, int index) {
                return new InkWell(
                    onTap: () {
                      // widget.function(data);
                      // Navigator.of(context).pop(true);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          trailing: InkWell(
                            onTap: () {
                              setState(() {
                                widget.fileList.removeAt(index);
                              });
                            },
                            child: Icon(Icons.delete),
                          ),
                          leading:
                              Image.file(File(widget.fileList[index].path)),
                          title: new Text(
                            (widget.fileList[index].path).split('/').last,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ));
              },
            )
          : Center(
              child: Text(widget.fileList.toString()),
            ),
    );
  }
}
//ends

// start
class SubmitPrescriptionRequestWithPhoto extends StatefulWidget {
  Function function;
  List<File> fileList = [];
  String shippinaddress;
  String billingaddress;
  TextEditingController controler;

  bool showProgressbar = false ;

  int activeWidgetIndex = 0;

  //ChooseDeptActivity(this.deptList__, this.function);
  SubmitPrescriptionRequestWithPhoto(this.fileList, {Key key, this.function})
      : super(key: key);

  @override
  _SubmitPrescriptionRequestWithPhotoState createState() =>
      _SubmitPrescriptionRequestWithPhotoState();
}

class _SubmitPrescriptionRequestWithPhotoState
    extends State<SubmitPrescriptionRequestWithPhoto> {
  final _focusNode_1 = FocusNode();
  final _focusNode_2 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    //  this.getData();
    setState(() {
      widget.controler = new TextEditingController();
    });
    _focusNode_1.addListener(() {
      if (_focusNode_1.hasFocus) {
        setState(() {
          widget.activeWidgetIndex = 0;
        });
      } else {
        setState(() {
          widget.activeWidgetIndex = 1;
        });
      }
    });
    _focusNode_2.addListener(() {
      if (_focusNode_2.hasFocus) {
        setState(() {
          widget.activeWidgetIndex = 1;
        });
      } else {
        setState(() {
          widget.activeWidgetIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
        actions: [
          /*
          GestureDetector(
              onTap: () {
                widget.function(widget.fileList);
                Navigator.of(context).pop(true);



              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ))

           */
        ],
      ),
      body:widget.showProgressbar?Center(child: CircularProgressIndicator(),): SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
              child: Text(
                "Shipping Address",
                style: TextStyle(
                    fontSize: 16,
                    color: widget.activeWidgetIndex == 0
                        ? Colors.blue
                        : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: _focusNode_1,
                // controller: widget.controler,
                onChanged: (text) {
                  setState(() {
                    widget.shippinaddress = text;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
              child: Text(
                "Billing Address",
                style: TextStyle(
                    fontSize: 16,
                    color: widget.activeWidgetIndex == 1
                        ? Colors.blue
                        : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: _focusNode_2,
                //controller: widget.controler,
                onChanged: (text) {
                  setState(() {
                    widget.billingaddress = text;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async{
                    setState(() {
                      widget.showProgressbar = true ;
                    });

                    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                    SharedPreferences  prefs = await _prefs;
                    List<int> imageBytes = widget.fileList[0].readAsBytesSync();
                    print(imageBytes);
                    String base64Image = base64Encode(imageBytes);
                    print("customner id "+prefs.getString("uid"));
                    submitPrescriptionPhotorequest(prefs.getString("uid"),prefs.getString("uphoto"),"00","0","0",widget.shippinaddress,base64Image).then((value) {
                      print(value);
                      setState(() {
                        widget.showProgressbar = false ;
                      });
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);

                      showThisToast("Prescription Request is received Successfully");

                    });
                  },
                  color: Colors.orange,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//ends
void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}