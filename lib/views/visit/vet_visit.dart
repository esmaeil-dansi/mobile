import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/report.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/views/visit/add_vetvisit.dart';
import 'package:frappe_app/views/visit/vervisit_info.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/city_selector.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/sliver_body.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class VetVisit extends StatefulWidget {
  @override
  State<VetVisit> createState() => _VetVisitState();
}

class _VetVisitState extends State<VetVisit> {
  RxList<VetVisitReport> reports = <VetVisitReport>[].obs;
  final _visitService = GetIt.I.get<VisitService>();
  final _athService = GetIt.I.get<AutService>();
  final _idController = TextEditingController();
  final province = "".obs;
  String city = "";
  final _noResult = false.obs;
  final _startSearch = false.obs;
  final _hasFilter = false.obs;

  @override
  void initState() {
    province.value = _athService.getProvince();
    city = _athService.getCity();
    _visitService
        .fetchVetVisitReport(province: province.value, city: city)
        .then((value) => reports.addAll(value));
    super.initState();
  }

  Future<void> getReport() async {
    reports.clear();
    _noResult.value = false;
    _hasFilter.value = _idController.text.isNotEmpty ||
        city.isNotEmpty ||
        province.value.isNotEmpty;
    _startSearch.value = true;
    var res = await _visitService.fetchVetVisitReport(
        id: _idController.text.isNotEmpty ? int.parse(_idController.text) : 0,
        province: province.value,
        city: city);
    _startSearch.value = false;
    if (res.isNotEmpty) {
      reports.addAll(res);
    } else {
      _noResult.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: _athService.isRahbar()
            ? Padding(
                padding: const EdgeInsets.only(bottom: 25, left: 20),
                child: FloatingActionButton(
                  backgroundColor: MAIN_COLOR,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.to(() => AddVetVisit());
                  },
                ),
              )
            : null,
        body: CustomScrollView(
          slivers: [
            appSliverAppBar("بازدید دامپزشکی"),
            sliverBody(Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white54),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: TextField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) {
                        if (_.isNotEmpty) {
                          getReport();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "شناسه",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  provinceSelector((p0) {
                    city = "";
                    province.value = p0;
                    getReport();
                  }, province.value),
                  SizedBox(
                    height: 7,
                  ),
                  Obx(() => citySelector(province.value, (p0) {
                        city = p0;
                        getReport();
                      }, city)),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Row(
                    children: [
                      Obx(() => _hasFilter.isTrue
                          ? Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        city = "";
                                        province.value = "";
                                        _idController.clear();
                                        getReport();
                                      },
                                      icon: Icon(
                                        Icons.filter_alt_off,
                                        color: Colors.blue,
                                      ))
                                ],
                              ),
                            )
                          : SizedBox(
                              width: 30,
                            )),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.sort)),
                                Text("آخرین بروزرسانی"),
                              ],
                            ),
                          )),
                    ],
                  ),
                  Obx(() => reports.isNotEmpty
                      ? Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: Get.width * 0.25,
                                      child: Text("شناسه")),
                                  SizedBox(
                                      width: Get.width * 0.3,
                                      child: Text("کارشناس")),
                                  SizedBox(
                                      width: Get.width * 0.20,
                                      child: Text("متقاضی")),
                                  SizedBox(
                                      width: Get.width * 0.20,
                                      child: Text("ترکیب")),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: ListView.separated(
                                  physics: ScrollPhysics(),
                                  itemCount: reports.length,
                                  itemBuilder: (c, i) {
                                    var record = reports[i];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () async {
                                          Progressbar.showProgress();
                                          var res = await _visitService
                                              .getVetVisitInfo(
                                                  int.parse(record.id));
                                          Progressbar.dismiss();
                                          if (res != null) {
                                            Get.bottomSheet(VetVisitInfo(res));
                                          }
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: Get.width * 0.25,
                                                  child: Text(record.id)),
                                              SizedBox(
                                                  width: Get.width * 0.3,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 3),
                                                    child:
                                                        Text(record.full_name),
                                                  )),
                                              SizedBox(
                                                  width: Get.width * 0.20,
                                                  child:
                                                      Text(record.r_full_name)),
                                              SizedBox(
                                                  width: Get.width * 0.2,
                                                  child: Center(
                                                      child:
                                                          Text(record.title))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider();
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      : _startSearch.isTrue
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _noResult.isTrue
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("نتیجه ای یافت نشده است"),
                                )
                              : SizedBox.shrink())
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
