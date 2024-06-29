import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/utils/shop_utils.dart';
import 'package:frappe_app/views/desk/shop/new_shop_item_page.dart';
import 'package:frappe_app/widgets/AvatarWidget.dart';

import 'package:frappe_app/widgets/constant.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class MyShopPage extends StatelessWidget {
  var _shopService = GetIt.I.get<ShopService>();
  var _autService = GetIt.I.get<AutService>();
  List<ShopItemModel> items = [
    ShopItemModel(name: "test1", price: "10000", group: "", id: ""),
    ShopItemModel(name: "test2", price: "12000", group: "", id: ""),
    ShopItemModel(name: "test3", price: "1300", group: "", id: ""),
    ShopItemModel(name: "test4", price: "1400", group: "", id: ""),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Get.to(() => NewShopItemPage());
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
                style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
              ))),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Text(
                          "حذف فروشگاه",
                          style: TextStyle(color: Colors.red),
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
        title: FutureBuilder<String>(
            initialData: _shopService.shopName(),
            future: _shopService.getShopName(_autService.getUserId()),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? "",
                style: TextStyle(
                    fontSize: 24,
                    color: MAIN_COLOR,
                    fontWeight: FontWeight.bold),
              );
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AvatarWidget(
                    isCircular: false,
                    avatar: _shopService.shopImage,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (items.isEmpty) Text("شما اقلامی برای فروش ندارید"),
                  SizedBox(
                    height: Get.height * 0.3,
                    child: InputDecorator(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: "محصولات",
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (c, i) {
                            var item = items[i];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all()),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.5,
                                          child: Text(
                                            item.name,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                        Text(item.price + "\t" + "تومان",
                                            style: TextStyle(fontSize: 12))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showEdit(item);
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Colors.black,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        content: Text(
                                                            "از حذف محصول مطمنید؟"),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    _);
                                                              },
                                                              child:
                                                                  Text("لغو")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.pop(
                                                                    _);
                                                                // await _autService.logout();
                                                                // Get.offAll(() => Login());
                                                              },
                                                              child: Text(
                                                                "بله",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )),
                                                        ],
                                                      ));
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 16,
                                              color: Colors.red,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
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
