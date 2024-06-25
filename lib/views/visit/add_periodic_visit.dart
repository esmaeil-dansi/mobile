import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/date.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

class AddPeriodicReport extends StatefulWidget {
  @override
  State<AddPeriodicReport> createState() => _AddPeriodicReportState();
}

class _AddPeriodicReportState extends State<AddPeriodicReport> {
  int time = 0;

  @override
  void initState() {
    time = DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  final _dateController = TextEditingController();

  final _nextDateController = TextEditingController();

  final _visitService = GetIt.I.get<VisitService>();

  var stable_condition = "";

  var manger = "";

  var losses = "";

  var bazdid = "";

  var _date = "";

  var _nextDate = "";

  var imagePath = "".obs;

  var water = "";

  var supply_situation = "";

  var ventilation = "";

  var vaziat = "";

  final _nationId = TextEditingController();

  LatLng? _latLng;

  var outbreak = TextEditingController();

  Rxn<AgentInfo> agentInfo = Rxn();

  void _fetchAgentInfo() {
    this
        ._visitService
        .getAgentInfo(_nationId.text)
        .then((value) => agentInfo.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: submitForm(() async {
          if (_latLng != null) {
            Progressbar.showProgress();
            var res = await _visitService.sendPeriodicVisits(
                outbreak: outbreak.text,
                stable_condition: stable_condition,
                manger: manger,
                imagePath: imagePath.value,
                nationId: _nationId.text,
                time: time,
                losses: losses,
                bazdid: bazdid,
                water: water,
                supply_situation: supply_situation,
                ventilation: ventilation,
                vaziat: vaziat,
                agentInfo: agentInfo.value ?? AgentInfo(),
                date: _date,
                next_date: _nextDate,
                latLng: _latLng!);
            Progressbar.dismiss();
            if (res) {
              Get.back();
            }
          } else {
            Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
          }
        }),
        appBar: appSliverAppBar("بازدید دوره ای جدید"),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.only(left: 7, right: 7, top: 9, bottom: 90),
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: "اطلاعات بازدید",
                            labelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _nationId,
                              keyboardType: TextInputType.number,
                              onChanged: (_) {
                                if (_.length == 10) {
                                  _fetchAgentInfo();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "کد ملی",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(() => agentInfo.value != null
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: agentInfo.value!.full_name),
                                          decoration: InputDecoration(
                                            labelText: "نام و نام خانوادگی",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: agentInfo.value!.province),
                                          decoration: InputDecoration(
                                            labelText: "استان",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        child: TextField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: agentInfo.value!.city),
                                          decoration: InputDecoration(
                                            labelText: "شهرستان",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // TextField(
                                      //   maxLines: 3,
                                      //   readOnly: true,
                                      //   controller: TextEditingController(
                                      //       text: agentInfo.value!.address),
                                      //   decoration: InputDecoration(
                                      //     labelText: "آدرس",
                                      //     border: OutlineInputBorder(
                                      //       borderRadius:
                                      //           BorderRadius.circular(20.0),
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: agentInfo.value!.mobile),
                                        decoration: InputDecoration(
                                          labelText: "َشماره تلفن",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: agentInfo.value!.rahbar),
                                        decoration: InputDecoration(
                                          labelText: "َراهبر اصلی",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: agentInfo.value!.department),
                                        decoration: InputDecoration(
                                          labelText: "اداره کمیته امداد",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "شروع بیماری در گله ؟",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "بله",
                                  "خیر",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  outbreak.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: "نام بیماری و تشخیص پزشک",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "وضعیت بستر",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "تمیز",
                                  "متوسط",
                                  "کثیف",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  stable_condition = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "وضعیت آخورها",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "تمیز و مرتب",
                                  "آلوده",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  manger = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: " وجود تلفات درگله؟",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "بله",
                                  "خیر",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  losses = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: " دوره بازدید",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: Iterable<int>.generate(12)
                                    .toList()
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e.toString(),
                                          child: Text((e + 1).toString()),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  bazdid = (int.parse(value!) + 1).toString();
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText:
                                    "تعداد تلفات و نظر دامپزشک در کالبدگشایی",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: " وضعیت آبشخورها",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "تمیز",
                                  "کثیف",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  water = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: " وضعیت انبار آذوقه",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "مرتب و تمیز",
                                  "آلوده و نا مرتب",
                                  "آذوقه در حال فساد",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  supply_situation = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: " وضعیت تهویه",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "مناسب",
                                  "نامناسب",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  ventilation = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(imagePath, "تصویر جایگاه دام"),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            labelText: "وضعیت طرح",
                            labelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "وضعیت طرح",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: ["انحراف از طرح", "فعال"]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  vaziat = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: "علت(در صورت وجود انحراف)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SelectLocation(
                                onSelected: (_) {
                                  _latLng = _;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "تاریخ",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: TextField(
                                onTap: () => selectDate((_) {
                                  _date = _;
                                }, _dateController),
                                readOnly: true,
                                canRequestFocus: false,
                                controller: _dateController,
                                decoration: InputDecoration(
                                  labelText: "تاریخ بازدید",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                onTap: () => selectDate((_) {
                                  _nextDate = _;
                                }, _nextDateController),
                                readOnly: true,
                                canRequestFocus: false,
                                controller: _nextDateController,
                                decoration: InputDecoration(
                                  labelText: "تاریخ بازدید بعدی",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
