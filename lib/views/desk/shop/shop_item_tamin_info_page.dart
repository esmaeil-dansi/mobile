import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/cart.dart' as ca;
import 'package:frappe_app/model/shop_item_tamin_info.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/shop_cart_count.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class ShopItemTaminInfoPage extends StatelessWidget {
  ShopTamin shopTamin;

  ShopItemTaminInfoPage(this.shopTamin);

  var _shopService = GetIt.I.get<ShopService>();
  var _shopRepo = GetIt.I.get<ShopRepo>();
  var _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          shopCartCount(
              color: Colors.white,
              color2: Colors.yellow,
              textColor: Colors.black)
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // LinearGradient
            gradient: LinearGradient(
              // colors for gradient
              colors: GRADIANT_COLOR,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          shopTamin.supplier_name,
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _shopService.fetchShiopItemsTaminInfo(shopTamin.name),
            builder: (c, s) {
              if (s.hasData && s.data != null && s.data!.isNotEmpty) {
                var items = s.data!;
                return StreamBuilder<Map<String, ca.Cart>>(
                    stream: _shopRepo.watchCarts(),
                    builder: (context, snapshot) {
                      var carts = snapshot.data ?? {};
                      return ListView.separated(
                        itemCount: items.length,
                        itemBuilder: (c, i) {
                          bool isInCarts = carts.keys
                              .contains(shopTamin.name + items[i].name);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // height: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[i].name,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "موجودی: ",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Text(
                                          items[i].amount,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "\t" +
                                              (_shopService
                                                      .units[items[i].name] ??
                                                  ""),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(items[i].price.toString() +
                                            "\t" +
                                            "تومان"),
                                        if (isInCarts)
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              _shopRepo.deleteCart(
                                                  shopTamin.name +
                                                      items[i].name);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Container(
                                                  width: 140,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Colors.red),
                                                  child: Center(
                                                      child: Text(
                                                    "حذف از سبد خرید",
                                                    style: Get
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                  ))),
                                            ),
                                          )
                                        else
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              ShopItemTaminInfo info = items[i];
                                              Get.bottomSheet(
                                                  bottomSheetTemplate(
                                                      SingleChildScrollView(
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "خرید" +
                                                            "\t" +
                                                            info.name,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          controller:
                                                              _amountController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                                  label: Text(
                                                                      "مقدار درخواستی"),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        width:
                                                                            3,
                                                                        color: Colors
                                                                            .red),
                                                                    //<-- SEE HERE
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                  ),
                                                                  suffix: Text(
                                                                      _shopService
                                                                              .units[info.name] ??
                                                                          "")),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextField(
                                                          decoration:
                                                              InputDecoration(
                                                            label: Text(
                                                                "کد تخفیف"),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width: 3,
                                                                      color: Colors
                                                                          .red),
                                                              //<-- SEE HERE
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            // suffix: Text(_shopService
                                                            //     .units[info.name] ??
                                                            //     "")
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(c);
                                                          ca.Cart cart =
                                                              ca.Cart(
                                                            item: info.name,
                                                            time: DateTime.now()
                                                                .millisecondsSinceEpoch,
                                                            shopId:
                                                                shopTamin.name,
                                                            amount: double.parse(
                                                                _amountController
                                                                    .text),
                                                            price: info.price,
                                                          );
                                                          _shopRepo
                                                              .saveCart(cart);
                                                          _amountController
                                                              .clear();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      10),
                                                          child: Container(
                                                              width: Get.width,
                                                              height: 40,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors:
                                                                              GRADIANT_COLOR)),
                                                              child: Center(
                                                                  child: Text(
                                                                "افزودن به سبد خرید",
                                                                style: Get
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                        color: Colors
                                                                            .black),
                                                              ))),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Container(
                                                  width: 140,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      gradient: LinearGradient(
                                                          colors:
                                                              GRADIANT_COLOR)),
                                                  child: Center(
                                                      child: Text(
                                                    "افزودن به سبد خرید",
                                                    style: Get
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                            color: Colors.black,
                                                            fontSize: 12),
                                                  ))),
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox();
                        },
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
