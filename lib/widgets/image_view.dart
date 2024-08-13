import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/widgets/attach_image.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Widget ImageView(Rx<String> path, String title,
    {String? defaultValue,
    bool canReplace = true,
    double labelFontSize = 20,
    bool isNetWorkImage = false}) {
  if (defaultValue != null) {
    path.value = defaultValue;
  }
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelText: title,
        labelStyle:
            TextStyle(fontSize: labelFontSize, fontWeight: FontWeight.bold),
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: GRADIANT_COLOR)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: isNetWorkImage
                          ? Image.network("https://icasp.ir" + path.value,
                              headers: {
                                  'cookie':
                                      GetIt.I.get<HttpService>().getCookie(),
                                })
                          : Image.file(
                              File(
                                path.value,
                              ),
                              height: 400,
                              fit: BoxFit.fill,
                              width: Get.width,
                            ),
                    ),
                  ),
                ),
                if (canReplace)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 2),
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
                    ),
                  )
              ],
            )),
    ),
  );
}
