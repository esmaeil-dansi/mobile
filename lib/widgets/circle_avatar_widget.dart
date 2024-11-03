import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Widget buildCircleAvatar(bool uploading, String newAvatar, Rx<String> avatar) {
  return avatar.isNotEmpty || uploading
      ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: GRADIANT_COLOR),
            // border: Border.all(color: Color(0xFF12E312), width: 2),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: uploading
                    ? Image.file(File(newAvatar)).image
                    : NetworkImage("https://icasp.ir" + avatar.value, headers: {
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

Widget buildShopAvatar(bool uploading, String newAvatar, Rx<String> avatar) {
  return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // borderRadius: BorderRadius.circular(10),
        // border: Border.all(),
        gradient: LinearGradient(colors: GRADIANT_COLOR),
        // shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            // borderRadius: BorderRadius.circular(10),
            // border: Border.all(),
            // shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: (avatar.isNotEmpty || uploading)
                ? Container(
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      // gradient: LinearGradient(colors: GRADIANT_COLOR),
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: uploading
                              ? Image.file(File(newAvatar)).image
                              : NetworkImage("https://icasp.ir" + avatar.value,
                                  headers: {
                                      'cookie': GetIt.I
                                          .get<HttpService>()
                                          .getCookie(),
                                    })),
                    ),
                  )
                : Icon(
                    CupertinoIcons.shopping_cart,
                    color: Colors.blueGrey,
                    size: 60,
                  ),
          ),
        ),
      ));
}

Widget buildCircleAvatarUi({required String avatar, double radius = 30}) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: GRADIANT_COLOR),
      // border: Border.all(color: Color(0xFF12E312), width: 2),
      shape: BoxShape.circle,
      image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage("https://icasp.ir" + avatar, headers: {
            'cookie': GetIt.I.get<HttpService>().getCookie(),
          })),
    ),
  );
}
