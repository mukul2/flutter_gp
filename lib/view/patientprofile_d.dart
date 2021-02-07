
import 'dart:convert';

import 'package:flutter/material.dart';

import '../RawApi.dart';

class PatientProfileViewForDoctor extends StatefulWidget {
  dynamic appointmentInfo ;
  PatientProfileViewForDoctor(this.appointmentInfo);
  @override
  _PatientProfileViewForDoctorState createState() => _PatientProfileViewForDoctorState();
}

class _PatientProfileViewForDoctorState extends State<PatientProfileViewForDoctor> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Appointment Info",),
              Tab(text: "Prescriptions",),
              Tab(text: "Lab Reports",),
              Tab(text: "Documents",),

            ],
          ),
          title: Text(widget.appointmentInfo["patientname"]),
        ),
        body: TabBarView(
          children: [
           Padding(
             padding: const EdgeInsets.all(5.0),
             child: SingleChildScrollView(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   ListTile(title: Text(widget.appointmentInfo["patientname"]),subtitle: Text("Patient Name")),
                   ListTile(title: Text(widget.appointmentInfo["sex"]),subtitle: Text("Gender")),
                   ListTile(title: Text(widget.appointmentInfo["birthdate"]),subtitle: Text("Birth Date")),
                   ListTile(title: Text(widget.appointmentInfo["phone"]),subtitle: Text("Phone")),
                   ListTile(title: Text(widget.appointmentInfo["time_slot"]),subtitle: Text("Appointment Time")),
                   ListTile(title: Text(widget.appointmentInfo["bloodgroup"]),subtitle: Text("Blood group")),
                   ListTile(title: Text(widget.appointmentInfo["address"]),subtitle: Text("Address")),
                   ListTile(title: Text(widget.appointmentInfo["reason"]),subtitle: Text("Reason For Visit")),


                 ],
               ),
             ),
           ),
            FutureBuilder(
                future: get_prescriptions(targetuser:widget.appointmentInfo["patient"] ),
                builder: (context, projectSnap) {
                  return projectSnap.data != null
                      ? ListView.builder(

                    shrinkWrap: true,
                    itemCount: projectSnap.data == null ? 0 :projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: (){
                          List prescriptions = [] ;
                          if(projectSnap.data[index]["medicine_list"]!=null && projectSnap.data[index]["medicine_list"].toString().length>3){

                            // dynamic raw  = jsonEncode(projectSnap.data[index]["medicine_list"].toString());

                           //  prescriptions = jsonDecode("[{"medName":"Roxvita Soft",");
                          }else{

                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Scaffold(
                                        appBar: AppBar(title: Text("Prescription Details"),),
                                        body:SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title: Text(projectSnap.data[index]["doctorname"]),
                                                subtitle:Text(projectSnap.data[index]["doctorinfo"]!=null?projectSnap.data[index]["doctorinfo"]:"No Info about doctor"),
                                              ),
                                              ListTile(
                                               title: Text(projectSnap.data[index]["advice"]),
                                               subtitle:Text("Advice") ,
                                             ),
                                              ListTile(
                                               title: Text(projectSnap.data[index]["note"]),
                                               subtitle:Text("Note") ,
                                             ),
                                              ListTile(
                                               title: Text(projectSnap.data[index]["advice"]),
                                               subtitle:Text("Advice") ,
                                             ),
                                              ListTile(
                                               title: Text(projectSnap.data[index]["advice"]),
                                               subtitle:Text("Advice") ,
                                             ),
                                              ListTile(
                                               title: Text(projectSnap.data[index]["medicine_list"][0]["medName"]),
                                               subtitle:Text("pres") ,
                                             ),
                                              projectSnap.data[index]["medicine_list"]!=null?
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: projectSnap.data[index]["medicine_list"] == null ? 0 : projectSnap.data[index]["medicine_list"].length,

                                                itemBuilder: (BuildContext context, int index) {
                                                  return new InkWell(
                                                      onTap: (){

                                                      },
                                                      child: Card(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(00.0),
                                                        ),
                                                        child: ListTile(
                                                          title: Padding(
                                                            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                                            child: new Text(projectSnap.data[index]["medicine_list"]["medName"].toString(),
                                                              style: TextStyle(fontWeight: FontWeight.bold),),
                                                          ),

                                                        ),
                                                      ));
                                                },
                                              ):Center(child: Text("No Medicines"),)
                                            ],
                                          ),
                                        ),
                                      )));
                        },
                        trailing: Icon(Icons.chevron_right),
                        subtitle: Text(projectSnap.data[index]["date"],),
                        title: Text(projectSnap.data[index]["doctorname"],),
                      );
                    },
                  )
                      : Center(child: CircularProgressIndicator());
                }),
            Icon(Icons.directions_bike),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
