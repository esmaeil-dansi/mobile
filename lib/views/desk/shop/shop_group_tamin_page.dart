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


  RxList<ShopTamin> filteredItems = RxList();
  final _inSearch = true.obs;
  List<ShopTamin> items = [];
  TextEditingController _controller = TextEditingController();
  var _hasText = false.obs;

  @override
  void initState() {
    _shopService.fetchAllItemsUnit();
    _shopService.fetchShopTamin(widget.group.name).then((_) {
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
            .addAll(items.where((element) => element.supplier_name.contains(t)));
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShopItemTaminPage(filteredItems[i], widget.group),
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
      ),
    );
  }
}