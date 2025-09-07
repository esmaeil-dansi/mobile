import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:get_it/get_it.dart';

Widget provinceSelector(Function(String) onSelect, String value) {
  var textController = TextEditingController(text: value);
  return TypeAheadField(
    emptyBuilder: (c) {
      return Text("موردی یافت نشد");
    },
    builder: (context, textController, focusNode) {
      return TextField(
        controller: textController,
        focusNode: focusNode,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: "استان",
        ),
      );
    },

    suggestionsCallback: (pattern) async {
      return cities
          .where((suggestion) =>
              suggestion.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    },
    // Widget to build each suggestion in the list
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    // Callback when a suggestion is selected
    onSelected: (suggestion) {
      textController.text = suggestion;
      onSelect(suggestion);
    },
  );
}

Widget citySelector(String province, Function(String) onSelect, String value) {
  var textController = TextEditingController(text: value);
  return TypeAheadField(
    emptyBuilder: (c) {
      return Text("موردی یافت نشد");
    },
    builder: (context, textController, focusNode) {
      return TextField(
        controller: textController,
        focusNode: focusNode,
        onSubmitted: (_) => onSelect(""),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: "شهرستان",
        ),
      );
    },
    suggestionsCallback: (pattern) async {
      return (await GetIt.I
          .get<VisitService>()
          .searchInCity(province, pattern));
    },
    // Widget to build each suggestion in the list
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    // Callback when a suggestion is selected
    onSelected: (suggestion) {
      textController.text = suggestion;
      onSelect(suggestion);
    },
  );
}

List<String> cities = [
  "اردبیل",
  "اصفهان",
  "البرز",
  "ایلام",
  "آذربایجان شرقی",
  "آذربایجان غربی",
  "بوشهر",
  "تهران",
  "چهارمحال و بختیاری",
  "خراسان جنوبی",
  "خراسان رضوی",
  "خراسان شمالی",
  "خوزستان",
  "زنجان",
  "ستاد تهران",
  "سمنان",
  "سیستان و بلوچستان",
  "فارس",
  "قزوین",
  "قم",
  "کردستان",
  "کرمان",
  " کرمانشاه",
  "کهکیلویه و بویراحمد",
  "گلستان",
  "گیلان",
  "لرستان",
  "مازندران",
  "مرکزی",
  "هرمزگان",
  "همدان",
  "یزد"
];
