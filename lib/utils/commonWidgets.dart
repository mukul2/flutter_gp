import 'package:custom_rounded_rectangle_border/custom_rounded_rectangle_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Decoration decoration = ShapeDecoration(
  shape: CustomRoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(5),
      topLeft: Radius.circular(5),
      bottomRight: Radius.circular(5),
      topRight: Radius.circular(5),
    ),
    topSide: BorderSide(color: Colors.blue),
    leftSide: BorderSide(color: Colors.blue),
    bottomLeftCornerSide: BorderSide(color: Colors.blue),
    topLeftCornerSide: BorderSide(color: Colors.blue),
    topRightCornerSide: BorderSide(color: Colors.blue),
    rightSide: BorderSide(color: Colors.blue),
    bottomRightCornerSide: BorderSide(color: Colors.blue),
    bottomSide: BorderSide(color: Colors.blue),
  ),
);