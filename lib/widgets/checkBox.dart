import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

Widget TitleCheckBox(String title, Function(bool) onChange,
    {bool value = false}) {
  final checked = value.obs;

  return Row(
    children: [
      Obx(() => IconButton(
          onPressed: () {
            onChange(!checked.value);
            checked.value = !checked.value;
          },
          icon: Icon(checked.isTrue
              ? Icons.check_box_outlined
              : Icons.check_box_outline_blank_sharp))),
      GestureDetector(
        child: Text(title),
        onTap: () {
          checked.value = !checked.value;
        },
      )
    ],
  );
}
