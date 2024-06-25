import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Widget buildCircleAvatar(bool uploading, String newAvatar) {
  var _autService = GetIt.I.get<AutService>();
  return _autService.getUserImage().isNotEmpty || uploading
      ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: GRADIANT_COLOR),
            // border: Border.all(color: Color(0xFF12E312), width: 2),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: uploading
                    ? Image.file(File(newAvatar)).image
                    : NetworkImage(
                        "https://icasp.ir" + _autService.getUserImage().value,
                        headers: {
                            'cookie': GetIt.I.get<HttpService>().getCookie(),
                          })),
          ),
        )
      : Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(),
            gradient: LinearGradient(colors: GRADIANT_COLOR),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.person,
                color: Colors.blueGrey,
                size: 70,
              ),
            ),
          ),
        );
}
