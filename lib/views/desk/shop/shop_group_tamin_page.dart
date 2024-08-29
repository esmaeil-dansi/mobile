import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/model/shop_tamin.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/views/desk/shop/shop_item_tamin_page.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class ShopGroupTaminPage extends StatefulWidget {
  ShopItemBaseModel group;

  ShopGroupTaminPage(this.group);

  @override
  State<ShopGroupTaminPage> createState() => _ShopGroupTaminPageState();
}

class _ShopGroupTaminPageState extends State<ShopGroupTaminPage> {
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
          "تامین کننده های " + widget.group.name,
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            child: FutureBuilder(
              future: _shopService.fetchShopTamin(widget.group.name),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ShopTamin>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text("متاسفانه تامین کننده ای یافت نشده است! "),
                    );
                  } else {
                    final tamins = snapshot.data!;
                    return ListView.builder(
                        itemCount: tamins.length,
                        itemBuilder: (c, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ShopItemTaminPage(tamins[i], widget.group),
                          );
                        });
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return SizedBox.shrink();
              },
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
