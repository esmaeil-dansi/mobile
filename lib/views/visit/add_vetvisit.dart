import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/visit_service.dart';
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
  @override
  State<AddVetVisit> createState() => _AddVetVisitState();
}

class _AddVetVisitState extends State<AddVetVisit> {
  int time = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    time = DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  LatLng? _latLng;
  final _bime = 0.obs;

  final _pelak = 0.obs;

  var _noe_dam = "";

  var _status = "";

  var animal_image = "".obs;

  var certificate_image = "".obs;

  final _visitService = GetIt.I.get<VisitService>();

  String name_dam = "";

  String code_n = "";

  String national_id_doc = "";

  String pelak_az = "";

  String pelak_ta = "";

  String galleh = "";

  int galle_d = 0;

  int age = 0;

  int teeth_1 = 0;

  int teeth_2 = 0;

  int teeth_3 = 0;

  int eye_1 = 0;

  int eye_2 = 0;

  int eye_3 = 0;

  int eye_4 = 0;

  int eye_5 = 0;

  int breth_1 = 0;

  int breth_2 = 0;

  int breth_3 = 0;

  int mucus_1 = 0;

  int mucus_2 = 0;

  int mucus_3 = 0;

  int mucus_4 = 0;

  int mucus_5 = 0;

  int ear_1 = 0;

  int ear_2 = 0;

  int skin_1 = 0;

  int skin_2 = 0;

  int skin_3 = 0;

  int skin_4 = 0;

  int skin_5 = 0;

  int skin_6 = 0;

  int leech_1 = 0;

  int leech_2 = 0;

  int leech_3 = 0;

  int mouth_1 = 0;

  int mouth_2 = 0;

  int mouth_3 = 0;

  int mouth_4 = 0;

  int hoof_1 = 0;

  int hoof_2 = 0;

  int hoof_3 = 0;

  int hoof_4 = 0;

  int urine_1 = 0;

  int urine_2 = 0;

  int urine_3 = 0;

  int nodes_1 = 0;

  int nodes_2 = 0;

  String nodes_3 = "";

  int crown_1 = 0;

  int crown_2 = 0;

  int crown_3 = 0;

  int sole_1 = 0;

  int sole_2 = 0;

  int sole_3 = 0;

  int number = 0;

