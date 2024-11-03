import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/utils/shop_utils.dart';
import 'package:frappe_app/views/desk/shop/new_shop_item_page.dart';
import 'package:frappe_app/widgets/AvatarWidget.dart';

import 'package:frappe_app/widgets/constant.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ShopInfoPage extends StatefulWidget {
  ShopInfo shopInfo;

  ShopInfoPage(this.shopInfo);

  @override
  State<ShopInfoPage> createState() => _ShopInfoPageState();
}

class _ShopInfoPageState extends State<ShopInfoPage> {
  var _shopService = GetIt.I.get<ShopService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        floatingActionButton: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Get.to(() => NewShopItemPage(
                      shopInfo: widget.shopInfo,
                      onAdd: (_) {
                        widget.shopInfo.items.add(_);
                        setState(() {});
                      },
                    ));
              },
              child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: GRADIANT_COLOR)),
                  child: Center(
                      child: Text(
                    "محصول جدید",
                    style:
                        Get.textTheme.bodyLarge?.copyWith(color: Colors.white,fontSize: 13),
                  ))),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            widget.shopInfo.name,
            style: TextStyle(fontSize: 14),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Text("از حذف فروشگاه مطمنید؟"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(_);
                                    },
                                    child: Text("لغو")),
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(_);
                                      // await _autService.logout();
                                      // Get.offAll(() => Login());
                                    },
                                    child: Text(
                                      "بله",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        children: [
                          Text(
                            "حذف فروشگاه",
                            style: TextStyle(color: Colors.red,fontSize: 12),
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
        body: Container(
          height: Get.height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // AvatarWidget(
                  //   isCircular: false,
                  //   avatar: _shopService.shopImage,
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: "محصولات",
                        labelStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Get.width * 0.23,
                              child: Text(
                                "کالا",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.17,
                              child: Text(
                                "موجودی",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 8),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: Get.width * 0.19,
                                child: Center(
                                  child: Text(
                                    "قیمت",
                                    style: TextStyle(

                                        fontSize: 8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.16,
                              child: Center(
                                child: Text(
                                  "ویرایش",
                                  style: TextStyle(
                                       fontSize: 8),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.12,
                              child: Text(
                                "توضیحات",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 7),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: Get.height*0.6,
                          child: ListView.separated(
                            controller: ScrollController(),
                             shrinkWrap: true,
                            itemCount: widget.shopInfo.items.length,
                            itemBuilder: (c, i) {
                              var item = widget.shopInfo.items[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  height: 70,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.23,
                                        child: Text(
                                          item.name,
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.17,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Text(item.amount.toString() + "\t",
                                                  style: TextStyle(fontSize: 10)),
                                              Text(
                                                  (_shopService.units[item] ??
                                                      ""),
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.black87)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.18,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                NumberFormat.decimalPattern()
                                                    .format(item.price),
                                                style: TextStyle(fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.16,
                                        child: GestureDetector(
                                            onTap: () {
                                              ShopItemModel shop =
                                                  new ShopItemModel(
                                                      name: item.name,
                                                      id: "id",
                                                      group: "group",
                                                      price:
                                                          item.price.toString());
                                              showEdit(shop);
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: 12,
                                              color: Colors.black,
                                            )),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.11,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('توضیحات آیتم'),
                                                  content: Text(item.description),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('بستن'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.info,
                                            size: 14,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void showEdit(ShopItemModel shopItemModel) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: GRADIANT_COLOR),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "ویرایش محصول ",
                            style: Get.textTheme.bodyLarge,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ShopUtils.shopItemSelector((p0) {
                            // shopItemServerModel.value = p0;
                          },
                              ShopItemServerModel(
                                  name: shopItemModel.name, id: "", group: "")),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              TextField(
                                controller: TextEditingController(
                                    text: shopItemModel.price),
                                keyboardType: TextInputType.text,
                                onChanged: (_) {
                                  // name_dam = _;
                                },
                                decoration: InputDecoration(
                                  labelText: "قیمت",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                onChanged: (_) {
                                  // name_dam = _;
                                },
                                decoration: InputDecoration(
                                  labelText: "توضیحات",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          // if (shopItemServerModel.value == null) {
                          //   Fluttertoast.showToast(
                          //       msg: "محصول مورد نظر را انتخاب کنید");
                          // }
                          // if (s.isNotEmpty) {
                          //   _selectedCity.value = s;
                          //   _autService.saveSelectedCity(_selectedCity.value);
                          //   _autService.weathers.clear();
                          //   _getWeather();
                          //   Navigator.pop(context);
                          // } else if (_autService.getSelectedCity().isNotEmpty) {
                          //   Navigator.pop(context);
                          // }
                        },
                        child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient:
                                    LinearGradient(colors: GRADIANT_COLOR)),
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              "ثبت",
                              style: Get.textTheme.bodyLarge
                                  ?.copyWith(fontSize: 23)
                                  ?.copyWith(color: Colors.black),
                            ))),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
