import 'package:flutter/material.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/db/shop_item_tamin_info.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../widgets/constant.dart';

class NewShopItemPage extends StatelessWidget {
  ShopInfo shopInfo;

  NewShopItemPage({required this.shopInfo, required this.onAdd});

  Function(ShopItemTaminInfo) onAdd;

  final _group = "".obs;
  ShopItemBaseModel infoModel = ShopItemBaseModel(name: "", unit: "");
  Rxn<String> _item = Rxn();
  var _shopService = GetIt.I.get<ShopService>();
  ShopItemTaminInfo info = ShopItemTaminInfo();
  final _descriptionError = Rxn<String>();

  void _validateDescription(String value) {
    if (value.isEmpty) {
      _descriptionError.value = 'لطفاً این فیلد را پر کنید';
    } else {
      _descriptionError.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            FocusScope.of(context).requestFocus(new FocusNode());
            Progressbar.showProgress();
            if (info.description.isEmpty) {
              _descriptionError.value = 'لطفاً این فیلد را پر کنید';
            }
            if (await _shopService.addShopItem(
                shopInfo: shopInfo, info: info)) {
              onAdd(info);
              Get.back();
            }
            Progressbar.dismiss();
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                                    info.name = _item.value ?? "";
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
                                                        searchDelay: Duration(
                                                            milliseconds: 40),

                                                        showSelectedItems: true,
                                                        showSearchBox: true,
                                                        fit: FlexFit.tight,
                                                        // disabledItemFn: (String s) => s.startsWith('I'),
                                                      ),
                                                      items: (_, __) => s.data!
                                                          .map((e) => e.name)
                                                          .toList(),
                                                      decoratorProps:
                                                          DropDownDecoratorProps(
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "محصول",
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
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
                                                        info.name =
                                                            _item.value ?? "";
                                                      },
                                                      selectedItem: _item.value,
                                                    )));
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
                                              info.price = double.parse(_);
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
                                            keyboardType: TextInputType.number,
                                            onChanged: (_) {
                                              info.amount = double.parse(_);
                                            },
                                            decoration: InputDecoration(
                                              suffix: Text(_shopService
                                                      .units[_item.value] ??
                                                  ""),
                                              labelText: "موجودی",
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
                                            onChanged: (value) {
                                              info.description = value;
                                              _validateDescription(value);
                                            },
                                            minLines: 2,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                              labelText: "توضیحات",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              errorText:
                                                  _descriptionError.value,
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
