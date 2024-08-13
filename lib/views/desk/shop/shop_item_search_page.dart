import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_item_base_model.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/views/desk/shop/shop_group_tamin_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class ShopItemSearchPage extends StatefulWidget {
  String group;

  ShopItemSearchPage(this.group);

  @override
  State<ShopItemSearchPage> createState() => _ShopItemSearchPageState();
}

class _ShopItemSearchPageState extends State<ShopItemSearchPage> {
  RxList<ShopItemBaseModel> filteredItems = RxList();
  final _inSearch = true.obs;
  List<ShopItemBaseModel> items = [];
  var _shopService = GetIt.I.get<ShopService>();
  TextEditingController _controller = TextEditingController();
  var _hasText = false.obs;

  @override
  void initState() {
    _shopService.fetchAllItemsUnit();
    _shopService.fetchAvailableShopGroupItems(widget.group).then((_) {
      items = _;
      filteredItems.addAll(items);
      _inSearch.value = false;
    });

    _controller.addListener(() {
      var t = _controller.text;
      _hasText.value = t.isNotEmpty;
      if (t.isNotEmpty) {
        filteredItems.clear();
        filteredItems
            .addAll(items.where((element) => element.name.contains(t)));
      } else {
        filteredItems.clear();
        filteredItems.addAll(items);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.height * 2 / 3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => _inSearch.isFalse
              ? Column(
                  children: [
                    Icon(
                      CupertinoIcons.shopping_cart,
                      color: Colors.green,
                      size: 40,
                    ),
                    Text("محصول مورد نظر را انتخاب کنید"),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 55,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          suffixIcon: Obx(() => _hasText.isTrue
                              ? IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                  },
                                  icon: Icon(CupertinoIcons.clear_circled),
                                )
                              : SizedBox.shrink()),
                          labelText: "جستجو",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (filteredItems.isNotEmpty)
                      Expanded(
                        child: ListView.separated(
                          itemCount: filteredItems.length,
                          itemBuilder: (c, i) {
                            return GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.pop(c);
                                Get.to(
                                    () => ShopGroupTaminPage(filteredItems[i]));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 5),
                                child: SizedBox(
                                    height: 25,
                                    child: Text(filteredItems[i].name)),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      )
                    else
                      Text(" نتیجه ای یافت نشده است!"),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
        ));
  }
}
