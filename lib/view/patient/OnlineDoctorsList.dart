import 'package:maulaji/networking/ApiProvider.dart';
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
import 'package:maulaji/view/patient/screens/SimpleDoctorProfileActivity/ui.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'dart:convert';
import 'OnlineDoctorFullProfileView.dart';
import '../login_view.dart';
import 'package:http/http.dart' as http;
String AUTH_KEY;

final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://callgpnow.com/public/";
class OnlineDoctorList extends StatefulWidget {
  String selectedCategory;

  OnlineDoctorList(this.selectedCategory);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<OnlineDoctorList> {

  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "https://api.callgpnow.com/api/" + 'search-online-doctors',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'department_id': widget.selectedCategory}),


    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data);

    return "Success!";
  }

  @override
  void initState() async{
    this.getData();
    Future<SharedPreferences> _prefs =
    SharedPreferences.getInstance();
    SharedPreferences prefs;
    prefs = await _prefs;
    AUTH_KEY =  prefs.getString("auth");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Doctors"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      OnlineDoctorFullProfileView(
                          data[index]["id"], data[index]["name"],
                          data[index]["photo"],
                          data[index]["designation_title"],
                          data[index]["online_doctors_service_info"])));
            },
            child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(data[index]["designation_title"],
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                  child: new Text(data[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                leading: Image.network(
                    _baseUrl_image +
                        data[index]["img_url"], fit: BoxFit.fill),

              ),
            ),
          );
        },
      ),
    );
  }
}

List data_;





class ChooseDoctorOnline extends StatefulWidget {


  var currentPageValue = 0.0;
  bool isSearching = true ;
  String id;
  List downloadedData = [];
  bool _enabled2 = true;
  ChooseDoctorOnline(this.id);
  @override
  _ChooseDoctorChamberState createState() => _ChooseDoctorChamberState();
}

class _ChooseDoctorChamberState extends State<ChooseDoctorOnline> {
  PageController _controller = PageController(
    initialPage: 0, viewportFraction: 0.8
  );
  Future<List> getData(String id) async {

    final http.Response response = await http.get(
      "https://callmygp.herokuapp.com/specialist_doctor?id="+id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',

        'Authorization': AUTH_KEY,
      },

    );
    print(response.body);

    setState(() {
      widget.downloadedData = json.decode(response.body);
      widget.isSearching = false ;

    });

    // showThisToast(response.body.toString());
    //showThisToast(downloadedData.length.toString());

    return data_;
  }
  @override
  void initState() {
    // TODO: implement initState
    print(widget.id);
    this.getData(widget.id);
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
                      child: Text("Top Specialist",style: TextStyle(fontSize: 20,color: Colors.white),),
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

              //  convert this
                child: widget.isSearching?Center(child: CircularProgressIndicator(),) : widget. downloadedData==0? Center(child: Text("No Result fount"),): (GridView.builder(
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
                                    SimpleDocProfileActivity(
                                        widget.downloadedData[index])));


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

//
//class OnlineDoctorListWidget extends StatefulWidget {
//  String id ;
//  OnlineDoctorListWidget(this.id);
//  @override
//  _OnlineDoctorListWidgetState createState() => _OnlineDoctorListWidgetState();
//}
//
//class _OnlineDoctorListWidgetState extends State<OnlineDoctorListWidget> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Select a Doctor O"),
//      ),
//      body: FutureBuilder(
//          future: getData(id),
//          builder: (context, projectSnap) {
//            return(data_==null) ? Container(
//              width: double.infinity,
//              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//              child: Column(
//                mainAxisSize: MainAxisSize.max,
//                children: <Widget>[
//                  Expanded(
//                    child: Shimmer.fromColors(
//                      baseColor: Colors.grey[300],
//                      highlightColor: Colors.grey[100],
//                      enabled: _enabled2,
//                      child: ListView.builder(
//                        itemBuilder: (_, __) => Padding(
//                          padding: const EdgeInsets.only(bottom: 8.0),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              Container(
//                                width: 48.0,
//                                height: 48.0,
//                                color: Colors.white,
//                              ),
//                              const Padding(
//                                padding: EdgeInsets.symmetric(horizontal: 8.0),
//                              ),
//                              Expanded(
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    Container(
//                                      width: 200,
//                                      height: 8.0,
//                                      color: Colors.white,
//                                    ),
//                                    const Padding(
//                                      padding: EdgeInsets.symmetric(vertical: 2.0),
//                                    ),
//                                    Container(
//                                      width: double.infinity,
//                                      height: 8.0,
//                                      color: Colors.white,
//                                    ),
//                                    const Padding(
//                                      padding: EdgeInsets.symmetric(vertical: 2.0),
//                                    ),
//                                    Container(
//                                      width: 40.0,
//                                      height: 8.0,
//                                      color: Colors.white,
//                                    ),
//                                  ],
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                        itemCount: 6,
//                      ),
//                    ),
//                  ),
//
//                ],
//              ),
//            ):new ListView.builder(
//              itemCount: projectSnap.data == null ? 0 : projectSnap.data.length,
//              itemBuilder: (BuildContext context, int index) {
//                return new InkWell(
//                  onTap: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) =>
//                            OnlineDoctorFullProfileView(
//                                projectSnap.data[index]["id"], projectSnap.data[index]["name"],
//                                projectSnap.data[index]["photo"],
//                                projectSnap.data[index]["designation_title"],
//                                projectSnap.data[index]["online_doctors_service_info"])));
//                  },
//                  child: Card(
//
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(00.0),
//                    ),
//                    child: ListTile(
//                      subtitle: Padding(
//                        padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
//                        child: new Text(projectSnap.data[index]["designation_title"],
//                          style: TextStyle(fontWeight: FontWeight.bold),),
//                      ),
//                      title: Padding(
//                        padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
//                        child: new Text(projectSnap.data[index]["name"],
//                          style: TextStyle(fontWeight: FontWeight.bold),),
//                      ),
//                      leading: CircleAvatar(
//                        backgroundImage: NetworkImage(("https://api.callgpnow.com/" +
//                            projectSnap.data[index]["photo"])),
//                      ),
//
//                    ),
//                  ),
//                );
//              },
//            );
//          }
//      ),
//    );
//  }
//}



