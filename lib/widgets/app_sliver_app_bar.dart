import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';

PreferredSizeWidget appSliverAppBar(String title, {PreferredSizeWidget? bottom}) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
      onPressed: () {
        Get.back();
      },
    ),
    // expandedHeight: 50,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        // LinearGradient
        gradient: LinearGradient(
          // colors for gradient
          colors: GRADIANT_COLOR,
        ),
      ),
    ),
    // title of appbar
    title: Text(
      title,
      style: TextStyle(fontSize: 19),
    ),
    bottom: bottom,
  );
}
