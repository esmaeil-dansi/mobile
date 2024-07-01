import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void handleDioError(DioException e, {bool showInfo = true}) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout) {
    showDialog(
        context: Get.context!,
        builder: (c) {
          return AlertDialog(
            title: Text(
              "شبکه خود را بررسی کنید",
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            content: showInfo
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.greenAccent)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "درخواست شما ذخیره شد بعد از برقراری ارتباط با مراجعه به صفحه درخواست ها، می توانید درخواست خود دوباره ارسال کنید.",
                        style: TextStyle(fontSize: 17),
                      ),
                    ))
                : null,
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    FocusScope.of(c).unfocus();
                    Navigator.pop(c);
                  },
                  child: Text(
                    "فهمیدم",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  } else {
    var msg = e.response?.data["_server_messages"];
    showErrorMessage(msg);
  }
}

void showErrorMessage(dynamic msg) {
  if (msg != null) {
    msg = jsonDecode(
        jsonDecode(utf8.decode(msg.toString().codeUnits)).toString());
    var message = msg as List<dynamic>;
    List<String> errors = [];
    for (var m in message) {
      String t = m["message"].toString();
      if (t.contains("Error: Value missing for")) {
        t = t.replaceAll("Error: Value missing for", "");
        t = t.replaceAll("</>", "");
        t = t.replaceAll("<", "");
        t = t.replaceAll("/", "");
        t = t.replaceAll(">", "");
        t = t.replaceAll("strong", "");
        t = t + " " + "وارد نشده است";
      }
      errors.add(t);
    }
    if (errors.isNotEmpty) {
      showDialog(
          context: Get.context!,
          builder: (c) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "خطا",
                  style: TextStyle(fontSize: 19, color: Colors.red),
                ),
              ),
              content: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                height: Get.height / 2,
                width: Get.width * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: errors.length,
                      itemBuilder: (c, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(errors[i]),
                        );
                      }),
                ),
              ),
              actions: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.pop(c);
                    },
                    child: Text(
                      "بستن",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ],
            );
          });
    } else {
      showErrorToast(null);
    }
  } else {
    showErrorToast(null);
  }
}

showErrorToast(String? msg) {
  Fluttertoast.showToast(
      msg: msg ?? "خطایی رخ داده است", toastLength: Toast.LENGTH_LONG);
}
