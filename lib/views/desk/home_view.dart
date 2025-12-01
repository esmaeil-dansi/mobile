import 'dart:convert';
import 'dart:math';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/db/dao/price_dao.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/model/shop_group.dart';
import 'package:frappe_app/model/shop_type.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/prices_view.dart';
import 'package:frappe_app/views/desk/product_store.dart';
import 'package:frappe_app/views/desk/profile_page.dart';
import 'package:frappe_app/views/desk/shop/wallet_page.dart';
import 'package:frappe_app/views/desk/support_view.dart';
import 'package:frappe_app/views/desk/weather_view.dart';
import 'package:frappe_app/views/message/messages_view.dart';
import 'package:frappe_app/views/visit/initial_visit.dart';
import 'package:frappe_app/views/visit/periodic_visits.dart';
import 'package:frappe_app/views/visit/product_visit.dart';
import 'package:frappe_app/views/visit/vet_visit.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/shop_cart_count.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/constant.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    if (_autService.isDamdar()) {
      suggest.add('فروشگاه محصولات');
    }
    super.initState();
  }

  final _autService = GetIt.I.get<AutService>();
  final _visitService = GetIt.I.get<VisitService>();
  final _priceDao = GetIt.I.get<PriceAvgDao>();
  final _shopService = GetIt.I.get<ShopService>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  List<String> suggest = [
    'آب و هوا',
    'قیمت ها',
    'بازدید اولیه',
    'بازدید بهره وری',
    'پشتیبانی',
    'فروشگاه محصولات'
  ];
  final List<String> imgList = ['assets/slider01.jpg', 'assets/slider02.jpg'];

  // List<String> suggest = [
  //   'آب و هوا',
  //   'قیمت ها',
  //   'پیام',
  //   'بازدید اولیه',
  //   'بازدید دوره ای',
  //   'بازدید دامپزشک',
  //   'پشتیبانی',
  // ];
  // final List<String> imgList = ['assets/slider01.png', 'assets/slider02.png'];
  late String title;
  late String path;
  final Map<String, List<Widget>> roleAccess = {
    'دامدار': [WeatherView(), PricesView(), SupportView()],
    'راهبر': [
      WeatherView(),
      PricesView(),
      // SupportView(),
      // MessagesView(),
      InitialVisit(),
      ProductVisit(),
      // VetVisit()
    ],
    'سر راهبر': [
      WeatherView(),
      PricesView(),
      // SupportView(),
      // MessagesView(),
      InitialVisit(),
      ProductVisit(),
    ],
    'Supplier': [
      WeatherView(),
      PricesView(),
      // SupportView(),
      // MessagesView(),
      InitialVisit(),
      ProductVisit(),
    ],
    'انباردار': [
      WeatherView(),
      PricesView(),
      // SupportView(),
      // MessagesView(),
      InitialVisit(),
      ProductVisit(),
    ]
  };

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
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(() => ProfilePage());
                },
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.black,
                )),
          ),
        ],
        backgroundColor: Colors.white,
        leading: SizedBox.shrink(),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AutoCompleteTextField<String>(
              //   key: key,
              //   suggestions: suggest,
              //   decoration: InputDecoration(
              //     labelText: 'جستجو',
              //     prefixIcon: Icon(Icons.search),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //   ),
              //   itemFilter: (item, query) {
              //     return item.toLowerCase().startsWith(query.toLowerCase());
              //   },
              //   itemSorter: (a, b) {
              //     return a.compareTo(b);
              //   },
              //   itemSubmitted: (item) {
              //     setState(() {
              //       _navigateToPage(item);
              //     });
              //   },
              //   itemBuilder: (context, item) {
              //     return ListTile(
              //       title: Text(item),
              //     );
              //   },
              // ),
              // SizedBox(
              //   height: 5,
              // ),

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
                            child: Center(
                              child: Image.asset(item,
                                  fit: BoxFit.contain, width:double.infinity,height: 250,),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 100),
                child: Column(
                  children: [
                    if (_autService.isDamdar())
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildItem(
                              () => Get.to(() => ProductStore()),
                              'assets/productstore.json',
                              "فروشdddگاه محصولات",
                              true),
                        ],

                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [_itemMenu()[0], _itemMenu()[1]],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_itemMenu().length > 2) _itemMenu()[2],
                        if (_itemMenu().length > 3) _itemMenu()[3]
                      ],
                    )
                  ],
                ),
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

  Widget _buildItem(Function onTap, String asset, String title, bool custom) {
    double vertical = 4, horizontal = 2, width = 0.24, height = 100;
    if (custom) {
      vertical = 6;
      horizontal = 4;
      width = 0.30;
      height = 120;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: Container(
        width: MediaQuery.of(context).size.width * width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: Get.width * 0.3,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTap(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    asset,
                    fit: BoxFit.scaleDown,
                    width: 40,
                    height: 40,
                    repeat: true,
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      title,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
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

  List<Widget> _itemMenu() {
    String userRole = "راهبر";
    if (_autService.isDamdar() &&
        !_autService.isRahbar() &&
        !_autService.isSarRahbar()) {
      userRole = "دامدار";
    }
    List<Widget> visibleMenuItems = roleAccess[userRole] ?? [];
    List<Widget> rows = [];
    for (int i = 0; i < visibleMenuItems.length; i += 1) {
      _setTitleAndPath(visibleMenuItems[i]);
      rows.add(_buildItem(() => Get.to(() => visibleMenuItems[i]), this.path,
          this.title, false));
    }
    return rows;
  }

  void _setTitleAndPath(Widget pageName) {
    switch (pageName.runtimeType.toString()) {
      case "WeatherView":
        this.title = "آب و هوا";
        this.path = 'assets/weather.json';
        break;
      case "PricesView":
        this.title = "قیمت ها";
        this.path = 'assets/price.json';
        break;
      case "SupportView":
        this.title = "پشتیبانی";
        this.path = 'assets/support.json';
        break;
      // case "MessagesView":
      //   this.title = "پیام";
      //   this.path = 'assets/messages.json';
      //   break;
      case "InitialVisit":
        this.title = "بازدید اولیه";
        this.path = 'assets/visit.json';
        break;
      case "ProductVisit":
        this.title = "بازدید بهره وری";
        this.path = 'assets/periodic.json';
        break;
      case "VetVisit":
        this.title = "بازدید دامپزشک";
        this.path = 'assets/vetvisit.json';
        break;
      default:
        WeatherView:
        this.title = "آب و هوا";
        this.path = 'assets/weather.json';
    }
  }
}
