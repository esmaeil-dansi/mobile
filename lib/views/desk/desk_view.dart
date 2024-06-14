import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/views/desk/home_view.dart';
import 'package:frappe_app/views/desk/profile_page.dart';
import 'package:frappe_app/views/desk/request_page.dart';

import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';


class DesktopView extends StatefulWidget {
  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  var index = 0.obs;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        appBar: index == 2||index==0
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                title: Text(
                  "چوپو",
                  style: TextStyle(
                      fontSize: 24,
                      color: MAIN_COLOR,
                      fontWeight: FontWeight.bold),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index.value,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              activeIcon: Icon(
                Icons.home,
                size: 34,
              ),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.arrow_right_arrow_left_square,
                size: 30,
              ),
              activeIcon: Icon(
                CupertinoIcons.arrow_right_arrow_left_square,
                size: 34,
              ),
              label: 'درخواست ها',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline_rounded,
                size: 30,
              ),
              activeIcon: Icon(
                Icons.person_rounded,
                size: 34,
              ),
              label: 'پروفایل من',
            ),
          ],
          onTap: (_) {
            index.value = _;
          },
        ),
        body: Container(
            color: Colors.white,
            child: Obx(() => index.value == 0
                ? HomeView()
                : index.value == 1
                    ? RequestPage()
                    : ProfilePage())),
      ),
    );
  }
}
