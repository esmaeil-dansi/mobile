import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/add_vetvisit_form_model.dart';
import 'package:frappe_app/repo/file_repo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/utils/int_bool_converter.dart';
import 'package:frappe_app/widgets/agent_info_widget.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/checkBox.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/form/custom_dropownbuttom_formField.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import '../../model/agentInfo.dart';
import '../../widgets/image_view.dart';

class AddVetVisit extends StatefulWidget {
  AddVetVisitFormModel? addVetVisitFormModel;
  int? time;

  AddVetVisit({this.addVetVisitFormModel, this.time});

  @override
  State<AddVetVisit> createState() => _AddVetVisitState();
}

class _AddVetVisitState extends State<AddVetVisit> {
  int time = 0;
  final _formKey = GlobalKey<FormState>();
  late AddVetVisitFormModel model;

  @override
  void initState() {
    if (widget.addVetVisitFormModel != null) {
      licenseSalamat.value = widget.addVetVisitFormModel?.licenseSalamat ?? "";
      this._nationId.text = widget.addVetVisitFormModel!.nationalId ?? '';
      _latLng = LatLng(
          widget.addVetVisitFormModel!.lat!, widget.addVetVisitFormModel!.lon!);
      licenseSalamat.value = widget.addVetVisitFormModel!.licenseSalamat ?? '';
      imageDam.value = widget.addVetVisitFormModel!.imageDam ?? '';
      imageDam1.value = widget.addVetVisitFormModel!.imageDam2 ?? '';
      imageDam2.value = widget.addVetVisitFormModel!.imageDam3 ?? '';
      imageDam3.value = widget.addVetVisitFormModel!.imageDam3 ?? '';
      _fetchAgentInfo();
    }
    time = widget.time ?? DateTime.now().millisecondsSinceEpoch;
    model = widget.addVetVisitFormModel ?? AddVetVisitFormModel();
    super.initState();
  }

  LatLng? _latLng;
  final _bime = 0.obs;

  var imageDam = "".obs;
  var imageDam1 = "".obs;
  var imageDam2 = "".obs;
  var imageDam3 = "".obs;
  var licenseSalamat = "".obs;

  final _visitService = GetIt.I.get<VisitService>();

  Rxn<AgentInfo> agentInfo = Rxn();

  final _nationId = TextEditingController();

