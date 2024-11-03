import 'package:flutter/material.dart';
import 'package:frappe_app/model/SortKey.dart';
import 'package:frappe_app/model/product_report_model.dart';
import 'package:frappe_app/model/report.dart';
import 'package:frappe_app/model/sort_dir.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/utils/visit_filters.dart';
import 'package:frappe_app/views/visit/add_initial_visit.dart';
import 'package:frappe_app/views/visit/add_productivit_visit.dart';
import 'package:frappe_app/views/visit/init_visit_info.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/buttomSheetTempelate.dart';
import 'package:frappe_app/widgets/city_selector.dart';
import 'package:frappe_app/widgets/fileter_forms.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class ProductVisit extends StatefulWidget {
  @override
  State<ProductVisit> createState() => _InitialVisitState();
}

class _InitialVisitState extends State<ProductVisit> {
  final _visitService = GetIt.I.get<VisitService>();
  final _athService = GetIt.I.get<AutService>();
  final _idController = TextEditingController();
  final province = "".obs;
  String city = "";

  RxList<ProductReportModel> reports = <ProductReportModel>[].obs;

  final _noResult = false.obs;
  final _startSearch = true.obs;
  final _hasFilter = false.obs;

  var _sortKey = VisitFilters.productVisitSortKeys().first;
  var _sortDir = SortDir.DESC;

  @override
  void initState() {
    _visitService
        .fetchProductVisitReport(sortKey: _sortKey, sortDir: _sortDir)
        .then((value) {
      _startSearch.value = false;
      reports.addAll(value);
    });
    super.initState();
  }

  Future<void> getReport() async {
    _hasFilter.value = _idController.text.isNotEmpty ||
        city.isNotEmpty ||
        province.value.isNotEmpty;
    _startSearch.value = true;
    reports.clear();
    _noResult.value = false;

    var res = await _visitService.fetchProductVisitReport(
        sortDir: _sortDir, sortKey: _sortKey, id: _idController.text);
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
          appBar: appSliverAppBar(
            "پرونده بهره وری",
          ),
          floatingActionButton: _athService.isVisitingTeamOrIsRahbar()
              ? newFormWidget(()=>Get.to(()=>ProductVisitReport()))
              : null,
          body: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white54),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) {
                      getReport();
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
                    FilterForm(
                        onChangeSortKey: (_) {
                          _sortKey = _;
                          getReport();
                        },
                        onChangeSortDir: (s) {
                          _sortDir = s;
                          getReport();
                        },
                        filters: VisitFilters.productVisitSortKeys())
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: Get.width * 0.3,
                                    child: Center(
                                      child: Text(
                                        "شناسه",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                SizedBox(
                                    width: Get.width * 0.3,
                                    child: Text("نام و نام خانوادگی",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                SizedBox(
                                    width: Get.width * 0.3,
                                    child: Text("استان",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
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
                                  return Container(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        Progressbar.showProgress();
                                        var res = await _visitService
                                            .getProductInfo(record.name);
                                        Progressbar.dismiss();
                                        if (res != null) {
                                          Get.bottomSheet(
                                              bottomSheetTemplate(Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ProductVisitReport(
                                              addProductivityFormModel: res,
                                              isReport: true,
                                            ),
                                          )));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width: Get.width * 0.3,
                                                child: Center(
                                                    child: Text(record.id))),
                                            SizedBox(
                                                width: Get.width * 0.3,
                                                child: Text(record.lastName)),
                                            SizedBox(
                                                width: Get.width * 0.3,
                                                child: Text(record.province)),
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
          )),
    );
  }
}
