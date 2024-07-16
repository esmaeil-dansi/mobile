import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class ShopItemTaminInfoPage extends StatelessWidget {
  ShopTamin shopTamin;

  ShopItemTaminInfoPage(this.shopTamin);

  var _shopService = GetIt.I.get<ShopService>();

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
          shopTamin.name,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _shopService.fetchShiopItemsTaminInfo(shopTamin.name),
            builder: (c, s) {
              if (s.hasData && s.data != null && s.data!.isNotEmpty) {
                var items = s.data!;
                return ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (c, i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items[i].name,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    "موجودی: " + items[i].amount,
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Fluttertoast.showToast(
                                      msg: "فعلا این امکان برقرار نیست");
                                },
                                child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                            colors: GRADIANT_COLOR)),
                                    child: Center(
                                        child: Text(
                                      "خرید",
                                      style: Get.textTheme.bodyLarge
                                          ?.copyWith(color: Colors.black),
                                    ))),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