  void _fetchAgentInfo() {
    this
        ._visitService
        .getAgentInfo(_nationId.text)
        .then((value) => agentInfo.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: submitForm(
        () async {
          if (widget.addVetVisitFormModel != null) {
            await _submit(context);
          } else {
            if (_formKey.currentState?.validate() ?? false) {
              if (_latLng == null) {
                Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
              } else {
                if (imageDam.isEmpty ||
                    licenseSalamat.isEmpty ||
                    imageDam1.isEmpty ||
                    imageDam3.isEmpty ||
                    imageDam2.isEmpty) {
                  Fluttertoast.showToast(msg: "تصویر را وارد  کنید");
                } else {
                  await _submit(context);
                }
              }
            } else {
              Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
            }
          }
        },
      ),
      appBar: appSliverAppBar(
        "ویزیت دامپزشکی جدید",
        // bottom: TabBar(
        //   tabs: [
        //     Tab(
        //       text: "صفحه 1",
        //     ),
        //     Tab(
        //       text: "صفحه 2",
        //     ),
        //     Tab(
        //       text: "صفحه 3",
        //     ),
        //     Tab(
        //       text: " صدور گواهی",
        //     )
        //   ],
        // )
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                            labelText: "اطلاعات دامپزشک",
                            labelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "نام ونام خانوادگی دامپزشک",
                              height: 80,
                              value: model.nameDamp ?? '',
                              onChanged: (_) {
                                model.nameDamp = _;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "کد نظام مهندسی دامپزشکی",
                              height: 80,
                              value: model.codeN ?? '',
                              onChanged: (_) {
                                model.codeN = _;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "کد ملی کارشناس/دامپزشک",
                              height: 80,
                              value: model.nationalIdDoc ?? '',
                              onChanged: (_) {
                                model.nationalIdDoc = _;
                              },
                              textInputType: TextInputType.number,
                            ),
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
                            labelText: "اطلاعات بیمه",
                            labelStyle: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            TitleCheckBox("بیمه دارد یا ندارد؟", (c) {
                              _bime.value = c ? 1 : 0;
                              model.bime = _bime.value;
                            }, value: intToBool(model.bime)),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() => _bime.value == 1
                                ? TitleCheckBox("پلاک شده است یا خیر؟", (c) {
                                    model.pelak = c ? 1 : 0;
                                  }, value: intToBool(model.pelak))
                                : SizedBox.shrink()),
                            SizedBox(
                              height: 5,
                            ),
                            CustomTextFormField(
                              label: "شماره پلاک از",
                              height: 80,
                              value: model.pelakAz ?? '',
                              onChanged: (_) {
                                model.pelakAz = _;
                              },
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "شماره پلاک تا ",
                              height: 80,
                              value: model.pelakTa ?? '',
                              onChanged: (_) {
                                model.pelakTa = _;
                              },
                              textInputType: TextInputType.number,
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
                          labelText: "اطلاعات متقاضی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              label: "کد ملی",
                              textEditingController: _nationId,
                              maxLength: 10,
                              readOnly: widget.addVetVisitFormModel != null,
                              value: _nationId.text,
                              height: 80,
                              onChanged: (_) {
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
                            CustomDropdownButtonFormField(
                                value: model.galleh,
                                label: " ترکیب گله",
                                items: [
                                  "گوسفند و بز(ترکیبی)",
                                  "گوسفند",
                                  "بز",
                                  "گوساله پرواری",
                                  "تلیسه",
                                  "گاو شیری",
                                  "شتر",
                                  "مرغ بومی",
                                  "سایر",
                                ],
                                onChange: (_) {
                                  model.galleh = _;
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.galleD ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "جمعیت گله (راس -نفر)",
                              onChanged: (_) {
                                model.galleD = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.age ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "میانگین سن گله",
                              onChanged: (_) {
                                model.age = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت دندان ها",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.teeth1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دندان سالم",
                              onChanged: (_) {
                                model.teeth1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.teeth2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دندان شکسته",
                              onChanged: (_) {
                                model.teeth2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.teeth3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دندان عفونی",
                              onChanged: (_) {
                                model.teeth3 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت چشم ها",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.eye1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس هردو جشم سالم",
                              onChanged: (_) {
                                model.eye1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.eye2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس کدورت",
                              onChanged: (_) {
                                model.eye2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.eye3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس خروج ترشحات",
                              onChanged: (_) {
                                model.eye3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.eye4 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس ملتهب",
                              onChanged: (_) {
                                model.eye4 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.eye5 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس کوری",
                              onChanged: (_) {
                                model.eye5 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "سمع صداهای تنفسی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.breth1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با رال مرطوب",
                              onChanged: (_) {
                                model.breth1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.breth2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با رال خشک",
                              onChanged: (_) {
                                model.breth2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.breth3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با هر دو ریه طبیعی",
                              onChanged: (_) {
                                model.breth3 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت عشاهای محاطی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mucus1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با مخاط صورتی",
                              onChanged: (_) {
                                model.mucus1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mucus2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با مخاط سفید",
                              onChanged: (_) {
                                model.mucus2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mucus3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با مخاط زرد",
                              onChanged: (_) {
                                model.mucus3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mucus4 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با سینوتیک",
                              onChanged: (_) {
                                model.mucus4 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mucus5 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با نقاط خونریزی",
                              onChanged: (_) {
                                model.mucus5 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "گوش ها",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.ear1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با افتادگی گوش یک طرفه",
                              onChanged: (_) {
                                model.ear1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.ear2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با گوش طبیعی",
                              onChanged: (_) {
                                model.ear2 = int.parse(_);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت پوشش خارجی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.skin1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس موریختگی موضعی",
                              onChanged: (_) {
                                model.skin1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.skin2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با خارش موضعی",
                              onChanged: (_) {
                                model.skin2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.skin3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با التهاب موضعی",
                              onChanged: (_) {
                                model.skin3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.skin4 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با زخم سطحی",
                              onChanged: (_) {
                                model.skin4 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.skin5 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با آبسه",
                              onChanged: (_) {
                                model.skin5 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.skin6 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با فتق",
                              onChanged: (_) {
                                model.skin6 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت آلودگی دام به انگل خارجی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.leech1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس شدیدا آلوده انگل",
                              onChanged: (_) {
                                model.leech1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.leech2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با آلودگی انگل متوسط",
                              onChanged: (_) {
                                model.leech2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.leech3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس بدون آلودگی انگل",
                              onChanged: (_) {
                                model.leech3 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت ضایعات و زخم های دهانی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.mouth1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: " تعداد راس تاولی",
                              onChanged: (_) {
                                model.mouth1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mouth2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس اکتیمایی",
                              onChanged: (_) {
                                model.mouth2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mouth3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس زخم عفونی",
                              onChanged: (_) {
                                model.mouth3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.mouth4 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس بدون زخم وضایعات",
                              onChanged: (_) {
                                model.mouth4 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت سم ها",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.hoof1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس سم چینی شده",
                              onChanged: (_) {
                                model.hoof1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.hoof2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس سم چینی نشده",
                              onChanged: (_) {
                                model.hoof2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.hoof3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با عفونت سم",
                              onChanged: (_) {
                                model.hoof3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.hoof4 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دارای لنگش",
                              onChanged: (_) {
                                model.hoof4 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت ادرار ومدفوع",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.urine1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دارای اسهال",
                              onChanged: (_) {
                                model.urine1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.urine2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دارای خونشاش",
                              onChanged: (_) {
                                model.urine2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.urine3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با ادرار ومدفوع طبیعی",
                              onChanged: (_) {
                                model.urine3 = int.parse(_);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت غدد لنفاوی",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.nodes1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با غدد متورم",
                              onChanged: (_) {
                                model.nodes1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.nodes2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس بدون غدد متورم",
                              onChanged: (_) {
                                model.nodes2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.nodes3 ?? '').toString(),
                              textInputType: TextInputType.text,
                              label: "نام غده (در صورت وجود غده)",
                              onChanged: (_) {
                                model.nodes3 = _;
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت تاج وریش",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.crown1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد  با تاج وریش طبیعی",
                              onChanged: (_) {
                                model.crown1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.crown2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد  با تاج وریش پرخون",
                              onChanged: (_) {
                                model.crown2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.crown3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد  سیانوتیک",
                              onChanged: (_) {
                                model.crown3 = int.parse(_);
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
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "وضعیت کف پای طیور",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              value: (model.sole1 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد با کف پای طبیعی",
                              onChanged: (_) {
                                model.sole1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.sole2 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد با کف پای زخمی و خراش دار",
                              onChanged: (_) {
                                model.sole2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              value: (model.sole3 ?? '').toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد بامبل",
                              onChanged: (_) {
                                model.sole3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
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
                      child: Column(
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
                              value: model.types,
                              onChange: (_) {
                                model.types = _;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            value: (model.number ?? '').toString(),
                            textInputType: TextInputType.number,
                            label: "تعداد (راس یا قطعه)",
                            onChanged: (_) {
                              model.number = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomDropdownButtonFormField(
                              label: "وضعیت نهایی",
                              items: [
                                "مورد تایید است",
                                "مورد تایید نیست",
                              ],
                              value: model.result,
                              onChange: (_) {
                                model.result = _;
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(imageDam, "تصویر دام",
                        defaultValue: model.imageDam,
                        canReplace: widget.addVetVisitFormModel == null),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(imageDam1, "تصویر جایگاه",
                        defaultValue: model.imageDam1,
                        canReplace: widget.addVetVisitFormModel == null),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(imageDam2, "تصویر راهبر",
                        defaultValue: model.imageDam2,
                        canReplace: widget.addVetVisitFormModel == null),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(imageDam3, "تصویر متقاضی",
                        defaultValue: model.imageDam3,
                        canReplace: widget.addVetVisitFormModel == null),
                    ImageView(licenseSalamat, "گواهی تایید سلامت",
                        defaultValue: model.licenseSalamat,
                        canReplace: widget.addVetVisitFormModel == null),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomTextFormField(
                        value: model.disapprovalReason ?? '',
                        maxLine: 3,
                        label: "دلایل عدم تایید",
                        onChanged: (_) {
                          model.disapprovalReason = _;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SelectLocation(
                        latLng: _latLng,
                        readOnly: widget.addVetVisitFormModel != null,
                        onSelected: (_) {
                          _latLng = _;
                        },
                      ),
                    )
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
    model.imageDam1 = imageDam1.value;
    model.imageDam2 = imageDam2.value;
    model.imageDam3 = imageDam3.value;
    model.imageDam = imageDam.value;
    model.licenseSalamat = licenseSalamat.value;
    model.lon = _latLng!.longitude;
    model.lat = _latLng!.latitude;
    Progressbar.showProgress();
    var res = await _visitService.saveVetVisit(
      agentInfo: agentInfo.value ?? AgentInfo(),
      time: time,
      model: model,
    );
    if (res) {
      Get.back();
      Get.back();
    }
  }
}
