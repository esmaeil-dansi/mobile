import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/views/desk/shop/cart_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

Widget shopCartCount(
    {Color color = Colors.green,
    Color color2 = Colors.blueAccent,
    Color textColor = Colors.white}) {
  var _shopRepo = GetIt.I.get<ShopRepo>();

  return StreamBuilder(
      stream: _shopRepo.watchCarts(),
      builder: (c, s) {
        var count = s.data?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.to(() => CartPage());
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 28,
                        color: color,
                      ),
                      if (count > 0)
                        Positioned(
                            left: 26,
                            top: 1,
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: color2),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: textColor),
                                  ),
                                ))),
                    ],
                  ),
                ),
              )),
        );
      });
}