  String disapproval_reason = "";

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
          if (_formKey.currentState?.validate() ?? false) {
            if (_latLng == null) {
              Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
            } else {
              Progressbar.showProgress();
              var res = await _visitService.saveVetVisit(
                agentInfo: agentInfo.value ?? AgentInfo(),
                image_dam: animal_image.value,
                license_salamat: certificate_image.value,
                name_damp: name_dam,
                code_n: code_n,
                disapproval_reason: disapproval_reason,
                bime: _bime.value,
                latLng: _latLng!,
                pelak: _pelak.value,
                nationId: _nationId.text,
                pelak_az: pelak_az,
                pelak_ta: pelak_ta,
                result: _status,
                types: _noe_dam,
                galleh: galleh,
                galle_d: galle_d,
                age: age,
                national_id_doc: national_id_doc,
                teeth_1: teeth_1,
                teeth_2: teeth_2,
                teeth_3: teeth_3,
                eye_1: eye_1,
                eye_2: eye_2,
                eye_3: eye_3,
                eye_5: eye_5,
                eye_4: eye_4,
                breth_1: breth_1,
                breth_2: breth_2,
                breth_3: breth_3,
                mucus_1: mucus_1,
                mucus_2: mucus_2,
                mucus_3: mucus_3,
                mucus_4: mucus_4,
                mucus_5: mucus_5,
                ear_1: ear_1,
                ear_2: ear_2,
                skin_1: skin_1,
                skin_2: skin_2,
                skin_3: skin_3,
                skin_4: skin_4,
                skin_5: skin_5,
                skin_6: skin_6,
                leech_1: leech_1,
                leech_2: leech_2,
                leech_3: leech_3,
                mouth_1: mouth_1,
                mouth_2: mouth_2,
                mouth_3: mouth_3,
                mouth_4: mouth_4,
                hoof_1: hoof_1,
                hoof_2: hoof_2,
                hoof_3: hoof_3,
                hoof_4: hoof_4,
                urine_1: urine_1,
                urine_2: urine_2,
                urine_3: urine_3,
                nodes_1: nodes_1,
                nodes_2: nodes_2,
                nodes_3: nodes_3,
                crown_1: crown_1,
                crown_2: crown_2,
                crown_3: crown_3,
                sole_1: sole_1,
                sole_2: sole_2,
                sole_3: sole_3,
                number: number,
                time: time,
              );
              Progressbar.dismiss();
              if (res) {
                Get.back();
              }
            }
          } else {
            Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
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
              margin:
                  EdgeInsets.only(left: 7, right: 7, top: 9, bottom: 90),
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "نام ونام خانوادگی دامپزشک",
                              height: 80,
                              // value: name_dam,
                              onChanged: (_) {
                                name_dam = _;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "کد نظام مهندسی دامپزشکی",
                              height: 80,
                              // value: code_n,
                              onChanged: (_) {
                                code_n = _;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "کد ملی کارشناس/دامپزشک",
                              height: 80,
                              // value: national_id_doc,
                              onChanged: (_) {
                                national_id_doc = _;
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
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            TitleCheckBox("بیمه دارد یا ندارد؟", (c) {
                              _bime.value = c ? 1 : 0;
                            }),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(() => _pelak.value == 1
                                ? TitleCheckBox("پلاک شده است یا خیر؟",
                                    (c) {
                                    _pelak.value = c ? 1 : 0;
                                  })
                                : SizedBox.shrink()),
                            SizedBox(
                              height: 5,
                            ),
                            CustomTextFormField(
                              label: "شماره پلاک از",
                              height: 80,
                              // value: pelak_az,
                              onChanged: (_) {
                                pelak_az = _;
                              },
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              label: "شماره پلاک تا ",
                              height: 80,
                              // value: pelak_ta,
                              onChanged: (_) {
                                pelak_ta = _;
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
                              // value: _nationId.text,
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
                                        maxLine: 3,
                                        value: agentInfo.value!.city,
                                        label: "شهرستان",
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
                                        value:
                                            agentInfo.value!.department,
                                        label: "اداره کمیته امداد",
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()),
                            SizedBox(
                              height: 10,
                            ),
                            CustomDropdownButtonFormField(
                                value: galleh.isNotEmpty ? galleh : null,
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
                                  galleh = _;
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              // value: galle_d.toString(),
                              textInputType: TextInputType.number,
                              label: "جمعیت گله (راس -نفر)",
                              onChanged: (_) {
                                galle_d = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              // value: age.toString(),
                              textInputType: TextInputType.number,
                              label: "میانگین سن گله",
                              onChanged: (_) {
                                age = int.parse(_);
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
                              // value: teeth_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دندان سالم",
                              onChanged: (_) {
                                teeth_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: teeth_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دندان شکسته",
                              onChanged: (_) {
                                teeth_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: teeth_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دندان عفونی",
                              onChanged: (_) {
                                teeth_3 = int.parse(_);
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
                              // value: eye_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس هردو جشم سالم",
                              onChanged: (_) {
                                eye_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: eye_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس کدورت",
                              onChanged: (_) {
                                eye_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              textInputType: TextInputType.number,
                              label: "تعداد راس خروج ترشحات",
                              onChanged: (_) {
                                eye_3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              textInputType: TextInputType.number,
                              label: "تعداد راس ملتهب",
                              onChanged: (_) {
                                eye_4 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              textInputType: TextInputType.number,
                              label: "تعداد راس کوری",
                              onChanged: (_) {
                                eye_5 = int.parse(_);
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
                              // value: breth_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با رال مرطوب",
                              onChanged: (_) {
                                breth_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //value: breth_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با رال خشک",
                              onChanged: (_) {
                                breth_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //   value: breth_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با هر دو ریه طبیعی",
                              onChanged: (_) {
                                breth_3 = int.parse(_);
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
                              // value: mucus_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با مخاط صورتی",
                              onChanged: (_) {
                                mucus_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: mucus_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با مخاط سفید",
                              onChanged: (_) {
                                mucus_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //  value: mucus_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با مخاط زرد",
                              onChanged: (_) {
                                mucus_3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //  value: mucus_4.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با سینوتیک",
                              onChanged: (_) {
                                mucus_4 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: mucus_5.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با نقاط خونریزی",
                              onChanged: (_) {
                                mucus_5 = int.parse(_);
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
                              //value: ear_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با افتادگی گوش یک طرفه",
                              onChanged: (_) {
                                ear_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //value: ear_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با گوش طبیعی",
                              onChanged: (_) {
                                ear_2 = int.parse(_);
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
                              //  value: skin_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس موریختگی موضعی",
                              onChanged: (_) {
                                skin_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //value: skin_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با خارش موضعی",
                              onChanged: (_) {
                                skin_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: skin_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با التهاب موضعی",
                              onChanged: (_) {
                                skin_3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //  value: skin_4.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با زخم سطحی",
                              onChanged: (_) {
                                skin_4 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: skin_5.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با آبسه",
                              onChanged: (_) {
                                skin_5 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: skin_6.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با فتق",
                              onChanged: (_) {
                                skin_6 = int.parse(_);
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
                              //value: leech_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس شدیدا آلوده انگل",
                              onChanged: (_) {
                                leech_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //  value: leech_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با آلودگی انگل متوسط",
                              onChanged: (_) {
                                leech_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: leech_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس بدون آلودگی انگل",
                              onChanged: (_) {
                                leech_3 = int.parse(_);
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
                              //   value: mouth_1.toString(),
                              textInputType: TextInputType.number,
                              label: " تعداد راس تاولی",
                              onChanged: (_) {
                                mouth_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: mouth_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس اکتیمایی",
                              onChanged: (_) {
                                mouth_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: mouth_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس زخم عفونی",
                              onChanged: (_) {
                                mouth_3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //    value: mouth_4.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس بدون زخم وضایعات",
                              onChanged: (_) {
                                mouth_4 = int.parse(_);
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
                              //value: hoof_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس سم چینی شده",
                              onChanged: (_) {
                                hoof_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: hoof_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس سم چینی نشده",
                              onChanged: (_) {
                                hoof_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //value: hoof_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با عفونت سم",
                              onChanged: (_) {
                                hoof_3 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //  value: hoof_4.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دارای لنگش",
                              onChanged: (_) {
                                hoof_4 = int.parse(_);
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
                              // value: urine_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دارای اسهال",
                              onChanged: (_) {
                                urine_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: urine_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس دارای خونشاش",
                              onChanged: (_) {
                                urine_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: urine_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با ادرار ومدفوع طبیعی",
                              onChanged: (_) {
                                urine_3 = int.parse(_);
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
                              // value: nodes_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس با غدد متورم",
                              onChanged: (_) {
                                nodes_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //   value: nodes_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد راس بدون غدد متورم",
                              onChanged: (_) {
                                nodes_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: nodes_3.toString(),
                              textInputType: TextInputType.text,
                              label: "نام غده (در صورت وجود غده)",
                              onChanged: (_) {
                                nodes_3 = _;
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
                              // value: crown_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد  با تاج وریش طبیعی",
                              onChanged: (_) {
                                crown_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: crown_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد  با تاج وریش پرخون",
                              onChanged: (_) {
                                crown_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              //   value: crown_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد  سیانوتیک",
                              onChanged: (_) {
                                crown_3 = int.parse(_);
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
                              // value: sole_1.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد با کف پای طبیعی",
                              onChanged: (_) {
                                sole_1 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: sole_2.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد با کف پای زخمی و خراش دار",
                              onChanged: (_) {
                                sole_2 = int.parse(_);
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFormField(
                              // value: sole_3.toString(),
                              textInputType: TextInputType.number,
                              label: "تعداد بامبل",
                              onChanged: (_) {
                                sole_3 = int.parse(_);
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
                              value:
                                  _noe_dam.isNotEmpty ? _noe_dam : null,
                              onChange: (_) {
                                _noe_dam = _;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            //   value: number.toString(),
                            textInputType: TextInputType.number,
                            label: "تعداد (راس یا قطعه)",
                            onChanged: (_) {
                              number = int.parse(_);
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
                              value: _status.isNotEmpty ? _status : null,
                              onChange: (_) {
                                _status = _;
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(animal_image, "تصویر دام"),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(certificate_image, "گواهی تایید سلامت"),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CustomTextFormField(
                        // value: disapproval_reason.toString(),
                        maxLine: 3,
                        label: "دلایل عدم تایید",
                        onChanged: (_) {
                          disapproval_reason = _;
                        },
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
}
