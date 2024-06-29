import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/visit_service.dart';
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
                                  onChanged: (_) {
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
                                  outbreak.text = _;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                label: "نام بیماری و تشخیص پزشک",
                                maxLine: 4,
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
                                    stable_condition = _;
                                  }),
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
                                    manger = _;
                                  }),
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
                                    losses = _;
                                  }),

                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 70,
                                child: DropdownButtonFormField<String>(
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
                                    bazdid = (int.parse(value!) + 1).toString();
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
                              ), //todo

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
                                  water = _;
                                },
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
                                  supply_situation = _;
                                },
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
                                  ventilation = _;
                                },
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
                                  vaziat = _;
                                },
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
                              ), //todo
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
          ),
        ));
  }
}
