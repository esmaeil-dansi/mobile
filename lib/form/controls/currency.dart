import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/model/doctype_response.dart';

import '../../config/palette.dart';

import 'base_control.dart';
import 'base_input.dart';

class Currency extends StatelessWidget implements Control, ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const Currency({
    required this.doctypeField,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(
        f(context),
      );
    }

    return FormBuilderTextField(
      key: key,
      initialValue: doc != null
          ? doc![doctypeField.fieldname] != null
              ? doc![doctypeField.fieldname].toString()
              : null
          : null,
      keyboardType: TextInputType.number,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }

  @override
  getModelValue(Map doc, String fieldname) {
    // TODO: implement getModelValue
    throw UnimplementedError();
  }

  @override
  refresh() {
    // TODO: implement refresh
    throw UnimplementedError();
  }

  @override
  bool setBold(DoctypeField doctypeField) {
    // TODO: implement setBold
    throw UnimplementedError();
  }

  @override
  String? Function(dynamic p1) Function(BuildContext p1, {String errorText})? setMandatory(DoctypeField doctypeField) {
    // TODO: implement setMandatory
    throw UnimplementedError();
  }

  @override
  int toggle(bool show) {
    // TODO: implement toggle
    throw UnimplementedError();
  }
}
