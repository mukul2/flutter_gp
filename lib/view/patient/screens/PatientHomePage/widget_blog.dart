import 'dart:convert';

import 'package:maulaji/view/doctor/myYoutubePlayer.dart';
import 'package:maulaji/view/patient/patient_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final String _baseUrl = "https://api.callgpnow.com/api/";
final String _baseUrl_image = "https://api.callgpnow.com/";
class BlogActivityWithState extends StatefulWidget {
  @override
  _BlogActivityWithStateState createState() => _BlogActivityWithStateState();
}

class _BlogActivityWithStateState extends State<BlogActivityWithState> {
  List blogCategoryList = [];
  List blogList = [];
  int _value = 0;

  Future<String> getData() async {

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    final http.Response response = await http.post(
      _baseUrl + 'allBlogCategory',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("uid"),
      },
    );
    this.setState(() {
      blogCategoryList = json.decode(response.body);
      getBlogs();
    });
    return "Success!";
  }

  Future<String> getBlogs() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    // showThisToast("Hit to download blogs " + (blogCategoryList[_value]["id"]).toString());
    final http.Response response = await http.post(
      _baseUrl + 'all-blog-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': prefs.getString("uid"),
      },
      body: jsonEncode(<String, String>{
        'blog_category': (blogCategoryList[_value]["id"]).toString()
      }),
    );
    this.setState(() {
      blogList = json.decode(response.body);
      // showThisToast("blog size " + (blogList.length).toString());
    });
    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: (blogCategoryList.length > 0)
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount:
            blogCategoryList == null ? 0 : blogCategoryList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                child: InkWell(
                    onTap: () async {
                      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                      SharedPreferences prefs = await _prefs;
                      setState(() {
                        _value = index;
                      });
                      final http.Response response = await http.post(
                        _baseUrl + 'all-blog-info',
                        headers: <String, String>{
                          'Content-Type':
                          'application/json; charset=UTF-8',
                          'Authorization': prefs.getString("auth"),
                        },
                        body: jsonEncode(<String, String>{
                          'blog_category':
                          (blogCategoryList[_value]["id"]).toString()
                        }),
                      );
                      this.setState(() {
                        blogList = json.decode(response.body);
                        //    showThisToast("blog size " + (blogList.length).toString());
                      });
                    },
                    child: _value == index
                        ? Card(
                      color: Color(0xFF34448c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Center(
                            child: Text(
                              blogCategoryList[index]["name"],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Center(
                            child: Text(
                              blogCategoryList[index]["name"],
                              style: TextStyle(
                                  color: Color(0xFF34448c)),
                            ),
                          ),
                        ),
                      ),
                    )),
              );
            },
          )
              : Text("No Category"),
        ),
        (blogList.length > 0)
            ? ListView.builder(
          shrinkWrap: true,
          itemCount: blogList == null ? 0 : blogList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 300,
              child: InkWell(
                  onTap: () {
                    LinkToPlay =
                        (blogList[index]["youtube_video"].toString())
                            .replaceAll("https://youtu.be/", "");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BlogDetailsWidget(blogList[index])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (_baseUrl_image +
                                      (blogList[index]["dr_info"]
                                      ["photo"])
                                          .toString())),
                            ),
                            title: new Text(
                              blogList[index]["title"],
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: new Text(
                              (blogList[index]["dr_info"]["name"])
                                  .toString(),
                              style:
                              TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          new Expanded(
                            child: new Image.network(
                              (_baseUrl_image +
                                  (blogList[index]["photo_info"][0]
                                  ["photo"])
                                      .toString()),
                              fit: BoxFit.fitWidth,
                              height: 250,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          },
        )
            : Container(
          height: 200,
          child: Center(
            child: Text("No Blog Post"),
          ),
        )
      ],
    );
  }
}