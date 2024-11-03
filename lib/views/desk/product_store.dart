import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frappe_app/views/desk/shop/shop_item_search_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../model/shop_group.dart';
import '../../model/shop_type.dart';
import '../../services/aut_service.dart';
import '../../widgets/app_sliver_app_bar.dart';
import '../../widgets/buttomSheetTempelate.dart';

class ProductStore extends StatefulWidget {
  @override
  State<ProductStore> createState() => _ProductStoreState();
}

class _ProductStoreState extends State<ProductStore> {
  final _autService = GetIt.I.get<AutService>();
  List<ShopGroup> _productsGroup = [
    ShopGroup(ShopType.DAM, "assets/icons/ma_dam.png"),
    ShopGroup(ShopType.NAHADA, "assets/icons/ma_nahana.png"),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appSliverAppBar("فروشگاه محصولات"),
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      height: 200,
                      width: width + 20,
                      child: FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            child: SvgPicture.asset(
                              'assets/icons/productStore.svg', // مسیر فایل SVG شما
                              height: 200.0,
                            ),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
      Column(
        children: [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var t in _productsGroup)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
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
    ],
    )
    )
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

  void showShopItems(String group) {
    Get.bottomSheet(isScrollControlled: true,bottomSheetTemplate(ShopItemSearchPage(group)));
  }
}
