import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';

Widget newFormWidget(Function onTap,
        {String title = "فرم جدید", double width = 100}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap();
        },
        child: Container(
            width: width,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(colors: GRADIANT_COLOR)),
            child: Center(
                child: Text(
              title,
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
            ))),
      ),
    );

Widget submitForm(
  Function onTap,
) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onTap(),
        child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(colors: GRADIANT_COLOR)),
            child: Center(
                child: Text(
              "ثبت",
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
            ))),
      ),
    );
