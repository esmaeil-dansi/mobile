import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/widgets/checkBox.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/date.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
import 'package:frappe_app/widgets/sliver_body.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/app_sliver_app_bar.dart';

class AddInitialReport extends StatefulWidget {
  @override
  State<AddInitialReport> createState() => _AddInitialReportState();
}

class _AddInitialReportState extends State<AddInitialReport> {
  @override
  void initState() {
    this.time = DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  var time = 0;
  Rxn<AgentInfo> agentInfo = Rxn();

  LatLng? _latLng;

  var _date = "";

  final _dateController = TextEditingController();

  final _visitService = GetIt.I.get<VisitService>();
  final _imagePath = "".obs;
  final _tarh = TextEditingController();
  final _noe_jaygah = TextEditingController();
  final _quality_water = TextEditingController();
  final _tamin_water = TextEditingController();
  final _ajor_madani = TextEditingController(text: "دارد");
  final _sang_namak = TextEditingController();
  final _vaziat = TextEditingController();
  final _adavat = TextEditingController();
  final _kaf_jaygah = TextEditingController();
  final _sayer = TextEditingController();
  final _eghdamat = TextEditingController();
  final _status = TextEditingController();
  final _noe_dam = TextEditingController();
  final _malekiyat = TextEditingController();
  final _nationId = TextEditingController();

  var _sayeban = 0;
  var _adam_hesar = 0;
  var _astarkeshi = 0;
  var _mahal_negahdari = 0;
  var _adam_abkhor = 0;
  var _adam_noor = 0;
  var _adam_tahvie = 0;
  var _dam = 0.obs;

  void _fetchAgentInfo() {
    this
        ._visitService
        .getAgentInfo(_nationId.text)
        .then((value) => agentInfo.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10),
        child: FloatingActionButton(
          backgroundColor: MAIN_COLOR,
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () async {
            if (_latLng != null) {
              Progressbar.showProgress();
              var res = await _visitService.saveInitVisit(
                time: time,
                nationId: _nationId.text,
                agentInfo: agentInfo.value ?? AgentInfo(),
                date: _date,
                imagePath: _imagePath.value,
                tarh: _tarh.text,
                noe_jaygah: _noe_jaygah.text,
                quality_water: _quality_water.text,
                tamin_water: _tamin_water.text,
                ajor_madani: _ajor_madani.text,
                sang_namak: _sang_namak.text,
                adavat: _adavat.text,
                kaf_jaygah: _kaf_jaygah.text,
                sayeban: _sayeban,
                status: _status.text,
                adam_hesar: _adam_hesar,
                astarkeshi: _astarkeshi,
                mahal_negahdari: _mahal_negahdari,
                adam_abkhor: _adam_abkhor,
                adam_noor: _adam_noor,
                adam_tahvie: _adam_tahvie,
                sayer: _sayer.text,
                eghdamat: _eghdamat.text,
                dam: _dam.value,
                noe_dam: _noe_dam.text,
                malekiyat: _malekiyat.text,
                vaziat: _vaziat.text,
                latLng: _latLng!,
              );
              Progressbar.dismiss();
              if (res) {
                Get.back();
              }
            } else {
              Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
            }
            // Get.back();
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          appSliverAppBar("اضافه کردن بازدید"),
          sliverBody(Container(
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
                            labelText: "اطلاعات اولیه",
                            labelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: TextField(
                                controller: _nationId,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        maxLines: 3,
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: agentInfo.value!.address),
                                        decoration: InputDecoration(
                                          labelText: "آدرس",
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
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "نوع طرح",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: [
                                  "پرورش و نگهداری دام سبک",
                                  "پرورش و نگهداری دام سنگین",
                                  "پرورش طیور"
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _tarh.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TitleCheckBox("آیا متقاضی دام/طیور دارد؟", (c) {
                              _dam.value = c ? 1 : 0;
                            }),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() => _dam.value == 1
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: "نوع دام/طیور",
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 2, color: Colors.red),
                                              //<-- SEE HERE
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          items: [
                                            "میش مولد",
                                            "بره",
                                            "بز مولد",
                                            "بزغاله",
                                            "قوچ",
                                            "بز نر",
                                            "گاو شیری",
                                            "گوساله",
                                            "گاو نر",
                                            "مرغ/جوجه گوشتی",
                                            "مرغ/جوجه محلی"
                                          ]
                                              .map((e) =>
                                                  DropdownMenuItem<String>(
                                                    value: e,
                                                    child: Text(e),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            _noe_dam.text = value!;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 70,
                                        child: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: "نوع  مالکبت دام/طیور",
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 2, color: Colors.red),
                                              //<-- SEE HERE
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          items: [
                                            "مالک",
                                            "حق العملی",
                                            "امانی",
                                          ]
                                              .map((e) =>
                                                  DropdownMenuItem<String>(
                                                    value: e,
                                                    child: Text(e),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            _malekiyat.text = value!;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink())
                          ],
                        ),
                      ),
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
                            labelText: "اطلاعات جایگاه",
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
                                  labelText: "وضعیت جایگاه نگهداری دام",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: ["مناسب", "نامناسب"]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _vaziat.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "نوع جایگاه",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                items: ["باز", "نیمه بسته", " بسته"]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _noe_jaygah.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "کیفیت آب",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: ["شور", " شیرین", "لب شور"]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _quality_water.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "منبع تامین آب",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: [
                                  "شهری",
                                  "چاه",
                                  "روستایی",
                                  "انتقال با تانکر"
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _tamin_water.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "آجر معدنی",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: [
                                  "دارد",
                                  "ندارد",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _ajor_madani.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "سنگ نمک",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: [
                                  "دارد",
                                  "ندارد",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _sang_namak.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "ادوات",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: [
                                  "هیچکدام",
                                  "آسیاب",
                                  "میکسر",
                                  "وانت",
                                  "شیردوش",
                                  "فرغون",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _adavat.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "کف جایگاه",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: [
                                  "بتنی",
                                  "خاکی",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _kaf_jaygah.text = value!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ImageView(_imagePath, ""),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 70,
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "وضعیت اجرای طرح",
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                items: [
                                  "جایگاه دام مورد تایید نیست",
                                  "طلاحیت متقاضی مورد تایید نیست",
                                  "آماده اجرای طرح می باشد",
                                ]
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  _status.text = value!;
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
                          labelText: "ایرادات جایگاه",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            TitleCheckBox("عدم سایه بان مناسب", (c) {
                              _sayeban = c ? 1 : 0;
                            }),
                            TitleCheckBox("عدم حصارکشی مناسب", (c) {
                              _adam_hesar = c ? 1 : 0;
                            }),
                            TitleCheckBox(
                                "آسترکشی دیوارهای داخلی جایگاه انجام نشده",
                                (c) {
                              _astarkeshi = c ? 1 : 0;
                            }),
                            TitleCheckBox("محل نگهداری خوراک دام مناسب نیست",
                                (c) {
                              _mahal_negahdari = c ? 1 : 0;
                            }),
                            TitleCheckBox("عدم وجود آبخور وآبشخور مناسب ", (c) {
                              _adam_abkhor = c ? 1 : 0;
                            }),
                            TitleCheckBox("عدم برخورداری جایگاه از نور مناسب ",
                                (c) {
                              _adam_noor = c ? 1 : 0;
                            }),
                            TitleCheckBox("عدم برخورداری جایگاه از تهویه لازم ",
                                (c) {
                              _adam_tahvie = c ? 1 : 0;
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              maxLines: 4,
                              controller: _sayer,
                              decoration: InputDecoration(
                                labelText: "سایر ایرادات",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _eghdamat,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText:
                                    "اقدامات قبل از خرید دام (در صورت عدم ایراد جمله نیازی نیست ثبت گردد)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
          ))
        ],
      ),
    );
  }
}
