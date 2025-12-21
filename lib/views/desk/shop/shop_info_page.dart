import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/dao/shop_dao.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/model/store_data.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/utils/shop_utils.dart';
import 'package:frappe_app/views/desk/shop/increase_amout_page.dart';
import 'package:frappe_app/views/desk/shop/new_shop_item_page.dart';
import 'package:frappe_app/widgets/AvatarWidget.dart';

import 'package:frappe_app/widgets/constant.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../model/InventoryItem.dart';
import '../../../widgets/buttomSheetTempelate.dart';

class ShopInfoPage extends StatefulWidget {
  StoreData storeData;

  ShopInfoPage(this.storeData);

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
        // floatingActionButtonLocation: FloatingActionButtonLocation.,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Get.to(() => IncreaseAmountPage(
                        storeData: widget.storeData,
                        onAdd: (_) {
                          // widget.shopInfo.items.add(_);
                          // setState(() {});
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
                      "افزایش موجودی",
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(color: Colors.white, fontSize: 13),
                    ))),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            widget.storeData.storeName,
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
                            style: TextStyle(color: Colors.red, fontSize: 12),
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
                  FutureBuilder<Map<String, List<InventoryItem>>>(
                    future: _shopService
                        .getStockRemainChopooByWarehouse(widget.storeData.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("هیچ انباری موجود نیست"));
                      }

                      Map<String, List<InventoryItem>> warehouseMap =
                          snapshot.data!;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "انبارها",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: context.mediaQuery.size.height * 0.6,
                              child: ListView(
                                shrinkWrap: true,
                                children: warehouseMap.keys.map((warehouse) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        var items =
                                            warehouseMap[warehouse] ?? [];
                                        Get.bottomSheet(
                                            isScrollControlled: true,
                                            bottomSheetTemplate(
                                                _showItems(items)));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.shade300,
                                              Colors.blue.shade600
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 3,
                                                offset: Offset(2, 4))
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                warehouse,
                                                style: TextStyle(
                                                    overflow: TextOverflow.clip,
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                var items =
                                                    warehouseMap[warehouse] ??
                                                        [];

                                                Get.bottomSheet(
                                                    isScrollControlled: true,
                                                    bottomSheetTemplate(
                                                        _showItems(items)));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Icon(Icons.info_outline,
                                                    size: 18,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

  Widget _showItems(List<InventoryItem> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: "محصولات",
          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: SizedBox(
                height: Get.height * 0.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade300),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(2.0), // کالا
                      1: FlexColumnWidth(1.3), // موجودی
                      // 2: FlexColumnWidth(1.8), // انبار
                      3: FlexColumnWidth(1.4), // استان
                    },
                    children: [
                      /// ---------- HEADER ----------
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        children: [
                          _headerCell("کالا"),
                          _headerCell("موجودی"),
                          // _headerCell("انبار"),
                          _headerCell("استان"),
                        ],
                      ),

                      /// ---------- DATA ROWS ----------
                      ...items.map((item) {
                        return TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [
                            _cell(item.itemCode),
                            _cell(
                              "${item.currentActualQty} ${_shopService.units[item.itemCode] ?? ''}",
                            ),
                            // _cell(item.warehouse, maxLines: 4),
                            _cell(item.customProvince),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "بستن",
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _cell(String text, {int maxLines = 2}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10),
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
