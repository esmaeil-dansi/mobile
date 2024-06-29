import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/widgets/checkBox.dart';
import 'package:frappe_app/widgets/date.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/form/custom_dropownbuttom_formField.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
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

  final _formKey = GlobalKey<FormState>();
  var time = 0;
  Rxn<AgentInfo> agentInfo = Rxn();

  LatLng? _latLng;

  var _date = "";

  final _dateController = TextEditingController();

  final _visitService = GetIt.I.get<VisitService>();
  final _imagePath = "".obs;
  final _imagePath_2 = "".obs;
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
      floatingActionButton: submitForm(() async {
        if (_formKey.currentState?.validate() ?? false) {
          if (_latLng != null) {
            Progressbar.showProgress();
            var res = await _visitService.saveInitVisit(
              time: time,
              nationId: _nationId.text,
              agentInfo: agentInfo.value ?? AgentInfo(),
              date: _date,
              imagePath: _imagePath.value,
              imagePath_2: _imagePath_2.value,
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
        } else {
          Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
        }
      }),
      appBar: appSliverAppBar("اضافه کردن بازدید"),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(left: 7, right: 7, top: 9, bottom: 90),
            decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Form(
              key: _formKey,
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
                            CustomTextFormField(
                              label: "کد ملی",
                              textEditingController: _nationId,
                              maxLength: 10,
                              height: 80,
                              onChanged: (_) {
                                if (_.length == 10) {
                                  _fetchAgentInfo();
                                }
                              },
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Obx(() => agentInfo.value != null
                                ? Column(
                                    children: [
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        value: agentInfo.value!.full_name,
                                        label: "نام و نام خانوادگی",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        value: agentInfo.value!.province,
                                        label: "استان",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        value: agentInfo.value!.city,
                                        label: "شهرستان",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        maxLine: 3,
                                        value: agentInfo.value!.address,
                                        label: "آدرس",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        value: agentInfo.value!.mobile,
                                        label: "َشماره تلفن",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        value: agentInfo.value!.rahbar,
                                        label: "َراهبر اصلی",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextFormField(
                                        height: 60,
                                        readOnly: true,
                                        value: agentInfo.value!.department,
                                        label: "اداره کمیته امداد",
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
                            CustomDropdownButtonFormField(
                              label: "نوع طرح",
                              items: [
                                "پرورش و نگهداری دام سبک",
                                "پرورش و نگهداری دام سنگین",
                                "پرورش طیور"
                              ],
                              onChange: (_) {
                                _tarh.text = _;
                              },
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
                                      CustomDropdownButtonFormField(
                                        label: "نوع دام/طیور",
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
                                        ],
                                        onChange: (_) {
                                          _noe_dam.text = _;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomDropdownButtonFormField(
                                        label: "نوع  مالکیت دام/طیور",
                                        items: [
                                          "مالک",
                                          "حق العملی",
                                          "امانی",
                                        ],
                                        onChange: (_) {
                                          _malekiyat.text = _;
                                        },
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
                            CustomDropdownButtonFormField(
                                label: "وضعیت جایگاه نگهداری دام",
                                items: ["مناسب", "نامناسب"],
                                onChange: (_) {
                                  _vaziat.text = _;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                                label: "نوع جایگاه",
                                items: ["باز", "نیمه بسته", " بسته"],
                                onChange: (_) {
                                  _noe_jaygah.text = _;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                                label: "کیفیت آب",
                                items: ["شور", "شیرین", "لب شور"],
                                onChange: (_) {
                                  _quality_water.text = _;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                                label: "منبع تامین آب",
                                items: [
                                  "شهری",
                                  "چاه",
                                  "روستایی",
                                  "انتقال با تانکر"
                                ],
                                onChange: (_) {
                                  _tamin_water.text = _;
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            CustomDropdownButtonFormField(
                                label: "آجر معدنی",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  _ajor_madani.text = _;
                                }),
                            SizedBox(
                              height: 5,
                            ),
                            CustomDropdownButtonFormField(
                                label: "سنگ نمک",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  _sang_namak.text = _;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                                label: "ادوات",
                                items: [
                                  "هیچکدام",
                                  "آسیاب",
                                  "میکسر",
                                  "وانت",
                                  "شیردوش",
                                  "فرغون",
                                ],
                                onChange: (_) {
                                  _adavat.text = _;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                                label: "کف جایگاه",
                                items: [
                                  "بتنی",
                                  "خاکی",
                                ],
                                onChange: (_) {
                                  _kaf_jaygah.text = _;
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            ImageView(_imagePath, "تصویر جایگاه 1"),
                            SizedBox(
                              height: 10,
                            ),
                            ImageView(_imagePath_2, "تصویر جایگاه 2"),
                            CustomDropdownButtonFormField(
                                label: "وضعیت اجرای طرح",
                                items: [
                                  "جایگاه دام مورد تایید نیست",
                                  "طلاحیت متقاضی مورد تایید نیست",
                                  "آماده اجرای طرح می باشد",
                                ],
                                onChange: (_) {
                                  _status.text = _;
                                }),
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
                            CustomTextFormField(
                              label: "سایر ایرادات",
                              maxLine: 4,
                              textEditingController: _sayer,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label:
                                  "اقدامات قبل از خرید دام (در صورت عدم ایراد جمله نیازی نیست ثبت گردد)",
                              maxLine: 4,
                              textEditingController: _eghdamat,
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
          ),
        ),
      ),
    );
  }
}
