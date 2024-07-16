import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    _checkCameraPermission(onSelected);
  }
}

Future<void> _checkCameraPermission(Function(List<String>) onSelected) async {
  await _attachFromCamera(onSelected);
}

Future<void> _attachFromCamera(Function(List<String>) onSelected) async {
  var res = await ImagePicker().pickImage(source: ImageSource.camera);
  if (res != null) {
    onSelected([res.path]);
  }
}

void _handelAttachImage(
    int key, Function(List<String>) onSelected, bool multi) async {
  if (key == 0) {
    _attachMedia(multi, onSelected);
  } else if (key == 1) {
    _checkCameraPermission(onSelected);
  }
}

Future<void> _attachMedia(bool multi, Function(List<String>) onSelected) async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: multi);
  if (result != null && result.files.isNotEmpty) {
    onSelected(result.files.map((e) => e.path!).toList());
  }
}
