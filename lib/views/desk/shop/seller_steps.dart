import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/buyer_info.dart';
import 'package:frappe_app/model/sale_item.dart';
import 'package:frappe_app/model/store_data.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/utils/string_extension.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/services/sales_form_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;

import '../../../model/PurchaseItem.dart';
import '../../../model/sales_item_model.dart';
import '../../../model/ware_house.dart';
import '../../../widgets/buttomSheetTempelate.dart';
import '../desk_view.dart';

class SellerSteps extends StatelessWidget {
  final _salesFormService = SalesFormService();
  final _shopService = ShopService();

  final _nationalId = (kDebugMode ? "0123456789" : "").obs;
  final isOpen = false.obs;
  RxInt countdown = 60.obs;
  RxBool canResend = true.obs;
  RxBool smsIsSend = false.obs;
  Rxn<BuyerInfo> _buyerInfo = Rxn<BuyerInfo>();
  Rxn<StoreData> _storeData = Rxn<StoreData>();
  final _items = <SaleItem>[].obs;
  Rxn<WarehouseItem> _warehouse = Rxn();
  TextEditingController textEditingController =
      TextEditingController(text: kDebugMode ? "0123456789" : "");
  TextEditingController desTextEditingController =
      TextEditingController(text: "");
  String? smsCode;

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  value: _nationalId.value,
                  textEditingController: textEditingController,
                  label: "کد ملی خریدار",
                  textInputType: TextInputType.number,
                  prefix: GestureDetector(
                      onTap: () {
                        textEditingController.clear();
                        _nationalId.value = "";
                        _storeData.value = null;
                        _buyerInfo.value = null;
                      },
                      child: Icon(Icons.clear)),
                  onChanged: (_) {
                    _nationalId.value = _;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => _buyerInfo.value == null
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _nationalId.value.length == 10
                              ? () async {
                                  var result = await _salesFormService
                                      .fetchBuyerInfo(_nationalId.value);
                                  if (result != null) {
                                    _buyerInfo.value = result;
                                  }
                                }
                              : null,
                          child: Text("استعلام",
                              style: const TextStyle(fontSize: 16)),
                        ),
                      )
                    : Column(
                        children: [
                          stepBuyerInfo(),
                          SizedBox(
                            height: 10,
                          ),
                          stepSellerSelection(),
                          if (_storeData.value != null)
                            Column(
                              children: [
                                _selectWarehouse(),
                                if (_warehouse.value != null)
                                  Column(
                                    children: [
                                      _selectedItems(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        textEditingController:
                                            desTextEditingController,
                                        label: "توضیحات",
                                        maxLine: 3,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                        ],
                      )),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
        Obx(() => Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: _items.isEmpty || smsIsSend.value
                          ? null
                          : () async {
                              smsIsSend.value = true;
                              final ok = await _salesFormService.sendSmsCode(
                                  _buyerInfo.value!.nationalId,
                                  _getItemsAsString());
                              smsIsSend.value = false;
                              if (ok) {
                                canResend.value = false;
                                _startTimer();
                                showCodeInput();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "خطایی در ارسال کد تایید رخ داده است");
                              }
                            },
                      child: Container(
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: !smsIsSend.value
                              ? Center(
                                  child: Text(
                                  "دریافت کد تایید",
                                  style: TextStyle(color: Colors.white),
                                ))
                              : SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator()))),
                ),
              ),
            ))
      ],
    );
  }

  Widget stepSellerSelection() {
    return FutureBuilder<List<StoreData>>(
      future: _shopService.fetchStores(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return buildStepWrapper(
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return SizedBox(
            height: 70,
            child: DropdownSearch<StoreData>(
                popupProps: PopupProps.menu(
                  searchDelay: Duration(milliseconds: 40),
                  showSelectedItems: true,
                  showSearchBox: true,
                  fit: FlexFit.tight,
                ),
                items: (_, __) => snapshot.data!.map((e) => e).toList(),
                itemAsString: (item) => item.storeName ?? "",
                compareFn: (item1, item2) => item1.storeName == item2.storeName,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "انتخاب فروشنده",
                    labelStyle: TextStyle(fontSize: 13, color: Colors.black38),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2, color: Colors.red),
                      //<-- SEE HERE
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onChanged: (_) {
                  if (_ != null) {
                    _storeData.value = _;
                  }
                },
                selectedItem: _storeData.value));
      },
    );
  }

  Widget stepBuyerInfo() {
    return InputDecorator(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: "اطلاعات خریدار",
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              isOpen.value = !isOpen.value;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_buyerInfo.value!.province +
                    "-" +
                    _buyerInfo.value!.fullName),
                GestureDetector(
                    onTap: () {
                      isOpen.value = !isOpen.value;
                    },
                    child: Icon(!isOpen.value
                        ? Icons.keyboard_double_arrow_down
                        : Icons.keyboard_double_arrow_up))
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isOpen.value
                ? buildStepWrapper(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          _buildInfoRow("نام", _buyerInfo.value!.fullName),
                          const Divider(),
                          _buildInfoRow("استان", _buyerInfo.value!.province),
                          const Divider(),
                          _buildInfoRow("شهر", _buyerInfo.value!.city),
                          const Divider(),
                          _buildInfoRow("کد ملی", _buyerInfo.value!.nationalId),
                          const Divider(),
                          _buildInfoRow(
                              "شماره موبایل", _buyerInfo.value!.mobile),
                          const Divider(),
                          _buildInfoRow(
                              "باقیمانده اعتبار",
                              _formatPrice(
                                  _buyerInfo.value?.customRemainLoan ?? 0)),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 0),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Widget buildStepWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 14)),
        ),
        Expanded(
          child: Text(value ?? "نامشخص",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _selectWarehouse() {
    return FutureBuilder(
        future: _shopService.getWarehouseSupplier(_storeData.value!.id),
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
                    searchDelay: Duration(milliseconds: 40),

                    showSelectedItems: true,
                    showSearchBox: true,

                    fit: FlexFit.tight,
                    // disabledItemFn: (String s) => s.startsWith('I'),
                  ),
                  items: (_, __) => asyncSnapshot.data!.map((e) => e).toList(),
                  compareFn: (item1, item2) =>
                      item1.warehouseName == item2.warehouseName,
                  itemAsString: (item) => item.warehouseName ?? '',
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: "انبار",
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.red),
                        //<-- SEE HERE
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onChanged: (_) {
                    if (_ != null) {
                      _warehouse.value = _;
                    }
                  },
                  selectedItem: _warehouse.value,
                ));
          } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(child: Text("انباری پیدا نشده است."));
        });
  }

  Widget _selectedItems() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InputDecorator(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: "کالا ها",
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          child: Column(
            children: [
              Obx(() => LimitedBox(
                    maxHeight: Get.context!.height / 3,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _items.length,
                      itemBuilder: (c, i) {
                        var item = _items.value[i];
                        return Container(
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(item.itemCode),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "مقدار:" +
                                            "\t" +
                                            item.quantity.toString() +
                                            "\t" +
                                            item.unit,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "سند:" + "\t" + item.purchaseDoc,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "قیمت واحد:" +
                                            "\t" +
                                            _formatPrice(
                                                    item.salePrice.toDouble())
                                                .toString(),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "جمع کل:" +
                                            "\t" +
                                            (_formatPrice((item.salePrice *
                                                        item.quantity)
                                                    .toDouble()))
                                                .toString(),
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _items.value.remove(item);
                                        _items.refresh();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 15,
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // IconButton(
                                  //     onPressed: () {
                                  //       _addOrEditItem(Get.context!,
                                  //           item: item, i: i);
                                  //     },
                                  //     icon: Icon(
                                  //       Icons.edit,
                                  //       size: 15,
                                  //     )),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    _addOrEditItem(Get.context!);
                  },
                  child: Text(" اضافه کردن کالا جدید +")),
              SizedBox(
                height: 14,
              ),
              if (_items.isNotEmpty)
                CustomTextFormField(
                  value: _formatPrice(sumItems()).toString(),
                  prefix: Text("ریال"),
                  readOnly: true,
                  label: "جمع کل",
                ),
            ],
          )),
    );
  }

  double sumItems() {
    double sum = 0;
    _items.forEach((item) {
      sum = sum + (item.quantity * item.salePrice).toDouble();
    });
    return sum;
  }

  void _addOrEditItem(BuildContext context, {SaleItem? item, int? i}) {
    final _salesItemModel = Rxn<SalesItemModel>();
    final _formKey = GlobalKey<FormState>();
    TextEditingController _amountController = TextEditingController();
    TextEditingController _priceTextController = TextEditingController();
    SaleItem newItem = SaleItem();
    Rxn<PurchaseItem> purchaseItem = Rxn();
    final loading = false.obs;
    if (item != null) {
      newItem = item;
    }
    Get.bottomSheet(
        isScrollControlled: true,
        bottomSheetTemplate(Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(''),
                  SizedBox(
                    height: Get.height * 0.6,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        FutureBuilder<List<SalesItemModel>>(
                          future: _salesFormService.fetchItems(),
                          builder: (_, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final items = snapshot.data!;
                            return Column(
                              children: [
                                SizedBox(
                                    height: 70,
                                    child: DropdownSearch<SalesItemModel>(
                                        popupProps: PopupProps.menu(
                                          searchDelay:
                                              Duration(milliseconds: 40),

                                          showSelectedItems: true,
                                          showSearchBox: true,
                                          fit: FlexFit.tight,
                                          // disabledItemFn: (String s) => s.startsWith('I'),
                                        ),
                                        items: (_, __) => items,
                                        itemAsString: (item) =>
                                            item.itemName ?? '',
                                        compareFn: (item1, item2) =>
                                            item1.itemName == item2.itemName,
                                        decoratorProps: DropDownDecoratorProps(
                                          decoration: InputDecoration(
                                            labelText: "انتخاب کالا",
                                            labelStyle: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black38),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 2, color: Colors.red),
                                              //<-- SEE HERE
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        onChanged: (_) {
                                          if (_ != null) {
                                            _salesItemModel.value = _;
                                          }
                                        },
                                        selectedItem: _salesItemModel.value)),
                                SizedBox(
                                  height: 10,
                                ),
                                Obx(() => _salesItemModel.value != null
                                    ? Column(
                                        children: [
                                          SizedBox(
                                              height: 70,
                                              child: FutureBuilder(
                                                  future: _salesFormService
                                                      .fetchPurchaseDocuments(
                                                          _salesItemModel
                                                              .value!.itemName,
                                                          _warehouse
                                                              .value!.name),
                                                  builder:
                                                      (context, asyncSnapshot) {
                                                    if (asyncSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return SizedBox(
                                                          height: 4,
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                    if (!snapshot.hasData ||
                                                        snapshot
                                                            .data!.isEmpty) {
                                                      return Text(
                                                          "سندی یافت نشده است!");
                                                    }
                                                    final items =
                                                        asyncSnapshot.data!;
                                                    return DropdownSearch<
                                                            PurchaseItem>(
                                                        popupProps:
                                                            PopupProps.menu(
                                                          searchDelay: Duration(
                                                              milliseconds: 40),

                                                          showSelectedItems:
                                                              true,
                                                          showSearchBox: true,
                                                          fit: FlexFit.tight,
                                                          // disabledItemFn: (String s) => s.startsWith('I'),
                                                        ),
                                                        items: (_, __) => items,
                                                        itemAsString: (item) =>
                                                            "قیمت فروش:" +
                                                                _formatPrice(item
                                                                        .salePrice
                                                                        .toDouble())
                                                                    .toString() +
                                                                "/" +
                                                                "موجودی:" +
                                                                item.remainQuantity
                                                                    .toString() ??
                                                            '',
                                                        compareFn: (item1,
                                                                item2) =>
                                                            item1.itemCode ==
                                                            item2.itemCode,
                                                        decoratorProps:
                                                            DropDownDecoratorProps(
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "انتخاب سند خرید",
                                                            labelStyle: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black38),
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
                                                            purchaseItem.value =
                                                                _;
                                                          }
                                                        },
                                                        selectedItem:
                                                            purchaseItem.value);
                                                  })),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: TextFormField(
                                              inputFormatters: [
                                                NumberWithCommaFormatter()
                                              ],
                                              validator: (_) {
                                                if (_ == null || _.isEmpty) {
                                                  return "مقدار را وارد کنید";
                                                }
                                                if (int.parse(_.replaceAll(
                                                        ",", "")) ==
                                                    0) {
                                                  return "مقدار باید بزرگتر از ۰ باشد.";
                                                }
                                                if (purchaseItem.value !=
                                                    null) {
                                                  var value = int.parse(
                                                      _.replaceAll(',', ''));
                                                  if (value >
                                                      purchaseItem
                                                          .value!.quantity) {
                                                    return "مقدار درخواستی بیشتر از موجودی است!";
                                                  }
                                                }
                                                return null;
                                              },
                                              controller: _amountController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                suffixIcon: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8, left: 8),
                                                  child: Text(_salesItemModel
                                                      .value!.uom),
                                                ),
                                                labelText: "مقدار",
                                                labelStyle: TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 13),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (_salesItemModel.value != null &&
                                              _salesItemModel
                                                  .value!.damType.isNotEmpty)
                                            CustomTextFormField(
                                              useSeperator: true,
                                              textEditingController:
                                                  _priceTextController,
                                              onChanged: (_) {},
                                              // textInputFormatter:
                                              // NumberWithCommaFormatter(),
                                              label: "قیمت",
                                              prefix: Text('ریال'),
                                              textInputType:
                                                  TextInputType.number,
                                            ),
                                        ],
                                      )
                                    : SizedBox()),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: loading.value
                          ? null
                          : () async {
                              if (item != null) {
                                _items.value[i!] = newItem;
                              } else {
                                if (_formKey.currentState!.validate() ??
                                    false) {
                                  var price = _salesItemModel
                                          .value!.damType.isNotEmpty
                                      ? double.parse(_priceTextController.text
                                          .replaceAll(",", ""))
                                      : purchaseItem.value!.salePrice;
                                  if (_salesItemModel.value != null &&
                                      purchaseItem.value != null) {
                                    if (_salesItemModel
                                        .value!.damType.isNotEmpty) {
                                      if (_priceTextController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "قیمت را وارد کنید");
                                      } else if (int.parse(_priceTextController
                                              .text
                                              .replaceAll(",", "")) ==
                                          0) {
                                        Fluttertoast.showToast(
                                            msg: "قیمت باید بزرگتر از ۰ باشد");
                                      } else {
                                        loading.value = true;
                                        var res = await _shopService.checkPrice(
                                            purchase_doc:
                                                purchaseItem.value!.purchaseDoc,
                                            price: price.toDouble(),
                                            itemId: purchaseItem.value!.itemId);
                                        loading.value = false;
                                        if (res != null) {
                                          if (res.ok) {
                                            _items.add(SaleItem(
                                                unit:
                                                    _salesItemModel.value!.uom,
                                                itemCode: purchaseItem
                                                    .value!.itemCode,
                                                quantity: int.parse(
                                                    _amountController.text),
                                                itemId:
                                                    purchaseItem.value!.itemId,
                                                salePrice: price,
                                                purchaseDoc: purchaseItem
                                                    .value!.purchaseDoc));
                                            Navigator.pop(context);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (c) => AlertDialog(
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(c);
                                                          },
                                                          child: Text("فهمیدم"),
                                                        )
                                                      ],
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                              "قیمت وارد شده در بازه مجاز قرار ندارد!"),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                              "قیمت وارده: \t\t${_formatPrice(price.toDouble())}"),
                                                          Divider(),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "حداقل قیمت: \t\t"),
                                                              Text(_formatPrice(res
                                                                      .min
                                                                      .toDouble())
                                                                  .toString())
                                                            ],
                                                          ),
                                                          Divider(),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "حداکثر قیمت: \t\t"),
                                                              Text(_formatPrice(res
                                                                      .max
                                                                      .toDouble())
                                                                  .toString())
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "خطایی در چک کردن قیمت رخ داده است");
                                        }
                                      }
                                    } else {
                                      _items.add(SaleItem(
                                          unit: _salesItemModel.value!.uom,
                                          itemCode:
                                              _salesItemModel.value!.itemName,
                                          quantity:
                                              int.parse(_amountController.text),
                                          itemId:
                                              _salesItemModel.value!.itemName,
                                          salePrice:
                                              purchaseItem.value!.salePrice,
                                          purchaseDoc:
                                              purchaseItem.value!.purchaseDoc));
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              }
                            },
                      child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: loading.value
                              ? Center(
                                  child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator()))
                              : Center(
                                  child: Text(
                                  item != null ? "ویرایش" : "اضافه کردن",
                                  style: TextStyle(color: Colors.white),
                                ))))),
                ],
              ),
            ),
          ),
        )));
  }

  void showCodeInput() {
    TextEditingController _codeController = TextEditingController();
    Get.bottomSheet(buildStepWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.key_outlined,
            color: Colors.amber,
          ),
          SizedBox(
            height: 20,
          ),
          const Text(
            "تایید شماره موبایل",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _codeController,
            textAlign: TextAlign.center,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: "کد تایید",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 24),
          Obx(() => TextButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: canResend.value
                    ? () async {
                        try {
                          final ok = await _salesFormService.sendSmsCode(
                              _buyerInfo.value!.nationalId,
                              _getItemsAsString());
                          if (ok) {
                            Fluttertoast.showToast(msg: "کد ارسال شد");
                            canResend.value = false;
                            canResend.refresh();
                            _startTimer();
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    : null,
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text("ارسال مجدد در ${countdown.value} ثانیه"),
                  ),
                ),
              )),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () async {
                smsCode = _codeController.text;
                if (smsCode == null || smsCode!.isEmpty) {
                  Fluttertoast.showToast(msg: "کد تایید وارد نشده");
                  return;
                }
                try {
                  final ok = await _salesFormService.verifySmsCode(
                      smsCode!, _buyerInfo.value!.nationalId);
                  if (ok) {
                    Navigator.pop(Get.context!);
                    stepFinalSubmit(Get.context!);
                  } else
                    Fluttertoast.showToast(msg: "کد اشتباه است");
                } catch (e) {
                  Fluttertoast.showToast(msg: e.toString());
                }
              },
              child: SizedBox(height: 50, child: Center(child: Text("تایید")))),
          const SizedBox(height: 50),
        ],
      ),
    ));
  }

  String _getItemsAsString() {
    String result = "";
    _items.forEach((item) {
      result = result +
          item.quantity.toString() +
          "\t" +
          item.unit +
          "\t" +
          item.itemCode +
          "\t" +
          "به ارزش" +
          (item.quantity * item.salePrice).toString() +
          "\t" +
          "ریال" +
          "\n";
    });
    return result;
  }

  void stepFinalSubmit(BuildContext context) {
    var isLoading = false.obs;
    Get.bottomSheet(
      Obx(() => buildStepWrapper(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: Get.height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 📋 خلاصه اطلاعات
                        const Text(
                          "خلاصه اطلاعات فاکتور",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                  //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                label: Text("مشخصات خریدار")),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _buildSummaryRow("کد ملی",
                                    _buyerInfo.value?.nationalId ?? "نامشخص"),
                                _buildSummaryRow("نام",
                                    _buyerInfo.value?.fullName ?? "نامشخص"),
                                _buildSummaryRow("استان",
                                    _buyerInfo.value?.province ?? "نامشخص"),
                                _buildSummaryRow(
                                    "شهر", _buyerInfo.value?.city ?? "نامشخص"),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Seller + warehouse
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              label: Text("مشخصات فروش"),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.red),
                                //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                    "فروشنده", _storeData.value!.storeName),
                                _buildSummaryRow(
                                    "انبار", _warehouse.value!.warehouseName),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Buyer info
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                  //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                label: Text("اطلاعات مالی")),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _buildSummaryRow("اعتبار فعلی",
                                    "${_formatPrice(_buyerInfo.value?.customRemainLoan ?? 0)} ریال"),
                                _buildSummaryRow("جمع فاکتور",
                                    "${_formatPrice(sumItems())} ریال"),
                                _buildSummaryRow("باقیمانده اعتبار",
                                    "${_formatPrice(_calculateRemainingCredit())} ریال",
                                    color: _calculateRemainingCredit() < 0
                                        ? Colors.red
                                        : null),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Items
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: InputDecorator(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                  //<-- SEE HERE
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                label: Text("کالاهای انتخابی")),
                            child: LimitedBox(
                              maxHeight: 400,
                              child: ListView(
                                shrinkWrap: true,
                                children: _items
                                    .map(
                                      (e) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(e.itemCode,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text(
                                                  "${_formatPrice(e.salePrice.toDouble() * e.quantity)} ریال",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .green.shade700)),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text("تعداد: ${e.quantity}"),
                                          const SizedBox(height: 6),
                                          Text(e.purchaseDoc),
                                          const SizedBox(height: 6),
                                          Text(
                                              "قیمت واحد: ${_formatPrice(e.salePrice.toDouble())} ریال"),
                                          Divider(),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Description
                        if (desTextEditingController.text.isNotEmpty) ...[
                          buildStepWrapper(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("توضیحات",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(height: 8),
                                  Text(desTextEditingController.text),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        const SizedBox(height: 2),

                        // ✅ Final submit button OR loading
                      ],
                    ),
                  ),
                ),
                isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          isLoading.value = true;

                          try {
                            final List<Map<String, dynamic>> invoiceItems = [];

                            for (int i = 0; i < _items.length; i++) {
                              final item = _items[i];
                              invoiceItems.add(item.toJson());
                            }

                            final result =
                                await _salesFormService.finalSubmitInvoice(
                              nationalId: _buyerInfo.value!.nationalId,
                              supplierId: _storeData.value!.id,
                              warehouse: _warehouse.value!.name,
                              description: desTextEditingController.text,
                              items: invoiceItems,
                            );

                            if (result['code'] == '2000') {
                              Fluttertoast.showToast(msg: result['message']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DesktopView()),
                              );
                            } else {
                              Fluttertoast.showToast(msg: result['message']);
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "خطا در ثبت نهایی: ${e.toString()}");
                          } finally {
                            isLoading.value = false;
                          }
                        },
                        child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Center(child: Text("ثبت نهایی"))))
              ],
            ),
          )),
      isScrollControlled: true,
    );
  }

  double _calculateRemainingCredit() {
    return _buyerInfo.value!.customRemainLoan - sumItems();
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child:
                Text("$label:", style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: color != null
                    ? TextStyle(color: color, fontWeight: FontWeight.bold)
                    : null),
          ),
        ],
      ),
    );
  }

  _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value == 0) {
        canResend.value = true;
        timer.cancel(); // stop the timer
      } else {
        countdown.value--; // update countdown
      }
    });
  }
}

class NumberWithCommaFormatter extends TextInputFormatter {
  final _digitReg = RegExp(r'^[\u06F0-\u06F90-9,]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!_digitReg.hasMatch(newValue.text)) {
      return oldValue;
    }

    final raw = newValue.text.replaceFarsiNumber().replaceAll(',', '');

    if (raw.isEmpty) return newValue.copyWith(text: '');

    final formatted = _formNum(raw);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formNum(String s) {
    return intl.NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
}
