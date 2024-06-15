import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Widget buildCircleAvatar(bool uploading, String newAvatar) {
  var _autService = GetIt.I.get<AutService>();
  return  _autService.getUserImage().isNotEmpty || uploading
      ? Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF12E312), width: 2),
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
            border: Border.all(color: Colors.black12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.person,
            color: Colors.blueGrey,
            size: 70,
          ),
        );
}
