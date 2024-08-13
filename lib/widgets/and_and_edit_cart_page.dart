import 'package:flutter/material.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/cart.dart' as ca;
import 'package:get_it/get_it.dart';

void addOrEditCartPage(ca.Cart cart) {
  var _amountController = TextEditingController(text: cart.amount.toString());
  var _shopRepo = GetIt.I.get<ShopRepo>();
  var _shopService = GetIt.I.get<ShopService>();
  Get.bottomSheet(bottomSheetTemplate(SingleChildScrollView(
    child: Container(
      child: Column(
        children: [
        SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  label: Text("مقدار درخواستی"),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 3, color: Colors.red),
                    //<-- SEE HERE
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  suffix: Text(_shopService.units[cart.item] ?? "")),
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
          GestureDetector(
            onTap: () {
              Get.back();
              cart.amount = double.parse(_amountController.text);
              _shopRepo.saveCart(cart);
              _amountController.clear();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                  width: Get.width,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(colors: GRADIANT_COLOR)),
                  child: Center(
                      child: Text(
                    "ویرایش",
                    style:
                        Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
                  ))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  )));
}
