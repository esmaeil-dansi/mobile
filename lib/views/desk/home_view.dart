import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frappe_app/methods.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/model/shop_group.dart';
import 'package:frappe_app/model/shop_type.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/shop/shop_group_item_ui.dart';
import 'package:frappe_app/views/message/messages_view.dart';
import 'package:frappe_app/views/visit/initial_visit.dart';
import 'package:frappe_app/views/visit/periodic_visits.dart';
import 'package:frappe_app/views/visit/vet_visit.dart';
import 'package:frappe_app/widgets/city_selector.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

import '../../widgets/constant.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _autService = GetIt.I.get<AutService>();
  final _visitService = GetIt.I.get<VisitService>();
  Rx<String> _selectedCity = "".obs;

  @override
  void initState() {
    _visitService.fetchPricess();
    _selectedCity.value = _autService.getSelectedCity();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _checkSelectedCity(force: false);
    });
    super.initState();
  }

  void _checkSelectedCity({bool force = false}) {
    if (force || _selectedCity.isEmpty) {
      String s = "";
      Get.bottomSheet(
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "شهر خود را انتخاب کنید",
                        style: Get.textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      citySelector("", (p0) {
                        s = p0;
                      }, _selectedCity.value),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (s.isNotEmpty) {
                        _selectedCity.value = s;
                        _autService.saveSelectedCity(_selectedCity.value);
                        _autService.weathers.clear();
                        _getWeather();
                        Navigator.pop(context);
                      } else if (_autService.getSelectedCity().isNotEmpty) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(colors: GRADIANT_COLOR)),
                        width: double.infinity,
                        child: Center(
                            child: Text(
                          "ثبت",
                          style: Get.textTheme.bodyLarge
                              ?.copyWith(fontSize: 23)
                              ?.copyWith(color: Colors.black),
                        ))),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          ),
          isDismissible: _selectedCity.isNotEmpty,
          enableDrag: _selectedCity.isNotEmpty);
    } else {
      _getWeather();
    }
  }

  void _getWeather() {
    _autService.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Obx(() => _selectedCity.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                       _checkSelectedCity(force: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: GRADIANT_COLOR),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    _selectedCity.value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.keyboard_arrow_down_outlined)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink())
        ],
        backgroundColor: Colors.white,
        title: Text(
          "چوپو",
          style: TextStyle(
              fontSize: 24, color: MAIN_COLOR, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                child: Obx(() => _autService.weathers.isNotEmpty
                    ? SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _autService.weathers
                              .map((element) => Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          getWeatherDescription(element.main,
                                                  element.description)
                                              .$2,
                                          size: 30,
                                          color: getWeatherDescription(
                                                  element.main,
                                                  element.description)
                                              .$3,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\tC",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                            Stack(
                                              alignment: Alignment.topLeft,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 30),
                                                  child: Icon(
                                                    Icons.circle_outlined,
                                                    size: 7,
                                                  ),
                                                ),
                                                Text(
                                                  element.temp.toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          getWeatherDescription(
                                            element.main,
                                            element.description,
                                          ).$1,
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(element.w),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              element.date,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    : SizedBox(
                        height: 90,
                      )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildReport(
                              "گوسفند داشتی(راس)",
                              _visitService.avgPrices["گوسفند داشتی"] ??
                                  '122521010',
                              0.03,
                              false),
                          _buildReport(
                              "گاو شیری(راس)",
                              _visitService.avgPrices["گاو شیری"] ??
                                  '901022622',
                              0.01,
                              true),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildReport(
                              "شتر پرواری(نفر)",
                              _visitService.avgPrices['شتر پرواری'] ??
                                  '198334285',
                              0.02,
                              true),
                          _buildReport(
                              "قیمت جو(کیلوگرم)",
                              _visitService.avgPrices['جو دامی وارداتی'] ??
                                  '116616',
                              0,
                              true),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_autService.isDamdar())
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          Text(
                            "محصولات",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var t in _productsGroup)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Get.to(() => ShopGroupItemUi(
                                        type: t.type,
                                      ));
                                },
                                child: _shopItemUi(
                                    title: t.type.getName(),
                                    width: 100,
                                    height: 250,
                                    asset: t.asset),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (_autService.isRahbar() || _autService.isSarRahbar())
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        children: [
                          Text(
                            "فرم ها",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 130,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildItem(() => Get.to(() => MessagesView()),
                                'assets/messages.json', "پیام"),
                            _buildItem(() => Get.to(() => InitialVisit()),
                                'assets/visit.json', "بازدید اولیه"),
                            _buildItem(() => Get.to(() => PeriodicVisits()),
                                'assets/periodic.json', "بازدید دوره ای"),
                            _buildItem(() => Get.to(() => VetVisit()),
                                'assets/vetvisit.json', "بازدید دامپزشک"),
                          ],
                          // scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                  ],
                ),
              // if (!_autService.isRahbar() &&
              //     !_autService.isDamdar() &&
              //     !_autService.isSarRahbar())
              //   Text("شما دسترسی ندارید!")
            ],
          ),
        ),
      ),
    );
  }

  List<ShopGroup> _productsGroup = [
    ShopGroup(ShopType.DAM, "assets/icons/ma_dam.png"),
    ShopGroup(ShopType.TOTOR, "assets/icons/toyor.png"),
    ShopGroup(ShopType.NAHADA, "assets/icons/ma_nahana.png"),
  ];

  Widget _buildItem(Function onTap, String asset, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.22,
        height: 100,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: GRADIANT_COLOR),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: Get.width * 0.22,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black12,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  onTap();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(asset,
                        fit: BoxFit.scaleDown,
                        width: 40,
                        height: 40,
                        repeat: true),
                    SizedBox(
                      width: 4,
                    ),
                    Center(
                      child: Text(
                        title,
                        style: Get.textTheme.bodyMedium?.copyWith(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _shopItemUi(
      {required String title,
      required String asset,
      required double width,
      required double height}) {
    width = width;
    height = height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.05),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black12,
            //   blurRadius: 4,
            //   // offset: Offset(4, 8), // Shadow position
            // ),
          ],
        ),
        width: width,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    asset,
                    // width: 130,
                    // height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReport(String s, String count, double d, bool increase) {
    return Container(
      height: 71,
      width: 162,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: GRADIANT_COLOR,
        ),
        borderRadius: BorderRadius.circular(10),
        // border: Border.all()
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          height: 70,
          // width: Get.width * 0.43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(s, style: TextStyle(fontSize: 11, color: Colors.black54)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _splitPrice(count.toString()),
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("%" + d.toString(),
                                style: TextStyle(fontSize: 8)),
                            if (d != 0)
                              if (increase)
                                Icon(
                                  Icons.trending_up,
                                  color: Colors.blue,
                                  size: 11,
                                )
                              else
                                Icon(
                                  Icons.trending_down,
                                  color: Colors.red,
                                  size: 11,
                                )
                          ],
                        ),
                        Text("از دیروز", style: TextStyle(fontSize: 8)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _splitPrice(String t) {
    var s = t.split('').reversed.toList();
    List<List<String>> sf = [];
    var j = 0;
    int start = 0;
    while (j < s.length) {
      sf.add(s.sublist(start, min(start + 3, t.length)).reversed.toList());
      start = start + 3;
      j = j + 3;
    }
    sf = sf.reversed.toList();
    String sr = "";
    for (int i = 0; i < sf.length; i++) {
      sr = sr + sf[i].join("");
      if (sf.length - i != 1) {
        sr = sr + ",";
      }
    }
    return sr;
  }
}
