import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/cart.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/views/desk/shop/wallet_page.dart';
import 'package:frappe_app/widgets/and_and_edit_cart_page.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _shopRepo = GetIt.I.get<ShopRepo>();
  final _autService = GetIt.I.get<AutService>();
  final _shopService = GetIt.I.get<ShopService>();
  RxMap<String, Cart> _cart = <String, Cart>{}.obs;
  final _init = false.obs;

  int getCartPrice() {
    var requiredCredit = 0;
    _cart.values.forEach((c) {
      requiredCredit = requiredCredit + (c.price * c.amount).floor();
    });
    return requiredCredit;
  }

  bool _havingEnoughCredit() {
    var remainCredit = _autService.remainCredit.value;
    int r = double.parse(
            remainCredit.replaceAll("ریال", "").replaceAll("\t", "").trim())
        .floor();
    if (r == 0) {
      return false;
    } else {
      return getCartPrice() <= r;
    }
  }

  @override
  void initState() {
    _shopRepo.watchCarts().listen((_) {
      _init.value = true;
      _cart.value = _;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() => _cart.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return AlertDialog(
                          title: Text(
                            "انتخاب روش پرداخت",
                            style: TextStyle(fontSize: 16),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    Navigator.pop(c);
                                    _handeBuyByCredit(context);
                                  },
                                  child: Center(
                                      child: Text(
                                    "پرداخت از اعتبار",
                                    style: TextStyle(color: Colors.black),
                                  ))),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    Navigator.pop(c);
                                    _buy("پرداخت در محل");
                                  },
                                  child: Center(
                                      child: Text(
                                    "پرداخت در محل",
                                    style: TextStyle(color: Colors.black),
                                  ))),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                        msg:
                                            "فعلا امکان پرداخت آنلاین وجود ندارد!");
                                  },
                                  child: Center(
                                      child: Text(
                                    "پرداخت آنلاین ",
                                    style: TextStyle(color: Colors.black),
                                  ))),
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                    width: 170,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(colors: GRADIANT_COLOR)),
                    child: Center(
                        child: Text(
                      "ثبت معاملات",
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
          child: Obx(() => !_init.value
              ? Center(child: CircularProgressIndicator())
              : _cart.isEmpty
                  ? Center(child: Text("سبد خرید شما خالی است."))
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _cart.keys.length,
                          itemBuilder: (c, i) {
                            var cart = _cart.values.toList()[i];
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                      label: Text(
                                        "فروشگاه \t" + cart.shopId,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                  child: Container(
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     border: Border.all()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                "قیمت :" +
                                                    cart.price.toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Row(
                                                children: [
                                                  Text("مقدار:" +
                                                      "\t" +
                                                      cart.amount.toString() +
                                                      "\t" +
                                                      (_shopService.units[
                                                              cart.item] ??
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
                                                        _cart.keys.toList()[i]);
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
                          }),
                    ))),
    );
  }

  Future<void> _handeBuyByCredit(BuildContext context) async {
    if (_havingEnoughCredit()) {
      await _buy("پرداخت از اعتبار");
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("اعتبار شما کافی نمی باشد!"),
                  Row(
                    children: [
                      Text("اعتیار شما:"),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        _autService.remainCredit.value,
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("قیمت کالاها:"),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        getCartPrice().toString() + "\t" + "تومان",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.pop(c);
                      Get.to(() => WalletPage());
                    },
                    child: Text(
                      "افزایش اعتبار",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(c);
                    },
                    child: Text("بستن", style: TextStyle(color: Colors.white)))
              ],
            );
          });
    }
  }

  Future<void> _buy(String paymentType) async {
    if (await _shopService.saveTransaction(
        items: _cart.values.toList(), paymentType: paymentType)) {
      _shopRepo.deleteAllCarts();
    }
  }
}
