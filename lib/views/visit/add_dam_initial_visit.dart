import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/add_dam_initial_visit_model.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/widgets/checkBox.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/form/custom_dropownbuttom_formField.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

import '../../model/LivestockCheck.dart';
import '../../services/aut_service.dart';
import '../../widgets/app_sliver_app_bar.dart';
import '../../widgets/buttomSheetTempelate.dart';

class AddDamInitialVisit extends StatefulWidget {
  int? time;
  AddDamInitialVisitRequest? addDamInitialVisitRequest;

  AddDamInitialVisit({this.time, this.addDamInitialVisitRequest, super.key});

  @override
  State<AddDamInitialVisit> createState() => _AddInitialReportState();
}

class _AddInitialReportState extends State<AddDamInitialVisit> {
  final _authService = GetIt.I.get<AutService>();
  late AddDamInitialVisitRequest model;

  @override
  void initState() {
    if (widget.addDamInitialVisitRequest != null) {
      model = widget.addDamInitialVisitRequest!;
      bazdid_img.value = model.bazdidImg!;
      damyar_img.value = model.damyarImg!;
      damdar_img.value = model.damdarImg!;
      jaygah_img.value = model.jaygahImg!;
      _latLng.value = LatLng(model.lat!, model.lon!);
      jaygah_img.value = model.jaygahImg!;
      _items.addAll(model.livestockCheck);
    } else {
      model = AddDamInitialVisitRequest(
          password: _authService.getPasswordForReq,
          username: _authService.getUsernameForReq);
      this.time = widget.time ?? DateTime.now().millisecondsSinceEpoch;
    }

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var time = 0;

  Rxn<LatLng> _latLng = Rxn();
  final _visitService = GetIt.I.get<VisitService>();
  final bazdid_img = "".obs;
  final jaygah_img = "".obs;
  final damdar_img = "".obs;
  final damyar_img = "".obs;
  final _items = <LivestockCheck>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: submitForm(() async {
        if (_formKey.currentState?.validate() ?? false) {
          // _latLng.value = LatLng(0.0, 0.0);
          if (_latLng.value != null) {
            model.lon = _latLng.value!.longitude;
            model.lat = _latLng.value!.latitude;
            model.bazdidImg = bazdid_img.value;
            model.jaygahImg = jaygah_img.value;
            model.damyarImg = damyar_img.value;
            model.damdarImg = damdar_img.value;
            model.livestockCheck = _items;
            if (model.bazdidImg == null ||
                model.bazdidImg!.isEmpty ||
                model.jaygahImg == null ||
                model.jaygahImg!.isEmpty ||
                model.damdarImg == null ||
                model.damdarImg!.isEmpty ||
                model.damyarImg == null ||
                model.damyarImg!.isEmpty) {
              Fluttertoast.showToast(msg: "تصویر را وارد  کنید");
            } else {
              await _submit(context);
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
                              // textEditingController: _nationId,
                              maxLength: 10,
                              value: model.nationalId ?? '',
                              readOnly:
                                  widget.addDamInitialVisitRequest != null,
                              height: 80,
                              onChanged: (_) {
                                model.nationalId = _;
                              },
                              textInputType: TextInputType.number,
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
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
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "نوع جایگاه",
                                items: ["باز", "نیمه بسته", " بسته"],
                                onChange: (_) {
                                  model.jayType = _;
                                },
                                value: model.jayType,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomDropdownButtonFormField(
                                label: "وضعیت تهویه جایگاه",
                                items: ["مناسب", "نامناسب"],
                                onChange: (_) {
                                  model.tahjayType = _;
                                },
                                value: model.tahjayType,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomTextFormField(
                                label: "مساحت",
                                height: 60,
                                value: model.masahat != null
                                    ? model.masahat.toString()
                                    : "",
                                onChanged: (_) {
                                  model.masahat = int.parse(_);
                                },
                                textInputType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomDropdownButtonFormField(
                                label: "حوضچه ضدعفونی ورودی",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  model.hozche = _;
                                },
                                value: model.hozche,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomDropdownButtonFormField(
                                label: "فن تهویه",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  model.tahvie = _;
                                },
                                value: model.tahvie,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomDropdownButtonFormField(
                                label: "کف جایگاه",
                                items: ["سیمانی", "خاکی", "آجری", "موراییک"],
                                onChange: (_) {
                                  model.kafJay = _;
                                },
                                value: model.kafJay,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomDropdownButtonFormField(
                                label: "وضعیت آبخور و آبشخور",
                                items: ["ثابت", "سیار", "ندارد"],
                                onChange: (_) {
                                  model.abkhorStatus = _;
                                },
                                value: model.abkhorStatus,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              CustomDropdownButtonFormField(
                                label: "وضعیت محل نگهداری خوراک",
                                items: [
                                  "سوله",
                                  "زاغه",
                                  "فضای باز",
                                  "سازه سنتی",
                                  "ندارد"
                                ],
                                onChange: (_) {
                                  model.nhdWarehouse = _;
                                },
                                value: model.nhdWarehouse,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "آسترکشی دیوارهای داخلی",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  model.astar = _;
                                },
                                value: model.astar,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "وضعیت کلی جایگاه",
                                items: [
                                  "مناسب",
                                  "نامناسب",
                                  "نیازمند بهسازی آخور",
                                  "نیازمند بهسازی کف",
                                ],
                                onChange: (_) {
                                  model.vazeiat = _;
                                },
                                value: model.vazeiat,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "کیفیت آب",
                                items: [
                                  "مناسب",
                                  "نامناسب",
                                ],
                                onChange: (_) {
                                  model.waterQuality = _;
                                },
                                value: model.waterQuality,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "منبع تامین آب",
                                items: [
                                  "موارد دیگر",
                                  "چاه",
                                  "شرب روستایی",
                                ],
                                onChange: (_) {
                                  model.waterSource = _;
                                },
                                value: model.waterSource,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "سایه بان",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  model.sayeban = _;
                                },
                                value: model.sayeban,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                label: "سم پاش",
                                items: [
                                  "دارد",
                                  "ندارد",
                                ],
                                onChange: (_) {
                                  model.sampash = _;
                                },
                                value: model.sampash,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                label: "وضعیت مرتع و پروانه چرا",
                                maxLine: 3,
                                value: model.martaStatus ?? "",
                                onChanged: (_) {
                                  model.martaStatus = _;
                                },
                                // textInputType: TextInputType.number,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageView(jaygah_img, "تصویر جایگاه ",
                                  defaultValue: jaygah_img.value,
                                  canReplace: true),
                              SizedBox(
                                height: 10,
                              ),
                              ImageView(
                                damdar_img,
                                "تصویر دامدار",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageView(
                                damyar_img,
                                "تصویر دامیار",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ImageView(
                                bazdid_img,
                                "تصویر بازدید",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InputDecorator(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "اطلاعات دام",
                              labelStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          child: Column(
                            children: [
                              Obx(() => ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: _items.length,
                                    itemBuilder: (c, i) {
                                      var item = _items.value[i];
                                      return Container(
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text("${i + 1}-"),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(item.dam ?? ""),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      _addOrEditDam(
                                                          lk: item, i: i);
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: 15,
                                                    )),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      _items.removeAt(i);
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 15,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              TextButton(
                                  onPressed: () {
                                    _addOrEditDam();
                                  },
                                  child: Text(" اضافه کردن دام جدید +"))
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SelectLocation(
                        readOnly: false,
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

  void _addOrEditDam({LivestockCheck? lk, int? i}) {
    final _formKey = GlobalKey<FormState>();
    LivestockCheck livestockCheck = LivestockCheck();
    if (lk != null) {
      livestockCheck = lk;
    }
    Get.bottomSheet(
        isScrollControlled: true,
        bottomSheetTemplate(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height * 0.6,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      CustomDropdownButtonFormField(
                        label: "گونه دام",
                        items: [
                          "میش",
                          "توقولی",
                          "قوچ",
                          "بره نر",
                          "بره ماده",
                          "بره شیری",
                          "بز ماده",
                          "کولار",
                          "بز نر",
                          "بزغاله نر",
                          "بزغاله ماده",
                          "بزغاله شیری",
                        ],
                        onChange: (_) {
                          livestockCheck.dam = _;
                        },
                        value: livestockCheck.dam,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        label: "تعداد راس دام",
                        textInputType: TextInputType.number,
                        value: (livestockCheck.raas ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.raas = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                          future: GetIt.I.get<ShopService>().fetchBreeds(""),
                          builder: (c, s) {
                            if (s.hasData &&
                                s.data != null &&
                                s.data!.isNotEmpty) {
                              return SizedBox(
                                  height: 70,
                                  child: DropdownSearch<String>(
                                      popupProps: PopupProps.menu(
                                        searchDelay: Duration(milliseconds: 40),

                                        showSelectedItems: true,
                                        showSearchBox: true,
                                        fit: FlexFit.tight,
                                        // disabledItemFn: (String s) => s.startsWith('I'),
                                      ),
                                      items: (_, __) =>
                                          s.data!.map((e) => e).toList(),
                                      itemAsString: (item) => item ?? '',

                                      // compareFn:
                                      //     (item1, item2) =>
                                      // item1.name ==
                                      //     item2.name,
                                      decoratorProps: DropDownDecoratorProps(
                                        decoration: InputDecoration(
                                          labelText: "نژاد قالب دام",
                                          labelStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black38),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 2, color: Colors.red),
                                            //<-- SEE HERE
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      onChanged: (_) {
                                        if (_ != null) {
                                          livestockCheck.nzd = _;
                                        }
                                      },
                                      selectedItem: livestockCheck.nzd));
                            } else if (s.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Center(
                                child: Text(
                                    "دریافت لیست نژاد با خطا مواجه شده است!"));
                          }),
                      CustomTextFormField(
                        label: "وضعیت بدنی(BCS)",
                        textInputType: TextInputType.number,
                        value: (livestockCheck.bcs ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.bcs = double.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        label: "میانگین سن(ماه)",
                        value: (livestockCheck.age ?? "").toString(),
                        textInputType: TextInputType.number,
                        onChanged: (_) {
                          livestockCheck.age = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        label: "شماره پلاک(از-تا)",
                        value: (livestockCheck.plk ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.plk = _;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("سقط و مرده زایی", (c) {
                        livestockCheck.segt = c ? 1 : 0;
                      }, value: (livestockCheck.segt ?? 0) == 1 ? true : false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد سقط",
                        value: (livestockCheck.segtNo ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.segtNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("قارچ/جرب", (c) {
                        livestockCheck.shepesh = c ? 1 : 0;
                      },
                          value: (livestockCheck.shepesh ?? 0) == 1
                              ? true
                              : false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد قارچ",
                        value: (livestockCheck.shepeshNo ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.shepeshNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("ضعف و لاغری مفرط", (c) {
                        livestockCheck.zaf = c ? 1 : 0;
                      }, value: (livestockCheck.zaf ?? 0) == 1 ? true : false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد ضعف",
                        value: (livestockCheck.zafNo ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.zafNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("لنگش", (c) {
                        livestockCheck.langesh = c ? 1 : 0;
                      },
                          value: (livestockCheck.langesh ?? 0) == 1
                              ? true
                              : false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد لنگش",
                        value: (livestockCheck.langeshNo ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.langeshNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("آسیب چشمی", (c) {
                        // livestockCheck. = c ? 1 : 0;
                      }, value: false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد آسیب چشمی",
                        onChanged: (_) {
                          // livestockCheck.langeshNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("پیکا/پشم خواری", (c) {
                        livestockCheck.pica = c ? 1 : 0;
                      }, value: (livestockCheck.pica ?? 0) == 1 ? true : false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد پیکا",
                        value: (livestockCheck.picaNo ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.picaNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleCheckBox("سرفه", (c) {
                        livestockCheck.sorfe = c ? 1 : 0;
                      },
                          value:
                              (livestockCheck.sorfe ?? 0) == 1 ? true : false),
                      SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        label: "تعداد سرفه",
                        value: (livestockCheck.shepeshNo ?? "").toString(),
                        onChanged: (_) {
                          livestockCheck.shepeshNo = int.tryParse(_);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      if (lk != null) {
                        _items.value[i!] = livestockCheck;
                      } else {
                        if (livestockCheck.dam?.isNotEmpty ?? false) {
                          _items.add(livestockCheck);
                        }
                      }

                      Navigator.pop(context);
                    },
                    child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Center(
                            child: Text(
                          lk != null ? "ویرایش" : "اضافه کردن",
                          style: TextStyle(color: Colors.white),
                        )))),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        )));
  }

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    Progressbar.showProgress();
    model.livestockCheck = _items.value;
    var res = await _visitService.saveDamInitVisit(
      time: time,
      agentInfo: AgentInfo(),
      model: model,
    );
    if (res) {
      Get.back();
      Get.back();
    }
  }
}
