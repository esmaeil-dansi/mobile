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
  final _autService = GetIt.I.get<AutService>();
  final _visitService = GetIt.I.get<VisitService>();
  final _priceDao = GetIt.I.get<PriceAvgDao>();
  final _shopService = GetIt.I.get<ShopService>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  List<String> suggest = ['آب و هوا', 'قیمت ها', 'پیام', 'بازدید اولیه', 'بازدید دوره ای', 'بازدید دامپزشک', 'پشتیبانی', 'فروشگاه محصولات'];
  final List<String> imgList = ['assets/slider01.png', 'assets/slider02.png'];

  void _navigateToPage(String pageName) {
    Widget page;
    switch (pageName) {
      case 'آب و هوا':page = WeatherView();break;
      case 'قیمت ها':page = PricesView();break;
      case 'پیام':page = MessagesView();break;
      case 'بازدید اولیه':page = InitialVisit();break;
      case 'بازدید دوره ای':page = ProductVisit();break;
      case 'بازدید دامپزشک':page = VetVisit();break;
      case 'پشتیبانی':page = SupportView();break;
      case 'فروشگاه محصولات' :page = ProductStore();break;
      default:page = HomeView();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

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
                AutoCompleteTextField<String>(
                  key: key,
                  suggestions: suggest,
                  decoration: InputDecoration(
                    labelText: 'جستجو',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  itemFilter: (item, query) {
                    return item.toLowerCase().startsWith(query.toLowerCase());
                  },
                  itemSorter: (a, b) {
                    return a.compareTo(b);
                  },
                  itemSubmitted: (item) {
                    setState(() {
                      _navigateToPage(item);
                    });
                  },
                  itemBuilder: (context, item) {
                    return ListTile(
                      title: Text(item),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                if (_autService.isRahbar() || _autService.isSarRahbar())
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildItem(() => Get.to(() => WeatherView()),
                                    'assets/weather.json', "آب و هوا"),
                                _buildItem(() => Get.to(() => PricesView()),
                                    'assets/price.json', "قیمت ها"),
                                _buildItem(() => Get.to(() => MessagesView()),
                                    'assets/messages.json', "پیام"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildItem(() => Get.to(() => InitialVisit()),
                                    'assets/visit.json', "بازدید اولیه"),
                                _buildItem(() => Get.to(() => PeriodicVisits()),
                                    'assets/periodic.json', "بازدید دوره ای"),
                                _buildItem(() => Get.to(() => VetVisit()),
                                    'assets/vetvisit.json', "بازدید دامپزشک"),
                                // _buildItem(() => Get.to(() => ProductVisit()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildItem(() => Get.to(() => SupportView()),
                                    'assets/support.json', "پشتیبانی"),
                                _buildItem(() => Get.to(() => null),
                                    'assets/instagram.json', "اینستاگرام"),
                                _buildItem(() => Get.to(() => null),
                                    'assets/articles.json', "آموزش مقالات"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildItem(() => Get.to(() => ProductStore()),
                                    'assets/productstore.json', "فروشگاه محصولات"),
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
                CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: imgList
                      .map((item) => GestureDetector(
                            onTap: ()  {
                              _launchURL();
                            },
                            child: Container(
                              child: Center(
                                child: Image.asset(item,
                                    fit: BoxFit.cover, width: 1000),
                              ),
                            ),
                          ))
                      .toList(),
                ),
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
                  if(title== "اینستاگرام"|| title=="آموزش مقالات"){_launchURL();}
                  else{onTap();}
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

  void _launchURL() async {
    final Uri _url = Uri.parse('https://Chopoo.ir/');
    // if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    // } else {
    //   throw 'Could not launch $_url';
    // }
  }
}
