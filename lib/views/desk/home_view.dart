import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:frappe_app/db/dao/price_dao.dart';
import 'package:frappe_app/methods.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/model/shop_group.dart';
import 'package:frappe_app/model/shop_type.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/shop/cart_page.dart';
import 'package:frappe_app/views/desk/shop/shop_group_item_ui.dart';
import 'package:frappe_app/views/desk/shop/shop_item_search_page.dart';
import 'package:frappe_app/views/desk/shop/wallet_page.dart';
import 'package:frappe_app/views/message/messages_view.dart';
import 'package:frappe_app/views/visit/initial_visit.dart';
import 'package:frappe_app/views/visit/periodic_visits.dart';
import 'package:frappe_app/views/visit/product_visit.dart';
import 'package:frappe_app/views/visit/vet_visit.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/shop_cart_count.dart';
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
  final _priceDao = GetIt.I.get<PriceAvgDao>();
  final _shopService = GetIt.I.get<ShopService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          shopCartCount(),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(() => WalletPage());
                },
                child: Icon(
                  Icons.wallet,
                  size: 28,
                  color: Colors.green,
                )),
          ),
        ],
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: 11),
          child: Image.asset(
            "assets/ChopoLogo.png",
            width: 55,
            height: 40,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
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
                                                    style: TextStyle(
                                                        fontSize: 9.5),
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
                                            style: TextStyle(fontSize: 10),
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
                StreamBuilder<PriceInfo?>(
                    stream: _priceDao.watch(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var info = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildReport(
                                      "گوسفند داشتی(راس)",
                                      info.gosfand.toString(),
                                      info.dosfandD,
                                    ),
                                    _buildReport(
                                      "گاو شیری(راس)",
                                      info.gov.toString(),
                                      info.govD,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildReport("شتر پرواری(نفر)",
                                        info.shotor.toString(), info.shotorD),
                                    _buildReport("قیمت جو(کیلوگرم)",
                                        info.go.toString(), info.goD),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "*",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        "منبع میانگین قیمت ها شرکت گسترش توسعه گری پردیس می باشد.",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
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
                              "فروشگاه محصولات",
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    showShopItems(t.type.getName());
                                  },
                                  child: _shopItemUi(
                                      showEmoji: t.type != ShopType.NAHADA,
                                      title: t.type.getName(),
                                      width: Get.width * 0.42,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildItem(() => Get.to(() => MessagesView()),
                                    'assets/messages.json', "پیام"),
                                _buildItem(() => Get.to(() => InitialVisit()),
                                    'assets/visit.json', "بازدید اولیه"),
                                _buildItem(() => Get.to(() => PeriodicVisits()),
                                    'assets/periodic.json', "بازدید دوره ای"),
                              ],
                              // scrollDirection: Axis.horizontal,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildItem(() => Get.to(() => VetVisit()),
                                    'assets/vetvisit.json', "بازدید دامپزشک"),
                                // _buildItem(() => Get.to(() => ProductVisit()),
                                //     'assets/product.json', "بهره وری"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 2),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.24,
                                  ),
                                )
                              ],
                            )
                          ],
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
      ),
    );
  }

  List<ShopGroup> _productsGroup = [
    ShopGroup(ShopType.DAM, "assets/icons/ma_dam.png"),
    ShopGroup(ShopType.NAHADA, "assets/icons/ma_nahana.png"),
  ];

  Widget _buildItem(Function onTap, String asset, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.24,
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
      required double height,
      bool showEmoji = false}) {
    width = width;
    height = height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
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
        height: 130,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: showEmoji
                      ? ImageSlideshow(
                          height: 80,
                          indicatorRadius: 0,
                          disableUserScrolling: true,
                          autoPlayInterval: 3000,
                          isLoop: true,
                          children: ["🐂", "🐐", "🐑", "🐪", "🐔", "🦃"]
                              .map((e) => Center(
                                child: Text(
                                      e,
                                      style: TextStyle(fontSize: 50),
                                    ),
                              ))
                              .toList(),
                        )
                      : ImageSlideshow(
                          height: 80,
                          indicatorRadius: 0,
                          disableUserScrolling: true,
                          autoPlayInterval: 2000,
                          isLoop: true,
                          children: [
                            "assets/icons/konjala_soya.jpg",
                            "assets/icons/kah.jpg",
                            "assets/icons/zorrat.jpg",
                            "assets/icons/consantara_parvari.jfif",
                            "assets/icons/yonja.jfif",
                            "assets/icons/sabos.jpeg",
                          ]
                              .map((e) => Image.asset(
                                    e,
                                     // width: 110,
                                    height: 70,
                                    fit: BoxFit.fill,
                                  ))
                              .toList(),
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

  Widget _buildReport(String s, String count, double d) {
    return Container(
      height: 76,
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
          height: 80,
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
                  ],
                ),
                if (d != 0.0)
                  Row(
                    children: [
                      Text(
                          "%" +
                              d
                                  .abs()
                                  .toString()
                                  .substring(0, min(d.toString().length, 6)),
                          style: TextStyle(fontSize: 8)),
                      if (d != 0)
                        if (d > 0)
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
                          ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("از دیروز", style: TextStyle(fontSize: 8)),
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

  void showShopItems(String group) {
    Get.bottomSheet(bottomSheetTemplate(ShopItemSearchPage(group)));
  }
}
