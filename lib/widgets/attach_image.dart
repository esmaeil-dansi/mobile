import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

void showSelectImageBottomSheet(Function(List<String>) onSelected,
    {bool multi = false, bool selectFromGallery = false}) async {
  if (selectFromGallery) {
    Get.bottomSheet(Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () {
                  Get.back();
                  _handelAttachImage(1, onSelected, multi);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.camera, size: 25),
                    Text(
                      "دوربین".tr,
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                )),
            TextButton(
                onPressed: () {
                  Get.back();
                  _handelAttachImage(0, onSelected, multi);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.image,
                      size: 25,
                    ),
                    Text(
                      "گالری".tr,
                      style: const TextStyle(color: Colors.black),
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  } else {
    var res = await ImagePicker().pickImage(source: ImageSource.camera);
    if (res != null) {
      onSelected([res.path]);
    }
  }
}

void _handelAttachImage(
    int key, Function(List<String>) onSelected, bool multi) async {
  if (key == 0) {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: multi);
    if (result != null && result.files.isNotEmpty) {
      onSelected(result.files.map((e) => e.path!).toList());
    }
  } else if (key == 1) {
    var res = await ImagePicker().pickImage(source: ImageSource.camera);
    if (res != null) {
      onSelected([res.path]);
    }
  }
}
