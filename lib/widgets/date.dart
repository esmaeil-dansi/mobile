import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

void selectDate(
    Function(String) set, TextEditingController textEditingController) async {
  Jalali? picked = await showPersianDatePicker(
      context: Get.context!,
      initialDate: Jalali.now(),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 9),
      initialEntryMode: PersianDatePickerEntryMode.calendarOnly,
      initialDatePickerMode: PersianDatePickerMode.day,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            dialogTheme: const DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
            ),
          ),
          child: child!,
        );
      });
  if (picked != null) {
    textEditingController.text = picked.formatFullDate();
    set(DateFormat('yyyy-MM-dd').format(picked.toGregorian().toDateTime()));
  }
}
