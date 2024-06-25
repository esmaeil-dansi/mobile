import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/model/vet_visit_info_model.dart';
import 'package:frappe_app/widgets/checkBox.dart';

class VetVisitInfo extends StatelessWidget {
  VetVisitInfoModel vetVisitInfoModel;

  VetVisitInfo(this.vetVisitInfoModel);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
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
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
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
                                  controller: TextEditingController(
                                      text: vetVisitInfoModel.nameDamp),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.codeN),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.nationalIdDoc),
                                    onChanged: (_) {
                                      // national_id_doc = _;
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
                                  // _bime.value = c ? 1 : 0;
                                }, value: vetVisitInfoModel.bime == 1),
                                SizedBox(
                                  height: 5,
                                ),
                                TitleCheckBox("پلاک شده است یا خیر؟", (c) {
                                  // _pelak.value = c ? 1 : 0;
                                }, value: vetVisitInfoModel.pelak == 1),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.pelakAz),
                                    onChanged: (_) {
                                      // pelak_az = _;
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.pelakTa),
                                    onChanged: (_) {
                                      // pelak_ta = _;
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.nationalId),
                                    onChanged: (_) {
                                      if (_.length == 10) {
                                        // _fetchAgentInfo();
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
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child: TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.fullName),
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
                                            text: vetVisitInfoModel.province),
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
                                            text: vetVisitInfoModel.city),
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
                                      controller:
                                          TextEditingController(text: ""),
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
                                          text: vetVisitInfoModel.rahbar),
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
                                        text: vetVisitInfoModel.department,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "اداره کمیته امداد",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 70,
                                  child: DropdownButtonFormField<String>(
                                    value: vetVisitInfoModel.galleh,
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
                                      // galleh = value!;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.galleD
                                            ?.toString()),
                                    onChanged: (_) {
                                      // galle_d = int.parse(_);
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.age?.toString()),
                                    onChanged: (_) {
                                      // age = int.parse(_);
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.teeth1
                                            ?.toString()),
                                    onChanged: (_) {
                                      // teeth_1 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.teeth2
                                            ?.toString()),
                                    onChanged: (_) {
                                      // teeth_2 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.teeth3
                                            ?.toString()),
                                    onChanged: (_) {
                                      // teeth_3 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.eye1?.toString()),
                                    onChanged: (_) {
                                      // eye_1 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.eye2?.toString()),
                                    onChanged: (_) {
                                      // eye_2 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.eye3?.toString()),
                                    onChanged: (_) {
                                      // eye_3 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.eye4?.toString()),
                                    onChanged: (_) {
                                      // eye_4 = int.parse(_);
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.eye5?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.breth1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.breth2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.breth3
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mucus1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mucus2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mucus3
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mucus4
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mucus5
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.ear1?.toString()),
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
                                    controller: TextEditingController(
                                        text:
                                            vetVisitInfoModel.ear2?.toString()),
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
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.skin1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.skin2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.skin3
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.skin4
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.skin5
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.skin6
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.leech1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.leech2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.leech3
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mouth1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mouth2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mouth3
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.mouth4
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.hoof1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.hoof2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.hoof3
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.hoof4
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.urine1
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.urine2
                                            ?.toString()),
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
                                    controller: TextEditingController(
                                        text: vetVisitInfoModel.urine3
                                            ?.toString()),
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
                  SingleChildScrollView(
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 7, right: 7, top: 9, bottom: 6),
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.nodes1
                                                ?.toString()),
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
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.nodes2
                                                ?.toString()),
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
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.nodes2
                                                ?.toString()),
                                        decoration: InputDecoration(
                                          labelText:
                                              "نام غده (در صورت وجود غده)",
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.crown1
                                                ?.toString()),
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
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.crown2
                                                ?.toString()),
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
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.crown3
                                                ?.toString()),
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.sole1
                                                ?.toString()),
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
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.sole2
                                                ?.toString()),
                                        onChanged: (_) {
                                          // sole_2 = int.parse(_);
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
                                        controller: TextEditingController(
                                            text: vetVisitInfoModel.sole3
                                                ?.toString()),
                                        onChanged: (_) {
                                          // sole_3 = int.parse(_);
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
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: DropdownButtonFormField<String>(
                              value: vetVisitInfoModel.types,
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
                                // _noe_dam = value!;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            child: TextField(
                              controller: TextEditingController(
                                  text: vetVisitInfoModel.number?.toString()),
                              onChanged: (_) {
                                // number = int.parse(_);
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
                              value: vetVisitInfoModel.result,
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
                                // _status = value!;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // ImageView(animal_image, "تصویر دام"),
                          SizedBox(
                            height: 10,
                          ),
                          // ImageView(certificate_image, "گواهی تایید سلامت"),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            readOnly: true,
                            maxLines: 3,
                            onChanged: (_) {
                              // disapproval_reason = _;
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
