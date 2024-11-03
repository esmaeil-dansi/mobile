import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/views/desk/home_view.dart';
import 'package:frappe_app/views/desk/order_page.dart';
import 'package:frappe_app/views/desk/profile_page.dart';
import 'package:frappe_app/views/desk/request_page.dart';
import 'package:frappe_app/views/desk/shop/all_shop_page.dart';
import 'package:frappe_app/views/desk/shop/shop_info_page.dart';
import 'package:frappe_app/views/desk/store_keeper_page.dart';
import 'package:frappe_app/views/desk/supplier_info_page.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DesktopView extends StatefulWidget {
  bool needToCheckUpdate;

  DesktopView({this.needToCheckUpdate = true});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  var index = 0.obs;
  final _visitService = GetIt.I.get<VisitService>();
  var unselectSize = 28.0;
  var selectedSize = 28.0;
  var _autService = GetIt.I.get<AutService>();
  var _shopService = GetIt.I.get<ShopService>();

  @override
  void initState() {
    // _checkSupplierInfoState();
    _autService.fetchRemainCredit();

    _visitService.fetchPrices();
    if (widget.needToCheckUpdate) {
      _autService.checkLoginCertificate().then((value) {
        if (!value) {
          Get.offAll(() => Login());
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        var res = await Geolocator.requestPermission();
        if (res == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _autService.initOldWeather();
        } else {
          _getLocation();
        }
      } else {
        _getLocation();
      }
    });

    super.initState();
  }

  Future<void> _checkSupplierInfoState() async {
    if (_autService.isSupplier()) {
      if (!await _autService.supplierInfoSubmitted()) {
        await _shopService.fetchShopInfo();
        if (_shopService.hasShop) {
          Get.offAll(() => SupplierInfoPage());
        }
      }
    }
  }

  Future<void> _getLocation() async {
    try {
      var l = await Geolocator.getCurrentPosition();
      _autService.getWeather(lat: l.latitude, lon: l.longitude);
    } catch (e) {
      _autService.initOldWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle: TextStyle(fontSize: 12),
          selectedLabelStyle: TextStyle(color: Colors.black,fontSize:12),
          currentIndex: index.value,
          // selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: Colors.black,

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _unSelectedIcon(Icons.home),
              activeIcon: _selectedIcon(Icons.home),
              label: 'خانه',
            ),
            if (_autService.isVisitingTeamOrIsRahbar())
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
              icon: _unSelectedIcon(Icons.list_alt_outlined),
              activeIcon: _selectedIcon(Icons.list_alt_outlined),
              label: 'سفارشات',
            ),
            if (_autService.isStorekeeper())
              BottomNavigationBarItem(
                icon: _unSelectedIcon(Icons.table_chart_sharp),
                activeIcon: _selectedIcon(Icons.table_chart_sharp),
                label: 'انبار من',
              ),
          ],
          onTap: (_) {
            index.value = _;
          },
        ),
        body:
            Container(color: Colors.white, child: Obx(() => _getMainWidget())),
      ),
    );
  }

  Widget _getMainWidget() {
    var i = index.value;
    if (i == 0) {
      return HomeView();
    } else if (i == 1) {
      if (_autService.isVisitingTeamOrIsRahbar()) {
        return RequestPage();
      } else if (_autService.isSupplier()) {
        return AllShopPage();
      }
      return OrderPage();
    } else if (i == 2) {
      if (_autService.isVisitingTeamOrIsRahbar()) {
        if (_autService.isSupplier()) {
          return AllShopPage();
        }
        return OrderPage();
      } else {
        if (_autService.isSupplier()) {
          return OrderPage();
        } else if (_autService.isStorekeeper()) {
          return StoreKeeperPage();
        }
        return SizedBox();
      }
    } else if (i == 3) {
      if (_autService.isVisitingTeamOrIsRahbar()) {
        if (_autService.isSupplier()) {
          return OrderPage();
        }
        if (_autService.isStorekeeper()) {
          return StoreKeeperPage();
        }
      } else {
        if (_autService.isStorekeeper()) {
          return StoreKeeperPage();
        }
      }
    }
    if (_autService.isStorekeeper()) {
      return StoreKeeperPage();
    }
    return CircularProgressIndicator();
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
