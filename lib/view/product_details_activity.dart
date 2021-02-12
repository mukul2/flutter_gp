
import 'package:maulaji/main.dart';
import 'package:maulaji/models/product_model.dart';
import 'package:maulaji/view/patient/screens/HomeVisitDocListActivity/ui.dart';
import 'package:maulaji/view/patient/screens/PatientHomePage/widget_search_use_case_two.dart';
import 'package:maulaji/view/patient/screens/UrgentCareDocListActivity/ui.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductDetailsPage extends StatefulWidget {
  ProductModel productDetails;
  String cartbutton="Add to Cart";

  ProductDetailsPage(this.productDetails);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(widget.productDetails.category),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(Icons.chevron_right),
                  ),
                  Text(widget.productDetails.subcategory),

                ],
              ),
            ),
            Center(
              child: Image.network( PHOTO_BASE_PHARMACY +
                  widget.productDetails.img +
                  ".jpg" ,height: 200,width: 200,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.productDetails.name,style: TextStyle(fontSize: 20,color:Colors.red),),
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Card(
                    color: Colors.red,
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Price : "+widget.productDetails.price,style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Card(
                    color: Colors.red,
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.cartbutton,style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
