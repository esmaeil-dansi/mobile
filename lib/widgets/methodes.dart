import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/shop_order_model.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/utils/date_mapper.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

void handleDioError(DioException e, {bool showInfo = true}) {
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout) {
    showDialog(
        context: Get.context!,
        builder: (c) {
          return AlertDialog(
            title: Text(
              "شبکه خود را بررسی کنید",
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            content: showInfo
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.greenAccent)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "درخواست شما ذخیره شد بعد از برقراری ارتباط با مراجعه به صفحه درخواست ها، می توانید درخواست خود دوباره ارسال کنید.",
                        style: TextStyle(fontSize: 17),
                      ),
                    ))
                : null,
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    FocusScope.of(c).unfocus();
                    Navigator.pop(c);
                    Future.delayed(Duration(milliseconds: 100), () {
                      Get.offAll(() => DesktopView());
                    });
                  },
                  child: Text(
                    "فهمیدم",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  } else {
    var msg = e.response?.data["_server_messages"];
    showErrorMessage(msg);
  }
}

void showErrorMessage(dynamic msg) {
  if (msg != null) {
    msg = jsonDecode(
        jsonDecode(utf8.decode(msg.toString().codeUnits)).toString());
    var message = msg as List<dynamic>;
    List<String> errors = [];
    for (var m in message) {
      String t = m["message"].toString();
      if (t.contains("Error: Value missing for")) {
        t = t.replaceAll("Error: Value missing for", "");

        t = t.replaceAll("strong", "");
        t = t + " " + "وارد نشده است";
      }
      t = t
          .replaceAll("</>", "")
          .replaceAll("<", "")
          .replaceAll("/", "")
          .replaceAll(">", "")
          .replaceAll("summary", "")
          .replaceAll("strong", "");
      errors.add(t);
    }
    if (errors.isNotEmpty) {
      showDialog(
          context: Get.context!,
          builder: (c) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "خطا",
                  style: TextStyle(fontSize: 19, color: Colors.red),
                ),
              ),
              content: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                height: Get.height / 2,
                width: Get.width * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: errors.length,
                      itemBuilder: (c, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(errors[i]),
                        );
                      }),
                ),
              ),
              actions: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.pop(c);
                    },
                    child: Text(
                      "بستن",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
              ],
            );
          });
    } else {
      showErrorToast(null);
    }
  } else {
    showErrorToast(null);
  }
}

showErrorToast(String? msg) {
  Fluttertoast.showToast(
      msg: msg ?? "خطایی رخ داده است", toastLength: Toast.LENGTH_LONG);
}

void showTransactionResult(String text) {
  showDialog(
      context: Get.context!,
      builder: (c) {
        return AlertDialog(
          content: Text(text),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.pop(c);
                },
                child: Text("بستن"))
          ],
        );
      });
}

Widget transactionBuilder(List<ShopOrderModel> items, bool isSell) {
  final _shopService = GetIt.I.get<ShopService>();
  return ListView.separated(
    itemCount: items.length,
    controller: ScrollController(),
    shrinkWrap: true,
    itemBuilder: (c, i) {
      final item = items[i];
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    Progressbar.showProgress();
                    var info = isSell
                        ? await _shopService
                            .fetchSellTransactionsInfo(item.name)
                        : await _shopService
                            .fetchBuyTransactionsInfo(item.name);
                    Progressbar.dismiss();
                    if (info != null) {
                      Get.bottomSheet(
                          isScrollControlled: true,
                          bottomSheetTemplate(Container(
                            width: Get.width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(
                                      readOnly: true,
                                      label: "فروشگاه",
                                      value: info.store_name,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      readOnly: true,
                                      label: "روش پرداخت",
                                      value: item.paymentType,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      readOnly: true,
                                      label: "فروشنده",
                                      value: info.seller_name,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      readOnly: true,
                                      label: "خریدار",
                                      value: info.name_buyer,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      readOnly: true,
                                      label: "وضعیت",
                                      value: info.status,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InputDecorator(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          labelText: " محصولات",
                                          labelStyle: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      child: Column(
                                        children: info.transactions
                                            .map((t) => Column(
                                                  children: [
                                                    CustomTextFormField(
                                                      readOnly: true,
                                                      label: t.supplier_items,
                                                      prefix: Text(_shopService
                                                                  .units[
                                                              t.supplier_items] ??
                                                          ""),
                                                      value:
                                                          t.amount.toString(),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    CustomTextFormField(
                                                      readOnly: true,
                                                      prefix: Text("تومان"),
                                                      label: "قیمت",
                                                      value: t.price.toString(),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    CustomTextFormField(
                                                      readOnly: true,
                                                      label: "توضیحات",
                                                      maxLine: 3,
                                                      value: t.description,
                                                    ),
                                                    Divider(),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ))
                                            .toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )));
                    } else {
                      Fluttertoast.showToast(
                          msg: "خطایی در دریافت اطلاعات رخ داده است");
                    }
                  },
                  child: Container(
                      width: Get.width * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: Text(
                                      maxLines: 1,
                                      item.shopName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                ),
                                Text(
                                  DateMapper.convert(item.time),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    maxLines: 2,
                                    item.status,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                Text(
                                  item.name,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        )),
                      )))
            ],
          ),
        )),
      );
    },
    separatorBuilder: (BuildContext context, int index) {
      return Divider();
    },
  );
}
