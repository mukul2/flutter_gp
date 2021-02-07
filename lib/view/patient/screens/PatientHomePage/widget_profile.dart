import 'package:maulaji/view/patient/patient_view.dart';
import 'package:maulaji/view/patient/screens/PatientBasicProfile/ui.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              //BasicProfileActivity
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BasicProfile()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Basic Information"),
            subtitle: Text("Update name,photo"),
            leading: Image.asset(
              "assets/man_.png",
              width: 30,
              height: 30,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DiseasesWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Disease History"),
            subtitle: Text("Add/View your diseases history"),
            leading: Image.asset(
              "heart_disease.png",
              width: 30,
              height: 30,
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrescriptionsWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Prescriptions"),
            subtitle: Text("Add/View your prescriptions"),
            leading: Image.asset(
              "prescription_.png",
              width: 30,
              height: 30,
            ),
          ),
          Divider(),
          ListTile(
            //
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrescriptionsReviewWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Prescription Review"),
            subtitle: Text("View your prescription request and responses"),
            leading: Image.asset(
              "prescription_.png",
              width: 30,
              height: 30,
            ),
          ),
          Divider(),
          ListTile(
            //
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TestRecomendationWidget()));
            },
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Test Recommendations"),
            subtitle: Text("View your recommended tests from doctors"),
            leading: Image.asset(
              "chemistry.png",
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}