import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:frappe_app/model/shop_group.dart';
import 'package:frappe_app/model/shop_type.dart';
import 'package:frappe_app/views/desk/shop/shop_item_ui.dart';
import 'package:frappe_app/views/desk/shop/shop_user_page.dart';
import 'package:frappe_app/widgets/aimal_type_page.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:get/get.dart';

class ShopGroupItemUi extends StatelessWidget {
  ShopType type;

  ShopGroupItemUi({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appSliverAppBar(
        type.getName(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    List<ShopItemType> items = subGroup[type]!;
    switch (type) {
      case ShopType.DAM:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _item(
                      subTitle: items[0].title,
                      child: shopItemUi(
                          title: items[0].title,
                          asset: items[0].asset,
                          width: Get.width * 0.4,
                          height: 250,
                          price: items[0].title == "گاو" ? "1000000" : ""),
                    ),
                    _item(
                      subTitle: items[1].title,
                      child: shopItemUi(
                          title: items[1].title,
                          asset: items[1].asset,
                          width: Get.width * 0.4,
                          height: 250),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    _item(
                      subTitle: items[2].title,
                      child: shopItemUi(
                          title: items[2].title,
                          asset: items[2].asset,
                          width: Get.width * 0.4,
                          height: 250),
                    ),
                    _item(
                      subTitle: items[3].title,
                      child: shopItemUi(
                          title: items[3].title,
                          asset: items[3].asset,
                          width: Get.width * 0.4,
                          height: 250),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case ShopType.TOTOR:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _item(
                    subTitle: items[0].title,
                    child: shopItemUi(
                        title: items[0].title,
                        asset: items[0].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                  _item(
                    subTitle: items[1].title,
                    child: shopItemUi(
                        title: items[1].title,
                        asset: items[1].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _item(
                    subTitle: items[2].title,
                    child: shopItemUi(
                        title: items[2].title,
                        asset: items[2].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                  _item(
                    subTitle: items[3].title,
                    child: shopItemUi(
                        title: items[3].title,
                        asset: items[3].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              _item(
                subTitle: items[4].title,
                child: shopItemUi(
                    title: items[4].title,
                    asset: items[4].asset,
                    width: Get.width * 0.4,
                    height: 250),
              ),
            ],
          ),
        );
      case ShopType.NAHADA:
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _item(
                    subTitle: items[0].title,
                    child: shopItemUi(
                        title: items[0].title,
                        asset: items[0].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                  _item(
                    subTitle: items[1].title,
                    child: shopItemUi(
                        title: items[1].title,
                        asset: items[1].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _item(
                    subTitle: items[2].title,
                    child: shopItemUi(
                        title: items[2].title,
                        asset: items[2].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                  _item(
                    subTitle: items[3].title,
                    child: shopItemUi(
                        title: items[3].title,
                        asset: items[3].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _item(
                    subTitle: items[4].title,
                    child: shopItemUi(
                        title: items[4].title,
                        asset: items[4].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                  _item(
                    subTitle: items[5].title,
                    child: shopItemUi(
                        title: items[5].title,
                        asset: items[5].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _item(
                    subTitle: items[6].title,
                    child: shopItemUi(
                        title: items[6].title,
                        asset: items[6].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                  _item(
                    subTitle: items[7].title,
                    child: shopItemUi(
                        title: items[7].title,
                        asset: items[7].asset,
                        width: Get.width * 0.4,
                        height: 250),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              _item(
                  subTitle: items[8].title,
                  child: shopItemUi(
                      title: items[8].title,
                      asset: items[8].asset,
                      height: 250)),
            ],
          ),
        );
    }
  }

  Widget _item({required String subTitle, required Widget child}) =>
      GestureDetector(
          onTap: () {
            if ( true ||  type == ShopType.NAHADA) {
              Get.to(() => SubGroupTamin(type, subTitle));
            } else {
              Get.bottomSheet(AnimalTypePage(type, subTitle));
            }
          },
          child: child);
}

Map<ShopType, List<ShopItemType>> subGroup = {
  ShopType.DAM: [
    ShopItemType("گوسفند", "assets/icons/gosfand.jpg", "122521010"),
    ShopItemType("گاو", "assets/icons/gav.jpg", "901022622"),
    ShopItemType("بز", "assets/icons/boz.jpg", ""),
    ShopItemType("شتر", "assets/icons/shotor.jpg", "198334285")
  ],
  ShopType.TOTOR: [
    ShopItemType("مرغ", "assets/icons/ma_toyor.webp", ""),
    ShopItemType("مرغابی", "assets/icons/morghabi.webp", ""),
    ShopItemType("غاز", "assets/icons/gaz.jpg", ""),
    ShopItemType("اردک", "assets/icons/ordak.webp", ""),
    ShopItemType("بوقلمون", "assets/icons/bogalamon.jpg", ""),
  ],
  ShopType.NAHADA: [
    ShopItemType(
      "جو",
      "assets/icons/jo.webp",
      "",
    ),
    ShopItemType("ذرت", "assets/icons/zorrat.jpg", ""),
    ShopItemType("کنجاله سویا", "assets/icons/konjala_soya.jpg", ""),
    ShopItemType("کاه", "assets/icons/kah.jpg", ""),
    ShopItemType("کنسانتره شیری", "assets/icons/consanrara_shiri.jpg", ""),
    ShopItemType("کنسانتره پرواری", "assets/icons/consantara_parvari.jpg", ""),
    ShopItemType("یونجه", "assets/icons/yonja.jpg", ""),
    ShopItemType("سبوس", "assets/icons/sabos.jpg", ""),
    ShopItemType("سیلاژ ذرت", "assets/icons/s_zorrat.jpg", "")
  ],
};
