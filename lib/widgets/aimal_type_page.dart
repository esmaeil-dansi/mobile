import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_type.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/views/desk/shop/shop_user_page.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';

class AnimalTypePage extends StatefulWidget {
  String type;
  ShopType group;

  AnimalTypePage(this.group, this.type);

  @override
  State<AnimalTypePage> createState() => _animalTypePageState();
}

class _animalTypePageState extends State<AnimalTypePage> {
  var _visitService = GetIt.I.get<VisitService>();
  var _controller = TextEditingController();
  RxList<String> types = <String>[].obs;
  var loading = true.obs;

  @override
  void initState() {
    _visitService.getAnimalType(widget.type, q: _controller.text).then((value) {
      types.addAll(value);
      loading.value = false;
    });
    _controller.addListener(() async {
      loading.value = true;
      types.clear();

      _visitService
          .getAnimalType(widget.type, q: _controller.text)
          .then((value) {
        types.addAll(value);
        loading.value = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: GRADIANT_COLOR),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(
                  10,
                ),
                topLeft: Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      10,
                    ),
                    topLeft: Radius.circular(10))),
            child: Column(
              children: [
                SizedBox(
                  height: 6,
                ),
                Text(
                  "انتخاب نژاد " + widget.type,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "جستجو",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() => types.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemCount: types.length,
                          itemBuilder: (c, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.to(() =>
                                    SubGroupTamin(widget.group, widget.type));
                              },
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                height: 40,
                                width: Get.width * 0.8,
                                child: Center(child: Text(types[i])),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
                      )
                    : loading.isTrue
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text("نتیجه ای یافت نشده است!")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
