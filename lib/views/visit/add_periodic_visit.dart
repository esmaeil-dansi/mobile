import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/add_per_vsiti_form_model.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/repo/file_repo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/utils/date_mapper.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
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

class AddPeriodicReport extends StatefulWidget {
  int? time;
  AddPerVisitFormModel? addPerVisitFormModel;

  AddPeriodicReport({this.addPerVisitFormModel, this.time});

  @override
  State<AddPeriodicReport> createState() => _AddPeriodicReportState();
}

class _AddPeriodicReportState extends State<AddPeriodicReport> {
  int time = 0;
  late AddPerVisitFormModel model;

  var _fileRepo = GetIt.I.get<FileRepo>();

  Future<void> _fetchImages() async {
    _fileRepo.getFile(widget.time.toString() + "image").then((_) {
      if (_ != null) {
        imagePath.value = _;
      }
    });
  }

  @override
  void initState() {
    if (widget.addPerVisitFormModel != null) {
      model = widget.addPerVisitFormModel!;
      _dateController.text = DateMapper.convert(model.date ?? '');
      _nextDateController.text = DateMapper.convert(model.nextDate ?? '');
      _latLng = LatLng(model.lat!, model.lon!);
      imagePath.value = model.image ?? "";
      _nationId.text = model.nationalId!;
      _fetchAgentInfo();
      _fetchImages();
    } else {
      model = AddPerVisitFormModel();
    }
    time = widget.time ?? DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  final _dateController = TextEditingController();

  final _nextDateController = TextEditingController();
  final _visitService = GetIt.I.get<VisitService>();
  var imagePath = "".obs;

  final _nationId = TextEditingController();

  LatLng? _latLng;
  final _formKey = GlobalKey<FormState>();
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
          if (_formKey.currentState?.validate() ?? false) {
            if (_latLng != null) {
              model.lat = _latLng!.latitude;
              model.lon = _latLng!.longitude;
              if (imagePath.value.isEmpty) {
                Fluttertoast.showToast(msg: "عکس را وارد  کنید");
              } else {
                FocusScope.of(context).unfocus();
                model.image = imagePath.value;
                Progressbar.showProgress();
                var res = await _visitService.sendPeriodicVisits(
                  addPerVisitFormModel: model,
                  time: time,
                  agentInfo: agentInfo.value ?? AgentInfo(),
                );
                Progressbar.dismiss();
                if (res) {
                  Get.back();
                }
              }
            } else {
              Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
            }
          } else {
            Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
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
                              labelText: "اطلاعات بازدید",
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
                                  readOnly: widget.addPerVisitFormModel != null,
                                  onChanged: (_) {
                                    model.nationalId = _;
                                    if (_.length == 10) {
                                      _fetchAgentInfo();
                                    }
                                  },
                                  textInputType: TextInputType.number,
                                  value: _nationId.text),
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
                              CustomDropdownButtonFormField(
                                label: "شروع بیماری در گله ؟",
                                items: [
                                  "بله",
                                  "خیر",
                                ],
                                onChange: (_) {
                                  model.outbreak = _;
                                },
                                value: model.outbreak,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                label: "نام بیماری و تشخیص پزشک",
                                maxLine: 4,
                                value: model.description_p ?? '',
                                onChanged: (_) {
                                  model.description_p = _;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropdownButtonFormField(
                                label: "وضعیت بستر",
                                items: [
                                  "تمیز",
                                  "متوسط",
                                  "کثیف",
                                ],
                                onChange: (_) {
                                  model.stableCondition = _;
                                },
                                value: model.stableCondition,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropdownButtonFormField(
                                label: "وضعیت آخورها",
                                items: [
                                  "تمیز و مرتب",
                                  "آلوده",
                                ],
                                onChange: (_) {
                                  model.manger = _;
                                },
                                value: model.manger,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropdownButtonFormField(
                                label: " وجود تلفات درگله",
                                items: [
                                  "بله",
                                  "خیر",
                                ],
                                onChange: (_) {
                                  model.losses = _;
                                },
                                value: model.losses,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 70,
                                child: DropdownButtonFormField<String>(
                                  value: model.bazdid,
                                  validator: (_) {},
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
                                    model.bazdid =
                                        (int.parse(value!) + 1).toString();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                label:
                                    "تعداد تلفات و نظر دامپزشک در کالبدگشایی",
                                maxLine: 4,
                                value: model.description_l ?? '',
                                onChanged: (_) {
                                  model.description_l = _;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropdownButtonFormField(
                                items: [
                                  "تمیز",
                                  "کثیف",
                                ],
                                label: " وضعیت آبشخورها",
                                onChange: (_) {
                                  model.water = _;
                                },
                                value: model.water,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropdownButtonFormField(
                                items: [
                                  "مرتب و تمیز",
                                  "آلوده و نا مرتب",
                                  "آذوقه در حال فساد",
                                ],
                                label: " وضعیت انبار آذوقه",
                                onChange: (_) {
                                  model.supplySituation = _;
                                },
                                value: model.supplySituation,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomDropdownButtonFormField(
                                items: [
                                  "مناسب",
                                  "نامناسب",
                                ],
                                label: " وضعیت تهویه",
                                onChange: (_) {
                                  model.ventilation = _;
                                },
                                value: model.ventilation,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ImageView(imagePath, "تصویر جایگاه دام",
                          defaultValue: imagePath.value,
                          canReplace: widget.addPerVisitFormModel == null),
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
                              labelText: "وضعیت طرح",
                              labelStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              CustomDropdownButtonFormField(
                                items: ["انحراف از طرح", "فعال"],
                                label: "وضعیت طرح",
                                onChange: (_) {
                                  model.vaziat = _;
                                },
                                value: model.vaziat,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(),
                              SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                label: "علت(در صورت وجود انحراف)",
                                value: model.enheraf ?? '',
                                onChanged: (_) {
                                  model.enheraf = _;
                                },
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
                                  latLng: _latLng,
                                  readOnly: widget.addPerVisitFormModel != null,
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
                                    model.date = _;
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
                                    model.nextDate = _;
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
          ),
        ));
  }
}
