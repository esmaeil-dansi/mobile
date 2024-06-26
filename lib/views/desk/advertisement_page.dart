import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/db/advertisement.dart';
import 'package:frappe_app/db/dao/advertisement_dao.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class AdvertisementPage extends StatefulWidget {
  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  var advDao = GetIt.I.get<AdvertisementDao>();

  var date = DateTime.now();

  @override
  void initState() {
    GetIt.I.get<AutService>().fetchAdvertisement(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اطلاعیه ها"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Advertisement>>(
            stream: advDao.watchAll(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final advs = snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: advs.length,
                  itemBuilder: (c, i) {
                    var adv = advs[i];
                    return advDateUi(adv);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Text("اطلاعیه ی جدیدی وجود ندارد.");
            }),
      ),
    );
  }

  Widget advDateUi(Advertisement advertisement) {
    var show = false.obs;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Container(
          child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              show.value = !show.value;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Jalali.fromDateTime(DateTime.parse(advertisement.date))
                    .formatCompactDate()),
                Obx(() => IconButton(
                    onPressed: () {
                      show.value = !show.value;
                    },
                    icon: show.isFalse
                        ? Icon(Icons.arrow_forward_ios)
                        : Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 36,
                          ))),
              ],
            ),
          ),
          Obx(() => show.isTrue
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: advertisement.title.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient:
                                    LinearGradient(colors: GRADIANT_COLOR)),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: Text(
                                                advertisement.title[i],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: Text(advertisement.body[i],
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black87)),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              _showInfo(advertisement, i);
                                            },
                                            icon: Icon(Icons.remove_red_eye))
                                      ],
                                    ),
                                  )),
                            )),
                      ),
                      onTap: () {
                        _showInfo(advertisement, i);
                      },
                    );
                  },
                )
              : SizedBox.shrink())
        ],
      )),
    );
  }

  void _showInfo(Advertisement advertisement, int i) {
    Get.bottomSheet(bottomSheetTemplate(
      Container(
        width: Get.width,
        height: Get.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  advertisement.body[i],
                  maxLines: null,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            color: Colors.white),
      ),
    ));
  }
}
