import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/views/desk/shop/shop_info_page.dart';
import 'package:frappe_app/views/desk/shop/shop_tamin_avatar.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class AllShopPage extends StatefulWidget {
  @override
  State<AllShopPage> createState() => _AllShopPageState();
}

class _AllShopPageState extends State<AllShopPage> {
  var _shopService = GetIt.I.get<ShopService>();
  var _shopRepo = GetIt.I.get<ShopRepo>();

  @override
  void initState() {
    _shopService.fetchAllItemsUnit();
    _shopService.fetchShopInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "فروشگاه من",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: _shopRepo.watchAll(),
          builder: (c, s) {
            if (s.hasData && s.data != null && s.data!.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: s.data!.length,
                  itemBuilder: (c, i) {
                    var info = s.data![i];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container(
                                //     width: 50,
                                //     height: 70,
                                //     decoration: BoxDecoration(
                                //         shape: BoxShape.circle,
                                //         border: Border.all()),
                                //     child: Center(
                                //         child: Icon(
                                //             CupertinoIcons.shopping_cart))),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      info.name,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      info.id,
                                      style: TextStyle(
                                          color: Colors.black38, fontSize: 13),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Get.to(() => ShopInfoPage(info));
                                      },
                                      child: Container(
                                          width: 80,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black54,
                                                  spreadRadius: 0,
                                                  blurRadius: 1,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                            width: 140,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                gradient: LinearGradient(
                                                    colors: GRADIANT_COLOR)),
                                            child: Center(
                                                child: Text(
                                              "مشاهده",
                                              style: Get.textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                            )),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 0,
                                blurRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  });
            }
            if (s.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
