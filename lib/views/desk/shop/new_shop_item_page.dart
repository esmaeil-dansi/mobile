import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/shop_Item_model.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../widgets/constant.dart';

class NewShopItemPage extends StatelessWidget {
  final _group = "".obs;
  Rxn<String> _item = Rxn();
  var _shopService = GetIt.I.get<ShopService>();
  Rxn<ShopItemServerModel> shopItemServerModel = Rxn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (shopItemServerModel.value == null) {
              Fluttertoast.showToast(msg: "محصول مورد نظر را انتخاب کنید");
            }
          },
          child: Container(
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(colors: GRADIANT_COLOR)),
              child: Center(
                  child: Text(
                "ثبت",
                style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
              ))),
        ),
      ),
      appBar: appSliverAppBar("اضافه کردن محصول جدید"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: GRADIANT_COLOR),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [

                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "گروه کالا",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "دام",
                                  "نهاده",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null && value != _group.value) {
                                    _item.value = null;
                                    _group.value = value;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Obx(() => _group.value.isNotEmpty
                                    ? FutureBuilder(
                                        future: _shopService
                                            .fetchShopGroupItems(_group.value),
                                        builder: (c, s) {
                                          if (s.hasData &&
                                              s.data != null &&
                                              s.data!.isNotEmpty) {
                                            return SizedBox(
                                                height: 70,
                                                child: Obx(() =>
                                                        DropdownSearch<String>(
                                                          popupProps:
                                                              PopupProps.menu(
                                                            searchDelay:
                                                                Duration(
                                                                    milliseconds:
                                                                        40),

                                                            showSelectedItems:
                                                                true,
                                                            showSearchBox: true,
                                                            fit: FlexFit.tight,
                                                            // disabledItemFn: (String s) => s.startsWith('I'),
                                                          ),
                                                          items: s.data!,
                                                          dropdownDecoratorProps:
                                                              DropDownDecoratorProps(
                                                            dropdownSearchDecoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "محصول",
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        width:
                                                                            2,
                                                                        color: Colors
                                                                            .red),
                                                                //<-- SEE HERE
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (_) {
                                                            _item.value = _;
                                                          },
                                                          selectedItem:
                                                              _item.value,
                                                        )

                                                    ));
                                          } else if (s.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Center(
                                              child:
                                                  Text("موردی یافت نشده است!"));
                                        })
                                    : SizedBox.shrink()),
                                Obx(() => _item.value != null
                                    ? Column(
                                        children: [
                                          TextField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (_) {
                                              // name_dam = _;
                                            },
                                            decoration: InputDecoration(
                                              labelText: "قیمت",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
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
                                            minLines: 2,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              labelText: "توضیحات",

                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink())
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
