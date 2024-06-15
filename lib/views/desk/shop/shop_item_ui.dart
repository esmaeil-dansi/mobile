import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget shopItemUi(
    {required String title,
    required String asset,
    String price = "",
    double? width,
    double? height}) {
  width = width ?? Get.width / 2;
  height = height ?? Get.height * 0.20;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      decoration: BoxDecoration(
        // color: Get.theme.focusColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black12,
          //   blurRadius: 4,
          //   // offset: Offset(4, 8), // Shadow position
          // ),
        ],
      ),
      width: width,
      height: height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                asset,
                width: width * 0.9,
                height: height * 0.7 * 0.7,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
            ),
            if (price.isNotEmpty) Text("میانگین قیمت:" + "\t" + price)
          ],
        ),
      ),
    ),
  );
}
