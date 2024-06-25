import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';

Widget FilePickerWidget(Rx<String> path) {
  return Obx(() => path.value.isNotEmpty
      ? Column(
    children: [
      if ((lookupMimeType(path.value)?.contains("image") ?? false))
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                fit: BoxFit.cover,
                File(
                  path.value,
                ),
                height: 300,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: attachWidget(path),
            ),
          ],
        )
      else
        Container(
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 4,
              ),
              Text(
                path.value.split("/").last,
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              attachWidget(path)
            ],
          ),
        )
    ],
  )
      : Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton(
        onPressed: () async {
          FilePickerResult? result =
          await FilePicker.platform.pickFiles();
          if (result != null) {
            path.value = result.files.first.path!;
          }
        },
        child: Text("انتخاب فایل")),
  ));
}

Widget attachWidget(Rx<String> path) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(50)),
        child: IconButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              path.value = result.files.first.path!;
            }
          },
          icon: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Icon(
              Icons.attach_file_sharp,
              color: Colors.black,
            ),
          ),
        ),
      ),
      SizedBox(
        width: 16,
      ),
      Container(
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (path.value.isNotEmpty)
              IconButton(
                onPressed: () {
                  path.value = "";
                },
                icon: Container(
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
