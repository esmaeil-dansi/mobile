import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/shop_group.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frappe_app/model/shop_type.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';

class SubGroupTamin extends StatefulWidget {
  ShopType group;
  String subTitle;

  SubGroupTamin(this.group, this.subTitle);

  @override
  State<SubGroupTamin> createState() => _SubGroupTaminState();
}

class _SubGroupTaminState extends State<SubGroupTamin> {


  final _shopService = GetIt.I.get<ShopService>();

  @override
  void initState() {
   // _shopService.fetchShopInfo(userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<Tamin> sub = subGroupTamin[widget.group]!
        .where((element) => element.sub.contains(widget.subTitle))
        .toList();
    return Scaffold(
      appBar: appSliverAppBar(" تامین کننده ها"),
      body: Center(
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                itemCount: sub.length,
                itemBuilder: (c, i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: GRADIANT_COLOR),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      sub[i].assetPath.isNotEmpty
                                          ? sub[i].assetPath
                                          : "assets/icons/konjala_soya.jpg",
                                      width: Get.width * 0.8,
                                      height: 150,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          sub[i].name,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: TextField(
                                      readOnly: true,
                                      minLines: 2,
                                      maxLines: 4,
                                      controller: TextEditingController(
                                          text: sub[i].address),
                                      decoration: InputDecoration(
                                        labelText: "آدرس",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      readOnly: true,
                                      keyboardType: TextInputType.phone,
                                      controller: TextEditingController(
                                          text: sub[i].phone.toString()),
                                      decoration: InputDecoration(
                                          labelText: "شماره تلفن",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          suffixIcon: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            child: Icon(Icons.phone),
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  'tel:${sub[i].phone.toString()}'));
                                            },
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<ShopType, List<Tamin>> subGroupTamin = {
    ShopType.DAM: [
      Tamin(
          "سایت پشتیبانی لواریاب",
          "سیستان و بلوچستان. ۲۰ کیلومتری دوراهی زابل",
          '09302086590',
          "assets/icons/loaryab.JPG",
          ["گاو شیری", "شتر", "گوسفند"]),
      Tamin(
          "ایستگاه اصلاح نژاد و گونه های مرتعی بجد ",
          "خراسان جنوبی 20 کیلومتری جاده بیرجند زاهدان روستای بجد دشت بجد",
          '09159659207',
          "assets/icons/bajd.jpeg",
          ["شتر", "گوسفند"]),
      Tamin(
          "میدان نهبندان ",
          "خراسان جنوبی نهبندان میدان دام نهبندان",
          '09159659207',
          "assets/icons/nehbandan.jpg",
          ["شتر", "گوسفند", "بز", "گاو"]),
      Tamin(
          "میدان دام زیرکوه",
          "خراسان جنوبی شهرستان زیرکوه میدان دام زیرکوه ",
          '09930894683',
          "assets/icons/zirkoh.jpg",
          ["گوسفند", "بز", "گاو شیری"]),
      Tamin(
          "شرکت تعاونی دامپروری غزال ایج",
          "استان فارس شهرستان داراب خیابان امام خمینی 17 ",
          '09173199767',
          "assets/icons/boz.jpg",
          ["گوسفند", "بز"]),
      Tamin("سایت تحقیقاتی آران و بیدگل", "استان اصفهان ، شهر آران و بیدگل ",
          '', "assets/icons/IMG_9977.jpeg", ["گوسفند", "شتر"]),
    ],
    //toyor_tamin
    ShopType.TOTOR: [
      Tamin(
          "ایستگاه اصلاح نژاد و گونه های مرتعی بجد ",
          "خراسان جنوبی 20 کیلومتری جاده بیرجند زاهدان روستای بجد دشت بجد",
          '09159659207',
          "assets/icons/bajd.jpeg",
          ["مرغ", "خروس"]),
      Tamin("مزرعه پرندک ", "استان مرکزی شهرستان ساوه پرندک مزرعه پرندک",
          '09179404953', "", ["بوقلمون"]),
    ],
    ShopType.NAHADA: [
      Tamin(
          "ایستگاه اصلاح نژاد و گونه های مرتعی بجد ",
          "خراسان جنوبی 20 کیلومتری جاده بیرجند زاهدان روستای بجد دشت بجد",
          '09159659207',
          "assets/icons/bajd.jpeg",
          ["جو", "یونجه", "کاه"]),
    ],
  };
}

class Tamin {
  String name;
  String address;
  String assetPath;
  String phone;
  List<String> sub;

  Tamin(this.name, this.address, this.phone, this.assetPath, this.sub);
}
