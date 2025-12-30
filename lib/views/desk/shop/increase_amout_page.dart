import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/new_item.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/db/shop_item_tamin_info.dart';
import 'package:frappe_app/model/store_data.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../model/product_type.dart';
import '../../../model/ware_house.dart';
import '../../../widgets/constant.dart';
import '../../../widgets/form/CustomTextFormField.dart';

class IncreaseAmountPage extends StatelessWidget {
  StoreData storeData;

  IncreaseAmountPage({required this.storeData, required this.onAdd});

  Function(ShopItemTaminInfo) onAdd;

  Rx<ShopItemBaseModel?> _infoModel = Rxn();
  Rxn<ProductType> _productType = Rxn<ProductType>();
  var _shopService = GetIt.I.get<ShopService>();

  final _descriptionError = Rxn<String>();
  Rx<NewItem> _newItem = NewItem().obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  WarehouseItem? _warehouse = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            if (_formKey.currentState?.validate() ?? false) {
              FocusScope.of(context).requestFocus(new FocusNode());
              Progressbar.showProgress();
              if (await _shopService.increaseShopItem(
                  id: storeData.id,
                  newItem: _newItem.value,
                  warehouse: _warehouse!.name)) {
                Fluttertoast.showToast(msg: "افزایش موجودی انجام شد.");
                Get.back();
              }
              Progressbar.dismiss();
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
      appBar: appSliverAppBar("افزایش موجودی"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                              height: 10,
                            ),
                            FutureBuilder(
                                future: _shopService
                                    .getWarehouseSupplier(storeData.id),
                                builder: (context, asyncSnapshot) {
                                  if (asyncSnapshot.hasData &&
                                      asyncSnapshot.data != null &&
                                      asyncSnapshot.data!.isNotEmpty) {
                                    return SizedBox(
                                        height: 70,
                                        child: DropdownSearch<WarehouseItem>(
                                          validator: (_) {
                                            if (_ == null) {
                                              return "انبار مورد نظر را انتخاب کنید.";
                                            }
                                            return null;
                                          },
                                          popupProps: PopupProps.menu(
                                            searchDelay:
                                                Duration(milliseconds: 40),

                                            showSelectedItems: true,
                                            showSearchBox: true,

                                            fit: FlexFit.tight,

                                            // disabledItemFn: (String s) => s.startsWith('I'),
                                          ),
                                          items: (_, __) => asyncSnapshot.data!
                                              .map((e) => e)
                                              .toList(),
                                          itemAsString: (item) =>
                                              item.warehouseName ?? '',
                                          compareFn: (item1, item2) =>
                                              item1.warehouseName ==
                                              item2.warehouseName,
                                          decoratorProps:
                                              DropDownDecoratorProps(
                                            decoration: InputDecoration(
                                              labelText: "انبار",
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red),
                                                //<-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          onChanged: (_) {
                                            if (_ != null) {
                                              _warehouse = _;
                                            }
                                          },
                                          selectedItem: _warehouse,
                                        ));
                                  } else if (asyncSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Center(
                                      child: Text("انباری پیدا نشده است."));
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<ProductType>(
                                decoration: InputDecoration(
                                  labelText: "گروه کالا",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: ProductType.values
                                    .map((e) => DropdownMenuItem<ProductType>(
                                          value: e,
                                          child: Text(e.label),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _productType.value = value;
                                },
                                validator: (_) {
                                  if (_ == null) {
                                    return "کالا مورد نظر را انتخاب کنید.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Obx(() => _productType.value != null
                                    ? FutureBuilder(
                                        future:
                                            _shopService.fetchShopGroupItems(
                                                _productType.value!.label),
                                        builder: (c, s) {
                                          if (s.hasData &&
                                              s.data != null &&
                                              s.data!.isNotEmpty) {
                                            return SizedBox(
                                                height: 70,
                                                child: Obx(() => DropdownSearch<
                                                        ShopItemBaseModel>(
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
                                                          .map((e) => e)
                                                          .toList(),
                                                      itemAsString: (item) =>
                                                          item.name ?? '',
                                                      compareFn:
                                                          (item1, item2) =>
                                                              item1.name ==
                                                              item2.name,
                                                      validator: (_) {
                                                        if (_ == null) {
                                                          return "محصول مورد نظر را انتخاب کنید.";
                                                        }
                                                        return null;
                                                      },
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
                                                        if (_ != null) {
                                                          _infoModel.value = _;
                                                          _newItem.value
                                                                  .itemCode =
                                                              _.name;
                                                        }
                                                      },
                                                      selectedItem:
                                                          _infoModel.value,
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
                                Obx(() => _infoModel.value != null
                                    ? Column(
                                        children: [
                                          if (_infoModel
                                              .value!.damType.isNotEmpty)
                                            Column(
                                              children: [
                                                FutureBuilder(
                                                    future: _shopService
                                                        .fetchBreeds(_infoModel
                                                            .value!.damType),
                                                    builder: (c, s) {
                                                      if (s.hasData &&
                                                          s.data != null &&
                                                          s.data!.isNotEmpty) {
                                                        return SizedBox(
                                                            height: 70,
                                                            child: Obx(() =>
                                                                DropdownSearch<
                                                                    String>(
                                                                  popupProps:
                                                                      PopupProps
                                                                          .menu(
                                                                    searchDelay:
                                                                        Duration(
                                                                            milliseconds:
                                                                                40),

                                                                    showSelectedItems:
                                                                        true,
                                                                    showSearchBox:
                                                                        true,
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    // disabledItemFn: (String s) => s.startsWith('I'),
                                                                  ),
                                                                  items: (_, __) => s
                                                                      .data!
                                                                      .map(
                                                                          (e) =>
                                                                              e)
                                                                      .toList(),
                                                                  itemAsString:
                                                                      (item) =>
                                                                          item ??
                                                                          '',
                                                                  // compareFn:
                                                                  //     (item1, item2) =>
                                                                  // item1.name ==
                                                                  //     item2.name,
                                                                  decoratorProps:
                                                                      DropDownDecoratorProps(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "نژاد",
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.red),
                                                                        //<-- SEE HERE
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onChanged:
                                                                      (_) {
                                                                    if (_ !=
                                                                        null) {
                                                                      _newItem
                                                                          .value
                                                                          .breed = _;
                                                                    }
                                                                  },
                                                                  selectedItem:
                                                                      _newItem
                                                                          .value
                                                                          .breed,
                                                                )));
                                                      } else if (s
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      }
                                                      return Center(
                                                          child: Text(
                                                              "دریافت لیست نژاد با خطا مواجه شده است!"));
                                                    }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          if (_productType.value ==
                                              ProductType.dam)
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "حداقل قیمت را وارد کنید.";
                                                }
                                                return null;
                                              },
                                              onChanged: (_) {
                                                _newItem.value.minPrice =
                                                    double.parse(
                                                        _.replaceAll(",", ""));
                                              },
                                              inputFormatters: [
                                                NumberWithCommaFormatter()
                                              ],
                                              decoration: InputDecoration(
                                                labelText: "حداقل قیمت",
                                                suffix: Text("ریال"),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            onChanged: (_) {
                                              _newItem.value.maxPrice =
                                                  double.parse(
                                                      _.replaceAll(",", ""));
                                            },
                                            inputFormatters: [
                                              NumberWithCommaFormatter()
                                            ],
                                            validator: (_) {
                                              if (_ == null || _.isEmpty) {
                                                return "حداکثر قیمت را وارد کنید.";
                                              }
                                              if (_productType.value ==
                                                  ProductType.nahada) {
                                                return null;
                                              }
                                              if (_newItem.value.minPrice >
                                                  _newItem.value.maxPrice) {
                                                return "حداکثر قیمت نمی تواند از حداکثر قیمت بیشتر باشد.";
                                              }
                                              if (!(_newItem.value.maxPrice <=
                                                  _newItem.value.minPrice *
                                                      1.10)) {
                                                return "حداکثر قیمت باید حداکثر  ۱۰ درصد از حداقل قیمت بیشتر باشد";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: "حداکثر قیمت",
                                              suffix: Text("ریال"),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Obx(() => TextFormField(
                                                validator: (_) {
                                                  if (_ == null || _.isEmpty) {
                                                    return "مقدار حجم نمی تواند خالی باشد";
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  NumberWithCommaFormatter()
                                                ],
                                                onChanged: (_) {
                                                  _newItem.value.quantity =
                                                      int.parse(_.replaceAll(
                                                          ",", ""));
                                                },
                                                decoration: InputDecoration(
                                                  suffix: Text(
                                                      _shopService.units[
                                                              _infoModel.value
                                                                  ?.name] ??
                                                          ""),
                                                  labelText:
                                                      _productType.value ==
                                                              ProductType.dam
                                                          ? "تعداد"
                                                          : "حجم",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (_infoModel
                                              .value!.damType.isNotEmpty)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    decoration: InputDecoration(
                                                      labelText: "وضعیت آبستن",
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 2,
                                                                color:
                                                                    Colors.red),
                                                        //<-- SEE HERE
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    items: [
                                                      "آبستن ۱ تا ۳ ماه",
                                                      "آبستن بیشتر از ۳ ماه"
                                                    ]
                                                        .map((e) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: e,
                                                              child: Text(e),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        _newItem.value
                                                            .pregnancy = value;
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Obx(() => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child:
                                                                Text("بره دار"),
                                                          ),
                                                          Checkbox(
                                                            value: _newItem
                                                                .value.withLamb,
                                                            onChanged:
                                                                (bool? value) {
                                                              _newItem.value
                                                                      .withLamb =
                                                                  (value ??
                                                                      false);
                                                              _newItem
                                                                  .refresh();
                                                            },
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          TextFormField(
                                            validator: (_) {
                                              if (_ == null || _.isEmpty) {
                                                return "توضیحات نمی تواند خالی باشد";
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.text,
                                            onChanged: (value) {
                                              _newItem.value.description =
                                                  value;
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
                                            height: 10,
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
