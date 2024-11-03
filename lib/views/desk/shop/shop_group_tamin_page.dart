import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/views/desk/shop/cart_page.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:frappe_app/db/cart.dart' as ca;

class ShopGroupTaminPage extends StatefulWidget {
  ShopItemBaseModel group;

  ShopGroupTaminPage(this.group);

  @override
  State<ShopGroupTaminPage> createState() => _ShopGroupTaminPageState();
}

class _ShopGroupTaminPageState extends State<ShopGroupTaminPage> {
  var _shopService = GetIt.I.get<ShopService>();
  var _shopRepo = GetIt.I.get<ShopRepo>();
  final _formKey = GlobalKey<FormState>();

  var _amountController = TextEditingController();
  RxList<ShopTamin> filteredItems = RxList();
  final _inSearch = true.obs;
  List<ShopTamin> items = [];
  TextEditingController _controller = TextEditingController();
  var _hasText = false.obs;
  List<ca.Cart> _carts = [];

  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    _streamSubscription = _shopRepo.watchCarts().listen((_) {
      _carts = _.values.toList();
    });
    _shopService.fetchAllItemsUnit();
    _shopService.fetchShopTamin(widget.group.name).then((_) {
      items = _;
      filteredItems.addAll(items);
      _inSearch.value = false;
    });

    _controller.addListener(() {
      var t = _controller.text;
      _hasText.value = t.isNotEmpty;
      if (t.isNotEmpty) {
        filteredItems.clear();
        filteredItems
            .addAll(items.where((element) => element.name.contains(t)));
      } else {
        filteredItems.clear();
        filteredItems.addAll(items);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "تامین کننده های " + widget.group.name,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => _inSearch.isFalse
            ? Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        suffixIcon: Obx(() => _hasText.isTrue
                            ? IconButton(
                                onPressed: () {
                                  _controller.clear();
                                },
                                icon: Icon(CupertinoIcons.clear_circled),
                              )
                            : SizedBox.shrink()),
                        labelText: "جستجو",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (filteredItems.isNotEmpty)
                    StreamBuilder<Map<String, ca.Cart>>(
                        stream: _shopRepo.watchCarts(),
                        builder: (context, snapshot) {
                          var carts = snapshot.data ?? {};
                          return Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              controller: ScrollController(),
                              itemBuilder: (c, i) {
                                final item = filteredItems[i];
                                String id = item.parent +
                                    widget.group.name +
                                    item.price.toString();
                                bool isInCarts = carts.keys.contains(id);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 110,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black54,
                                            spreadRadius: 0,
                                            blurRadius: 1,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                        border:
                                            Border.all(color: Colors.blueGrey),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            item.name,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "موجودی: ",
                                                style: TextStyle(
                                                    color: Colors.black54),
                                              ),
                                              Text(
                                                item.amount.toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                _shopService.units[
                                                        widget.group.name] ??
                                                    "",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    " قیمت :",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black54),
                                                  ),
                                                  Text(item.price.toString() +
                                                      "\t" +
                                                      "تومان"),
                                                ],
                                              ),
                                              if (item.amount > 0 &&
                                                  item.price > 0)
                                                if (isInCarts)
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      _shopRepo.deleteCart(id);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      child: Container(
                                                          width: 140,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              color:
                                                                  Colors.red),
                                                          child: Center(
                                                            child: Text(
                                                              "حذف از سبد خرید",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11),
                                                            ),
                                                          )),
                                                    ),
                                                  )
                                                else
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      if (_carts.isNotEmpty &&
                                                          _carts.last.shopId !=
                                                              item.parent) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (c) {
                                                              return AlertDialog(
                                                                content: Text(
                                                                    "سبد خرید شما شامل کالا هایی از یک فروشنده دیگر است ابتدا با مراجعه به سبد کالا معاملات قبلی را نهایی کنید"),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors
                                                                              .blue),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator
                                                                            .pop(c);
                                                                        Get.to(() =>
                                                                            CartPage());
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "انجام معاملات سبد خرید",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                ],
                                                              );
                                                            });
                                                      } else {
                                                        items[i];
                                                        Get.bottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            bottomSheetTemplate(
                                                                Container(
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  child: Form(
                                                                    key:
                                                                        _formKey,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text(
                                                                              "خرید" + "\t" + widget.group.name,
                                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                validator: (c) {
                                                                                  if (c == null || c.isEmpty) {
                                                                                    return "مقدار درخواستی را وارد کنید";
                                                                                  }
                                                                                  if (double.parse(c) == 0) {
                                                                                    return "مقدار درخواستی معتبر نیست.";
                                                                                  }
                                                                                  if (int.parse(c) > item.amount.floor()) {
                                                                                    return "مقدار درخواستی از موجودی کالا بیشتر است.";
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                controller: _amountController,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: InputDecoration(
                                                                                    label: Text("مقدار درخواستی"),
                                                                                    border: OutlineInputBorder(
                                                                                      borderSide: const BorderSide(width: 3, color: Colors.red),
                                                                                      //<-- SEE HERE
                                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                                    ),
                                                                                    suffix: Text(
                                                                                      _shopService.units[widget.group.name] ?? "",
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextField(
                                                                                decoration: InputDecoration(
                                                                                  label: Text("کد تخفیف"),
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide: const BorderSide(width: 3, color: Colors.red),
                                                                                    //<-- SEE HERE
                                                                                    borderRadius: BorderRadius.circular(20.0),
                                                                                  ),
                                                                                  // suffix: Text(_shopService
                                                                                  //     .units[info.name] ??
                                                                                  //     "")
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (_formKey.currentState?.validate() ??
                                                                                false) {
                                                                              Navigator.pop(c);
                                                                              ca.Cart cart = ca.Cart(
                                                                                item: widget.group.name,
                                                                                shopOwner: item.parent,
                                                                                time: DateTime.now().millisecondsSinceEpoch,
                                                                                shopId: item.parent,
                                                                                amount: double.parse(_amountController.text),
                                                                                price: item.price,
                                                                              );
                                                                              _shopRepo.saveCart(cart);
                                                                              _amountController.clear();
                                                                            }
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                            child: Container(
                                                                                width: Get.width,
                                                                                height: 40,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), gradient: LinearGradient(colors: GRADIANT_COLOR)),
                                                                                child: Center(
                                                                                    child: Text(
                                                                                  "افزودن به سبد خرید",
                                                                                  style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
                                                                                ))),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )));
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8),
                                                      child: Container(
                                                          width: 140,
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
                                                            style: Get.textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        11),
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox();
                              },
                            ),
                          );
                        })
                  // Expanded(
                  //   child: ListView.separated(
                  //     itemCount: filteredItems.length,
                  //     itemBuilder: (c, i) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ShopItemTaminPage(filteredItems[i], widget.group),
                  //       );
                  //     },
                  //     separatorBuilder: (BuildContext context, int index) {
                  //       return Divider();
                  //     },
                  //   ),
                  // )
                  else
                    Text(" نتیجه ای یافت نشده است!"),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              )),
      ),
    );
  }
}
