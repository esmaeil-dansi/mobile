import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/and_and_edit_cart_page.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class CartPage extends StatelessWidget {
  final _shopRepo = GetIt.I.get<ShopRepo>();
  final _shopService = GetIt.I.get<ShopService>();

  var _hasCard = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() => _hasCard.isTrue
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(colors: GRADIANT_COLOR)),
                    child: Center(
                        child: Text(
                      "ثبت خرید",
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black),
                    ))),
              ),
            )
          : SizedBox.shrink()),
      appBar: AppBar(
        title: Text("سبد خرید"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        child: StreamBuilder(
            stream: _shopRepo.watchCarts(),
            builder: (c, s) {
              // _hasCard.value = s.data?.isNotEmpty ?? false;
              if (s.hasData && s.data != null) {
                if (s.data!.isEmpty) {
                  return Center(child: Text("سبد خرید شما خالی است."));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: s.data!.keys.length,
                  itemBuilder: (c, i) {
                    var cart = s.data!.values.toList()[i];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                              label: Text(
                                "فروشگاه \t" + cart.shopId,
                                style: TextStyle(fontSize: 18),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all()),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cart.item,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      Text(
                                        "قیمت :" + cart.price.toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Row(
                                        children: [
                                          Text("مقدار:" +
                                              "\t" +
                                              cart.amount.toString() +
                                              "\t" +
                                              (_shopService.units[cart.item] ??
                                                  "")),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _shopRepo.deleteCart(
                                                s.data!.keys.toList()[i]);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            addOrEditCartPage(cart);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.blueAccent,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
