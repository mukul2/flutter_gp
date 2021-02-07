import 'dart:convert';

import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/view/patient/screens/HomeVisitRequestActivity/ui.dart';
import 'package:maulaji/view/patient/screens/UrgentVisitRequestActivity/ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maulaji/view/patient/screens/SimpleDoctorProfileActivity/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";

Color primaryColor = Colors.red;
class HomeVisitDocSearchActivity extends StatefulWidget {


  var currentPageValue = 0.0;
  bool isSearching = true ;
  String id;
  List downloadedData ;
  bool _enabled2 = true;
  bool isLoading = true ;
  HomeVisitDocSearchActivity();
  @override
  _ChooseDoctorChamberState createState() => _ChooseDoctorChamberState();
}

class _ChooseDoctorChamberState extends State<HomeVisitDocSearchActivity> {
  PageController _controller = PageController(
      initialPage: 0, viewportFraction: 0.8
  );
  Future<List> getData(String id) async {

  }
  @override
  void initState() {
    // TODO: implement initState
    print(widget.id);
    getHomeVIsitDocList().then((value) => {

      this.setState(() {
        print(value);
        widget.downloadedData = [];
        widget.downloadedData.addAll(value);
        print(widget.downloadedData.length.toString());
        widget.isLoading = false ;
      })

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
                      child: Text("Home Visit Available Doctors",style: TextStyle(fontSize: 20,color: Colors.white),),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),

              color: Colors.white,
              child: Container(
                height: double.infinity,

                //  convert this
                child: widget.isLoading?Center(child: CircularProgressIndicator(),) : widget. downloadedData==0? Center(child: Text("No Result fount"),): (GridView.builder(
                  gridDelegate:new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),

                  shrinkWrap: true,
                  itemCount: widget. downloadedData== null ? 0 : widget.downloadedData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new InkWell(
                      onTap: () {



                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeVisitRequestActivity(
                                        widget.downloadedData[index]["id"])));




                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                        child: Card(

                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.network("https://callgpnow.com/public/"+ widget. downloadedData[index]["img_url"].toString()),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(

                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [Colors.black, Colors.black45,Colors.black12,Colors.transparent]))
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    shrinkWrap: true,

                                    children: [
                                      Text(
                                        widget. downloadedData[index]["name"],
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                                      ),

                                      Text(
                                        widget. downloadedData[index]["department"]!=null?widget.downloadedData[index]["department"]:"No Designation data",
                                        style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget. downloadedData[index]["address"],
                                        style: TextStyle(color: Colors.white,fontSize: 13,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                          ),
                        ),
                      ),
                    );
                  },
                )),
              ),
            ),
          )
        ],
      ),



/*

      body: widget.downloadedData.length==0 ?Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: widget._enabled2,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 200,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 6,
                ),
              ),
            ),

          ],
        ),
      ): ListView.builder(
        itemCount:
        widget. downloadedData== null ? 0 : widget.downloadedData.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {

              /*
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      OnlineDoctorFullProfileView(
                          downloadedData[index]["id"],downloadedData[index]["name"],
                          downloadedData[index]["photo"],
                          downloadedData[index]["designation_title"],
                          downloadedData[index]["online_doctors_service_info"])));


               */

              print(widget.downloadedData[index]);
              print( widget.downloadedData[index]["name"]);
              print( widget.downloadedData[index]["photo"]);
              print( widget.downloadedData[index]["depatment_info"]);
              print( widget.downloadedData[index]["depatment_title"]);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SimpleDocProfileActivity(
                              widget.downloadedData[index])));


            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(
                    widget. downloadedData[index]["department"]!=null?widget.downloadedData[index]["department"]:"No Designation data"
                    ,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                  child: new Text(
                    widget. downloadedData[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                leading:new Image.network("https://callgpnow.com/public/"+ widget. downloadedData[index]["img_url"].toString())
              ),
            ),
          );
        },
      ),
      */


    );
  }
}