import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/model/periodic_visit_info_model.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/select_location.dart';

class PeriodicVisitInfo extends StatelessWidget {
  PeriodicVisitInfoModel periodicVisitInfoModel;

  PeriodicVisitInfo(this.periodicVisitInfoModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 12),
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
                    TextField(
                      controller: TextEditingController(
                          text: periodicVisitInfoModel.nationalId),
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "کد ملی",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
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
                                text: periodicVisitInfoModel.fullName),
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
                                text: periodicVisitInfoModel.province),
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
                                text: periodicVisitInfoModel.city),
                            decoration: InputDecoration(
                              labelText: "شهرستان",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        // TextField(
                        //   readOnly: true,
                        //   controller: TextEditingController(
                        //       text:periodicVisitInfoModel.manger),
                        //   decoration: InputDecoration(
                        //     labelText: "َشماره تلفن",
                        //     border: OutlineInputBorder(
                        //       borderRadius:
                        //       BorderRadius.circular(20.0),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: periodicVisitInfoModel.rahbar),
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
                              text: periodicVisitInfoModel.department),
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
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.outbreak,
                        decoration: InputDecoration(
                          labelText: "شروع بیماری در گله ؟",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "بله",
                          "خیر",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // outbreak.text = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // TextField(
                    //   maxLines: 4,
                    //   decoration: InputDecoration(
                    //     labelText: "نام بیماری و تشخیص پزشک",
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.stableCondition,
                        decoration: InputDecoration(
                          labelText: "وضعیت بستر",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "تمیز",
                          "متوسط",
                          "کثیف",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // stable_condition = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.manger,
                        decoration: InputDecoration(
                          labelText: "وضعیت آخورها",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "تمیز و مرتب",
                          "آلوده",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // manger = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.losses,
                        decoration: InputDecoration(
                          labelText: " وجود تلفات درگله؟",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "بله",
                          "خیر",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // losses = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.bazdid,
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
                          // bazdid = (int.parse(value!) + 1).toString();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText:
                            "تعداد تلفات و نظر دامپزشک در کالبدگشایی",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.water,
                        decoration: InputDecoration(
                          labelText: " وضعیت آبشخورها",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "تمیز",
                          "کثیف",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // water = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.supplySituation,
                        decoration: InputDecoration(
                          labelText: " وضعیت انبار آذوقه",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "مرتب و تمیز",
                          "آلوده و نامرتب",
                          "آذوقه در حال فساد",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // supply_situation = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 70,
                      child: DropdownButtonFormField<String>(
                        value: periodicVisitInfoModel.ventilation,
                        decoration: InputDecoration(
                          labelText: " وضعیت تهویه",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: [
                          "مناسب",
                          "نامناسب",
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // ventilation = value!;
                        },
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
                    labelText: "وضعیت طرح",
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
                        value: periodicVisitInfoModel.vaziat,
                        decoration: InputDecoration(
                          labelText: "وضعیت طرح",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        items: ["انحراف از طرح", "فعال"]
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          // vaziat = value!;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: TextEditingController(text: ""),
                      decoration: InputDecoration(
                        labelText: "علت(در صورت وجود انحراف)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    if (periodicVisitInfoModel.geolocationP != null)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SelectLocation(
                          latLng: periodicVisitInfoModel.geolocationP,
                          onSelected: (_) {
                            // _latLng = _;
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
                  labelStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextField(
                        // onTap: () =>
                        //     selectDate((_) {
                        //       _date = _;
                        //     }, _dateController),
                        readOnly: true,
                        canRequestFocus: false,
                        controller: TextEditingController(
                            text: periodicVisitInfoModel.date),
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
                        // onTap: () =>
                        //     selectDate((_) {
                        //       _nextDate = _;
                        //     }, _nextDateController),
                        readOnly: true,
                        canRequestFocus: false,
                        controller: TextEditingController(text: ""),
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
    );
  }
}
