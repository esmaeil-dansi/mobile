import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/home_view.dart';
import 'package:frappe_app/views/desk/profile_page.dart';
import 'package:frappe_app/views/desk/request_page.dart';
import 'package:frappe_app/views/desk/shop/my_shop_page.dart';
import 'package:get_it/get_it.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';

class DesktopView extends StatefulWidget {
  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  var index = 0.obs;

  var unselectSize = 28.0;
  var selectedSize = 28.0;

  var _autService = GetIt.I.get<AutService>();

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        appBar: index != 1
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
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(color: Colors.black),
          currentIndex: index.value,
          // selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: Colors.black,

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _unSelectedIcon(Icons.home),
              activeIcon: _selectedIcon(Icons.home),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: _unSelectedIcon(Icons.compare_arrows_outlined),
              activeIcon: _selectedIcon(Icons.compare_arrows_outlined),
              label: 'درخواست ها',
            ),
            if (_autService.isSupplier())
              BottomNavigationBarItem(
                icon: _unSelectedIcon(Icons.shopping_cart),
                activeIcon: _selectedIcon(Icons.shopping_cart),
                label: ' فروشگاه من',
              ),
            BottomNavigationBarItem(
              icon: _unSelectedIcon(Icons.person_outline_rounded),
              activeIcon: _selectedIcon(Icons.person_outline_rounded),
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
                    : (index.value == 2 && _autService.isSupplier())
                        ? MyShopPage()
                        : ProfilePage())),
      ),
    );
  }

  Widget _unSelectedIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: GradientIcon(
        icon: iconData,
        gradient: LinearGradient(
          colors: [Colors.black45, Colors.black45],
        ),
        size: selectedSize,
      ),
    );
  }

  Widget _selectedIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: GradientIcon(
        icon: iconData,
        gradient: LinearGradient(
          colors: GRADIANT_COLOR,
        ),
        size: selectedSize,
      ),
    );
  }
}
