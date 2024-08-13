import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/model/shop_item_tamin_info.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/views/desk/shop/shop_item_tamin_info_page.dart';
import 'package:frappe_app/views/desk/shop/shop_tamin_avatar.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';

class ShopItemTaminPage extends StatelessWidget {
  ShopTamin shopTamin;
  ShopItemBaseModel item;

  ShopItemTaminPage(this.shopTamin,this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShopTaminavatar(shopTamin.image),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopTamin.supplier_name,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          shopTamin.name,
                          style: TextStyle(fontSize: 17),
                        ),
                        Text("گروه " + shopTamin.supplier_group),
                        Text("استان " + shopTamin.custom_provinc),
                      ],
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.to(() => ShopItemTaminInfoPage(shopTamin));
                      },
                      child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(colors: GRADIANT_COLOR)),
                          child: Center(
                              child: Text(
                            "مشاهده",
                            style: Get.textTheme.bodyLarge
                                ?.copyWith(color: Colors.black),
                          ))),
                    )
                  ],
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: GRADIANT_COLOR)),
    );
  }
}
