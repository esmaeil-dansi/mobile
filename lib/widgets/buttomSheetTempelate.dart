import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/widgets/constant.dart';

Widget bottomSheetTemplate(Widget widget) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: GRADIANT_COLOR),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                10,
              ),
              topLeft: Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    10,
                  ),
                  topLeft: Radius.circular(10))),
          child: widget,
        ),
      ),
    ),
  );
}
