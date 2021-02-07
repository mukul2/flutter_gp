import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<List>  getData() async {
  //https://pharmacy.callgpnow.com/categorylist-by-parent?id=0
  final http.Response response = await http.get(
    "https://pharmacy.callgpnow.com/categorylist-by-parent?id=0",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
    );
  if(response.statusCode == 200) return jsonDecode(response.body);
}

Widget horizontal_list() {
  return FutureBuilder(
    future: getData(),
    builder: (context, snapsot) {
      return snapsot.data==null?Center(child: CircularProgressIndicator(),): Container(
        height: 130,
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: snapsot.data.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              width: 100,
              child: Column(
                children: [
                  CircleAvatar(backgroundColor: Colors.orange,child: Icon(Icons.stream,color: Colors.white,),),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(00, 15, 0, 0),
                    child: Center(child: Text(snapsot.data[index]["category_name"].toString().replaceAll(" ",' ', ),textAlign: TextAlign.center,style: TextStyle(fontSize: 12),)),
                  )
                ],

              ),
            ),
          ),
        ),
      );

      },
  );
}
