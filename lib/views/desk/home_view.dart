import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/prices_view.dart';
import 'package:frappe_app/views/desk/product_store.dart';
import 'package:frappe_app/views/desk/profile_page.dart';
import 'package:frappe_app/views/desk/shop/wallet_page.dart';
import 'package:frappe_app/views/desk/support_view.dart';
import 'package:frappe_app/views/desk/weather_view.dart';

import 'package:frappe_app/widgets/shop_cart_count.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../visit/add_dam_initial_visit.dart';
import '../visit/add_initial_visit.dart';
import '../visit/add_product_info.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _autService = GetIt.I.get<AutService>();

  final List<String> imgList = ['assets/slider01.jpg', 'assets/slider02.jpg'];
  List<MainItem> mainItems = [];
  List<MainItem> visitItems = [];

  @override
  void initState() {
    mainItems = _getMainItems();
    visitItems = _getVisitItems();
    super.initState();
  }

  List<Widget> roleAccess() {
    Map<String, Widget> access = {};

    if (_autService.isDamdar()) {
      access["ProductStore"] = ProductStore();
    }
    if (_autService.isRahbar()) {
      access["AddInitialReport"] = (AddInitialReport(
        key: ValueKey('AddInitialReport'),
      ));
      access["AddProductInfoReport"] = (AddProductInfoReport(
        key: ValueKey('AddProductInfoReport'),
      ));
    }
    if (_autService.isDamyar()) {
      access["AddDamInitialVisit"] = (AddDamInitialVisit(
        key: ValueKey('AddDamInitialVisit'),
      ));
    }
    if (_autService.isStorekeeper()) {
      // access.add(AddProductInfoReport(
      //   key: ValueKey('AddProductInfoReport'),
      // ));
    }
    if (_autService.isSarRahbar()) {
      access["AddInitialReport "] = (AddInitialReport(
        key: ValueKey('AddInitialReport'),
      ));
      access["AddProductInfoReport"] = (AddProductInfoReport(
        key: ValueKey('AddProductInfoReport'),
      ));
    }
    if (_autService.isSupplier()) {}
    return access.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          shopCartCount(),
          Padding(
            padding: const EdgeInsets.only( left: 15, right: 20),
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
          Padding(
            padding: const EdgeInsets.only(right: 5,left: 5),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(() => ProfilePage());
                },
                child: Icon(
                  CupertinoIcons.person_alt_circle,
                  size: 30,
                  color: Colors.black,
                )),
          ),
        ],
        backgroundColor: Colors.white,

        leading : Padding(
          padding: const EdgeInsets.only(top: 4,right: 4),
          child: Image.asset(
            "assets/ChopoLogo.png",
            width: 50,
            height: 40,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: Color(0xa3efefea),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 170.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: imgList
                    .map((item) => GestureDetector(
                          onTap: () {
                            _launchURL('https://Chopoo.ir/');
                          },
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Center(
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 170,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 8.0, // space between items horizontally
                      runSpacing: 4.0,
                      children: [
                        _buildItem1(mainItems[0]),
                        _buildItem1(mainItems[1]),
                        if (mainItems.length > 2) _buildItem1(mainItems[2])
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        thickness: 3,
                        color: Colors.black12,
                        radius: BorderRadius.circular(10),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0, // space between items horizontally
                      runSpacing: 4.0,
                      children: visitItems
                          .map((e) => _buildItem1(e, isSquare: false))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem1(MainItem item, {bool isSquare = true}) {
    if (item.title.isEmpty) return item.targetClass;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Container(
        width: isSquare ? 90 : 140,
        height: isSquare ? 90 : 100,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade100.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Get.to(() => item.targetClass),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    item.assets,
                    fit: BoxFit.scaleDown,
                    width: 40,
                    height: 40,
                    repeat: true,
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      item.title,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String urlString) async {
    final Uri _url = Uri.parse(urlString);
    await launchUrl(_url);
  }

  List<MainItem> _getMainItems() {
    List<Widget> visibleMenuItems = [
      WeatherView(),
      PricesView(),
      SupportView()
    ];

    List<MainItem> rows = [];
    for (int i = 0; i < visibleMenuItems.length; i += 1) {
      rows.add(_setTitleAndPath(visibleMenuItems[i]));
    }
    return rows;
  }

  List<MainItem> _getVisitItems() {
    List<Widget> visibleMenuItems = roleAccess();
    List<MainItem> rows = [];
    for (int i = 0; i < visibleMenuItems.length; i += 1) {
      rows.add(_setTitleAndPath(visibleMenuItems.elementAt(i)));
    }
    return rows;
  }

  MainItem _setTitleAndPath(Widget pageName) {
    switch (pageName.runtimeType.toString()) {
      case "WeatherView":
        return MainItem(
            title: "آب و هوا",
            assets: 'assets/weather.json',
            targetClass: pageName);

      case "PricesView":
        return MainItem(
            title: "قیمت ها",
            assets: 'assets/price.json',
            targetClass: pageName);
      case "SupportView":
        return MainItem(
            title: "پشتیبانی",
            assets: 'assets/support.json',
            targetClass: pageName);
        break;
      // case "MessagesView":
      //   this.title = "پیام";
      //   this.path = 'assets/messages.json';
      //   break;
      case "AddInitialReport":
        return MainItem(
            title: "بازدید اولیه",
            assets: 'assets/visit.json',
            targetClass: pageName);
      case "ProductVisit":
        return MainItem(
            title: "بازدید بهره وری",
            assets: 'assets/periodic.json',
            targetClass: pageName);
      case "VetVisit":
        return MainItem(
            title: "بازدید دامپزشک",
            assets: 'assets/vetvisit.json',
            targetClass: pageName);
      case "AddDamInitialVisit":
        return MainItem(
            title: "بازدید اولیه دام",
            assets: 'assets/vetvisit.json',
            targetClass: pageName);
      case "AddProductInfoReport":
        return MainItem(
            title: "بازدید بهره وری",
            assets: 'assets/periodic.json',
            targetClass: pageName);
      case "ProductStore":
        return MainItem(
            title: "فروشگاه",
            assets: 'assets/productstore.json',
            targetClass: pageName);
      default:
        return MainItem(
            title: "آب و هوا",
            assets: 'assets/weather.json',
            targetClass: pageName);
    }
  }
}

class MainItem {
  String title;
  String assets;
  Widget targetClass;

  MainItem(
      {required this.title, required this.assets, required this.targetClass});
}
