import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/model/add_initial_visit_from_model.dart';
import 'package:frappe_app/repo/request_repo.dart';

import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/utils/date_mapper.dart';
import 'package:frappe_app/widgets/agent_info_widget.dart';
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
  AddInitialVisitFormModel? addInitialVisitFormModel;
  int? time;

  AddInitialReport({this.addInitialVisitFormModel, this.time});

  @override
  State<AddInitialReport> createState() => _AddInitialReportState();
}

class _AddInitialReportState extends State<AddInitialReport> {
  final _requestRepo = GetIt.I.get<RequestRepo>();
  late AddInitialVisitFormModel model;

  Future<void> checkPendingRequest(String id) async {
    try {
      if (id.isNotEmpty) {
        // _requestRepo.getByNationIdAndType(id, "Initial Visit").then((value) {
        //   if (value != null) {
        //     manageRequest("بازدید اولیه", value, Get.context!, () {
        //       model =
        //           AddInitialVisitFormModel.fromJson(json.decode(value.body));
        //       time = value.time;
        //       _dam.value = model.dam ?? 0;
        //       _dateController.text = DateMapper.convert(model.vDate ?? '');
        //       _latLng.value = LatLng(model.lat ?? 0, model.lon ?? 0);
        //       _fetchImages();
        //       setState(() {});
        //     });
        //   }
        // });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    if (widget.addInitialVisitFormModel != null) {
      model = widget.addInitialVisitFormModel!;
      _dam.value = model.dam ?? 0;
      _dateController.text = DateMapper.convert(model.vDate ?? '');
      _latLng.value = LatLng(model.lat ?? 0, model.lon ?? 0);
      _imagePath.value = model.image1 ?? "";
      _imagePath_2.value = model.image2 ?? "";
      _imagePath_3.value = model.image3 ?? "";
      _fetchAgentInfo();
    } else {
      model = AddInitialVisitFormModel();
    }

    this.time = widget.time ?? DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var time = 0;
  Rxn<AgentInfo> agentInfo = Rxn();
  Rxn<LatLng> _latLng = Rxn();
  final _dateController = TextEditingController();
  final _visitService = GetIt.I.get<VisitService>();
  final _imagePath = "".obs;
  final _imagePath_2 = "".obs;
  final _imagePath_3 = "".obs;
  var _dam = 0.obs;

  void _fetchAgentInfo() {
    this
        ._visitService
        .getAgentInfo(model.nationalId!)
        .then((value) => agentInfo.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: submitForm(() async {
        if (widget.addInitialVisitFormModel != null) {
          await _submit(context);
        } else {
          if (_formKey.currentState?.validate() ?? false) {
            if (_latLng.value != null) {
              model.lon = _latLng.value!.longitude;
              model.lat = _latLng.value!.latitude;
              model.image1 = _imagePath.value;
              model.image2 = _imagePath_2.value;
              model.image3 = _imagePath_3.value;
              if (model.image1 == null ||
                  model.image1!.isEmpty ||
                  model.image2 == null ||
                  model.image2!.isEmpty ||
                  model.image3 == null ||
                  model.image3!.isEmpty) {
                Fluttertoast.showToast(msg: "تصویر را وارد  کنید");
              } else {
                if (_dateController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "تاریخ را انتخاب کنید");
                } else {
                  await _submit(context);
                }
              }
            } else {
              Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
            }
          } else {
            Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
          }
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
                              // textEditingController: _nationId,
                              maxLength: 10,
                              value: model.nationalId ?? '',
                              readOnly: widget.addInitialVisitFormModel != null,
                              height: 80,
                              onChanged: (_) {
                                checkPendingRequest(_);
                                model.nationalId = _;
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
                                ? agentInfoWidget(agentInfo.value!)
                                : SizedBox.shrink()),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                onTap: () => selectDate((_) {
                                  model.vDate = _;
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
                              value: model.tarh,
                              label: "نوع طرح",
                              items: [
                                "پرورش و نگهداری دام سبک",
                                "پرورش و نگهداری دام سنگین",
                                "پرورش طیور"
                              ],
                              onChange: (_) {
                                model.tarh = _;
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TitleCheckBox("آیا متقاضی دام/طیور دارد؟", (c) {
                              _dam.value = c ? 1 : 0;
                              model.dam = _dam.value;
                            }, value: (model.dam ?? 0) > 0),
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
                                            model.noeDam = _;
                                          },
                                          value: model.noeDam),
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
                                            model.malekiyat = _;
                                          },
                                          value: model.malekiyat),
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
                                model.vaziat = _;
                              },
                              value: model.vaziat,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                              label: "نوع جایگاه",
                              items: ["باز", "نیمه بسته", " بسته"],
                              onChange: (_) {
                                model.noeJaygah = _;
                              },
                              value: model.noeJaygah,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                              label: "کیفیت آب",
                              items: ["شور", "شیرین", "لب شور"],
                              onChange: (_) {
                                model.qualityWater = _;
                              },
                              value: model.qualityWater,
                            ),
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
                                model.taminWater = _;
                              },
                              value: model.taminWater,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                              label: "آجر معدنی",
                              items: [
                                "دارد",
                                "ندارد",
                              ],
                              onChange: (_) {
                                model.ajorMadani = _;
                              },
                              value: model.ajorMadani,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                              label: "سنگ نمک",
                              items: [
                                "دارد",
                                "ندارد",
                              ],
                              onChange: (_) {
                                model.sangNamak = _;
                              },
                              value: model.sangNamak,
                            ),
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
                                model.adavat = _;
                              },
                              value: model.adavat,
                            ),
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
                                model.kafJaygah = _;
                              },
                              value: model.kafJaygah,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ImageView(_imagePath, "تصویر جایگاه ",
                                defaultValue: _imagePath.value,
                                canReplace:
                                    widget.addInitialVisitFormModel == null),
                            SizedBox(
                              height: 10,
                            ),
                            ImageView(_imagePath_2, "تصویر راهبر",
                                defaultValue: _imagePath_2.value,
                                canReplace:
                                    widget.addInitialVisitFormModel == null),
                            SizedBox(
                              height: 10,
                            ),
                            ImageView(_imagePath_3, "تصویر متقاضی",
                                defaultValue: _imagePath_3.value,
                                canReplace:
                                    widget.addInitialVisitFormModel == null),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                              label: "وضعیت اجرای طرح",
                              items: [
                                "جایگاه دام مورد تایید نیست",
                                "صلاحیت متقاضی مورد تایید نیست",
                                "آماده اجرای طرح می باشد",
                              ],
                              onChange: (_) {
                                model.status = _;
                              },
                              value: model.status,
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
                              model.sayeban = c ? 1 : 0;
                            }, value: (model.sayeban ?? 0) > 0),
                            TitleCheckBox("عدم حصارکشی مناسب", (c) {
                              model.adamHesar = c ? 1 : 0;
                            }, value: (model.adamHesar ?? 0) > 0),
                            TitleCheckBox(
                                "آسترکشی دیوارهای داخلی جایگاه انجام نشده",
                                (c) {
                              model.astarkeshi = c ? 1 : 0;
                            }, value: (model.astarkeshi ?? 0) > 0),
                            TitleCheckBox("محل نگهداری خوراک دام مناسب نیست",
                                (c) {
                              model.mahalNegahdari = c ? 1 : 0;
                            }, value: (model.mahalNegahdari ?? 0) > 0),
                            TitleCheckBox("عدم وجود آبخور وآبشخور مناسب ", (c) {
                              model.adamAbkhor = c ? 1 : 0;
                            }, value: (model.adamAbkhor ?? 0) > 0),
                            TitleCheckBox("عدم برخورداری جایگاه از نور مناسب ",
                                (c) {
                              model.adamNoor = c ? 1 : 0;
                            }, value: (model.adamNoor ?? 0) > 0),
                            TitleCheckBox("عدم برخورداری جایگاه از تهویه لازم ",
                                (c) {
                              model.adamTahvie = c ? 1 : 0;
                            }, value: (model.adamTahvie ?? 0) > 0),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "سایر ایرادات",
                              value: model.sayer ?? '',
                              maxLine: 4,
                              onChanged: (_) {
                                model.sayer = _;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: model.eghdamat ?? '',
                              label:
                                  "اقدامات قبل از خرید دام (در صورت عدم ایراد جمله نیازی نیست ثبت گردد)",
                              maxLine: 4,
                              onChanged: (_) {
                                model.eghdamat = _;
                              },
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
                        readOnly: widget.addInitialVisitFormModel != null,
                        latLng: model.lon != null
                            ? LatLng(model.lat!, model.lon!)
                            : _latLng.value,
                        onSelected: (_) {
                          _latLng.value = _;
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

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    Progressbar.showProgress();
    var res = await _visitService.saveInitVisit(
      time: time,
      agentInfo: agentInfo.value ?? AgentInfo(),
      model: model,
    );
    if (res) {
      Get.back();
      Get.back();
    }
  }
}
