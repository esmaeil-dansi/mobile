import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/init_visit_Info.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/select_location.dart';

import '../../widgets/checkBox.dart';

class InitVisitInfoPage extends StatelessWidget {
  InitVisitInfoModel initVisitInfo;

  InitVisitInfoPage(this.initVisitInfo);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
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
                        readOnly: true,
                        controller: TextEditingController(
                            text: initVisitInfo.nationalId),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
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
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: initVisitInfo.name),
                            decoration: InputDecoration(
                              labelText: "نام و نام خانوادگی",
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
                          height: 60,
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: initVisitInfo.province),
                            decoration: InputDecoration(
                              labelText: "استان",
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
                          height: 60,
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: initVisitInfo.city),
                            decoration: InputDecoration(
                              labelText: "شهرستان",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
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
                              text: initVisitInfo.address),
                          decoration: InputDecoration(
                            labelText: "آدرس",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: initVisitInfo.mobile),
                          decoration: InputDecoration(
                            labelText: "َشماره تلفن",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: initVisitInfo.rahbar),
                          decoration: InputDecoration(
                            labelText: "َراهبر اصلی",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: initVisitInfo.department),
                          decoration: InputDecoration(
                            labelText: "اداره کمیته امداد",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        readOnly: true,
                        canRequestFocus: false,
                        controller: TextEditingController(
                            text: initVisitInfo.vDate),
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
                        value: initVisitInfo.tarh,
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
                        onChanged: (value) {},
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TitleCheckBox("آیا متقاضی دام/طیور دارد؟", (c) {
                      // _dam.value = c ? 1 : 0;
                    }, value: initVisitInfo.dam! == 1),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 70,
                          child: DropdownButtonFormField<String>(
                            value: (initVisitInfo.noeDam ?? "").isNotEmpty
                                ? initVisitInfo.noeDam
                                : null,
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
                              // _noe_dam.text = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 70,
                          child: DropdownButtonFormField<String>(
                            value:
                                (initVisitInfo.malekiyat ?? "").isNotEmpty
                                    ? initVisitInfo.malekiyat
                                    : null,
                            decoration: InputDecoration(
                              labelText: "نوع  مالکبت دام/طیور",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.red),
                                //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            items: [
                              "مالک",
                              "حق العملی",
                              "امانی",
                            ]
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              // _malekiyat.text = value!;
                            },
                          ),
                        ),
                      ],
                    )
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
                        value: initVisitInfo.vaziat,
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
                          // _vaziat.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.noeJaygah,
                        decoration: InputDecoration(
                          labelText: "نوع جایگاه",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: ["باز", "نیمه بسته", "بسته"]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // _noe_jaygah.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.qualityWater,
                        decoration: InputDecoration(
                          labelText: "کیفیت آب",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        items: ["شور", "شیرین", "لب شور"]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // _quality_water.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.taminWater,
                        decoration: InputDecoration(
                          labelText: "منبع تامین آب",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        items:
                            ["شهری", "چاه", "روستایی", "انتقال با تانکر"]
                                .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                        onChanged: (value) {
                          // _tamin_water.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.ajorMadani,
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
                          // _ajor_madani.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.sangNamak,
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
                          // _sang_namak.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.adavat,
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
                          // _adavat.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: initVisitInfo.kafJaygah,
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
                          // _kaf_jaygah.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // ImageView(_imagePath, ""),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: (initVisitInfo.status ?? "").isNotEmpty
                            ? initVisitInfo.status
                            : null,
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
                          "صلاحیت متقاضی مورد تایید نیست",
                          "آماده اجرای طرح می باشد",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // _status.text = value!;
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
                      // _sayeban = c ? 1 : 0;
                    }, value: initVisitInfo.sayeban! == 1),
                    TitleCheckBox("عدم حصارکشی مناسب", (c) {
                      // _adam_hesar = c ? 1 : 0;
                    }, value: initVisitInfo.adamHesar == 1),
                    TitleCheckBox(
                        "آسترکشی دیوارهای داخلی جایگاه انجام نشده", (c) {
                      // _astarkeshi = c ? 1 : 0;
                    }, value: initVisitInfo.astarkeshi! == 1),
                    TitleCheckBox("محل نگهداری خوراک دام مناسب نیست",
                        (c) {
                      // _mahal_negahdari = c ? 1 : 0;
                    }, value: initVisitInfo.mahalNegahdari! == 1),
                    TitleCheckBox("عدم وجود آبخور وآبشخور مناسب ", (c) {
                      // _adam_abkhor = c ? 1 : 0;
                    }, value: initVisitInfo.adamAbkhor! == 1),
                    TitleCheckBox("عدم برخورداری جایگاه از نور مناسب ",
                        (c) {
                      // _adam_noor = c ? 1 : 0;
                    }, value: initVisitInfo.adamNoor! == 1),
                    TitleCheckBox("عدم برخورداری جایگاه از تهویه لازم ",
                        (c) {
                      // _adam_tahvie = c ? 1 : 0;
                    }, value: initVisitInfo.adamTahvie! == 1),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      maxLines: 4,
                      readOnly: true,
                      controller: TextEditingController(
                          text: initVisitInfo.sayer),
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
                      controller: TextEditingController(
                          text: initVisitInfo.eghdamat),
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
            if (initVisitInfo.geolocation != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SelectLocation(
                  latLng: initVisitInfo.geolocation,
                  // latLng: initVisitInfo.geolocation,
                  onSelected: (_) {
                    // _latLng = _;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
