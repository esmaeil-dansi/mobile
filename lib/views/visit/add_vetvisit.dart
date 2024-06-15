import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:frappe_app/model/agent.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/checkBox.dart';
import 'package:frappe_app/widgets/city_selector.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../model/agentInfo.dart';
import '../../widgets/image_view.dart';

class AddVetVisit extends StatefulWidget {
  @override
  State<AddVetVisit> createState() => _AddVetVisitState();
}

class _AddVetVisitState extends State<AddVetVisit> {
  int time = 0;

  @override
  void initState() {
    time = DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
              Progressbar.showProgress();
              var res = await _visitService.saveVetVisit(
                agentInfo: agentInfo.value ?? AgentInfo(),
                image_dam: animal_image.value,
                license_salamat: certificate_image.value,
                name_damp: name_dam,
                code_n: code_n,
                disapproval_reason: disapproval_reason,
                bime: _bime.value,
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
            },
          ),
        ),
        appBar: appSliverAppBar("ویزیت دامپزشکی جدید",
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "صفحه 1",
                ),
                Tab(
                  text: "صفحه 2",
                ),
                Tab(
                  text: "صفحه 3",
                ),
                Tab(
                  text: " صدور گواهی",
                )
              ],
            )),
        body: TabBarView(
          children: [
            SingleChildScrollView(
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
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  onChanged: (_) {
                                    name_dam = _;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "نام ونام خانوادگی دامپزشک",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      code_n = _;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "کد نظام مهندسی دامپزشکی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      national_id_doc = _;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "کد ملی کارشناس/دامپزشک",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      pelak_az = _;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "شماره پلاک از",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      pelak_ta = _;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "شماره پلاک تا ",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
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
                              labelText: "اطلاعات متقاضی",
                              labelStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 70,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    controller: _nationId,
                                    onChanged: (_) {
                                      if (_.length == 10) {
                                        _fetchAgentInfo();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "کد ملی",
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
                                Obx(() => agentInfo.value != null
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            child: TextField(
                                              readOnly: true,
                                              controller: TextEditingController(
                                                  text: agentInfo
                                                      .value!.full_name),
                                              decoration: InputDecoration(
                                                labelText: "نام و نام خانوادگی",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                                                  text: agentInfo
                                                      .value!.province),
                                              decoration: InputDecoration(
                                                labelText: "استان",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                                                      BorderRadius.circular(
                                                          20.0),
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
                                                text: agentInfo
                                                    .value!.department),
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
                                      labelText: " ترکیب گله",
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.red),
                                        //<-- SEE HERE
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
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
                                    ]
                                        .map((e) => DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      galleh = value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      galle_d = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "جمعیت گله (راس -نفر)",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                    onChanged: (_) {
                                      age = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "میانگین سن گله",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      teeth_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس دندان سالم",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      teeth_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس دندان شکسته",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      teeth_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس دندان عفونی",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      eye_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس هردو جشم سالم",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      eye_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس کدورت",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      eye_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس خروج ترشحات",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      eye_4 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس ملتهب",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      eye_5 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس کوری",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      breth_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با رال مرطوب",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      breth_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با رال خشک",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      breth_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با هر دو ریه طبیعی",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mucus_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با مخاط صورتی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mucus_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با مخاط سفید",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mucus_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با مخاط زرد",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mucus_4 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با سینوتیک",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mucus_5 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با نقاط خونریزی",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      ear_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText:
                                          "تعداد راس با افتادگی گوش یک طرفه",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      ear_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با گوش طبیعی",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
            SingleChildScrollView(
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
                              labelText: "وضعیت پوشش خارجی",
                              labelStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      skin_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس موریختگی موضعی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      skin_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با خارش موضعی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      skin_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با التهاب موضعی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      skin_4 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با زخم سطحی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      skin_5 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با آبسه",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      skin_6 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با فتق",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      leech_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس شدیدا آلوده انگل",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      leech_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText:
                                          "تعداد راس با آلودگی انگل متوسط",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      leech_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس بدون آلودگی انگل",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mouth_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس تاولی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mouth_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس اکتیمایی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mouth_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس زخم عفونی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      mouth_4 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس بدون زخم وضایعات",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      hoof_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس سم چینی شده",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      hoof_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس سم چینی نشده",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      hoof_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با عفونت سم",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      hoof_4 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس دارای لنگش",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      urine_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس دارای اسهال",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      urine_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس دارای خونشاش",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      urine_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText:
                                          "تعداد راس با ادرار ومدفوع طبیعی",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
            SingleChildScrollView(
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
                              labelText: "وضعیت غدد لنفاوی",
                              labelStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      nodes_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس با غدد متورم",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      nodes_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد راس بدون غدد متورم",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      nodes_3 = _;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "نام غده (در صورت وجود غده)",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      crown_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد  با تاج وریش طبیعی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      crown_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد  با تاج وریش پرخون",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      crown_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد  سیانوتیک",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
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
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      sole_1 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد با کف پای طبیعی",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      sole_2 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText:
                                          "تعداد با کف پای زخمی و خراش دار",
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
                                  height: 50,
                                  child: TextField(
                                    onChanged: (_) {
                                      sole_3 = int.parse(_);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: "تعداد بامبل",
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
            SingleChildScrollView(
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
                        SizedBox(
                          height: 70,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "نوع دام/طیور",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.red),
                                //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20),
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
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _noe_dam = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          child: TextField(
                            onChanged: (_) {
                              number = int.parse(_);
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "تعداد (راس یا قطعه)",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
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
                              "مورد تایید است",
                              "مورد تایید نیست",
                            ]
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              _status = value!;
                            },
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
                        TextField(
                          maxLines: 3,
                          onChanged: (_) {
                            disapproval_reason = _;
                          },
                          decoration: InputDecoration(
                            labelText: "دلایل عدم تایید",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
