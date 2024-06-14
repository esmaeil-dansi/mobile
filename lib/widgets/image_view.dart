import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/widgets/attach_image.dart';
import 'package:get/get.dart';

Widget ImageView(Rx<String> path, String title) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelText: title,
        labelStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      child: Obx(() => path.isEmpty
          ? ElevatedButton(
              onPressed: () {
                showSelectImageBottomSheet((_) {
                  if (_.isNotEmpty) {
                    path.value = _.first;
                  }
                });
              },
              child: Text("الحاق عکس"))
          : Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.file(
                    File(
                      path.value,
                    ),
                    height: 350,
                    width: Get.width,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {
                        showSelectImageBottomSheet((_) {
                          if (_.isNotEmpty) {
                            path.value = _.first;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            )),
    ),
  );
}
