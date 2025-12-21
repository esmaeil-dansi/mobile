import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frappe_app/utils/string_extension.dart';

class CustomTextFormField extends StatefulWidget {
  String? label;
  double? height;
  int? maxLength;
  int maxLine;
  TextInputType? textInputType;
  Function(String)? onChanged;
  TextEditingController? textEditingController;
  String validator;
  bool readOnly;
  String value;
  Widget? prefix;
  TextInputFormatter? textInputFormatter;

  CustomTextFormField(
      {this.label,
      this.height,
      this.maxLine = 1,
      this.maxLength,
      this.value = "",
      this.prefix,
      this.textInputType,
      this.readOnly = false,
      this.textInputFormatter,
      this.onChanged,
      this.textEditingController,
      this.validator = "نمی تواند خالی باشد"});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        inputFormatters: getInputFormatter(),
        validator: (_) {
          if (_ == null || _.isEmpty) {
            return widget.validator;
          }
          return null;
        },
        controller: widget.textEditingController ??
            (widget.value.isNotEmpty
                ? TextEditingController(text: widget.value)
                : null),
        readOnly: widget.readOnly,
        maxLines: widget.maxLine,
        keyboardType: widget.textInputType,
        maxLength: widget.maxLength,
        onChanged: (_) {
          if (widget.onChanged != null) {
            widget.onChanged!(_);
          }
        },
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: widget.prefix,
          ),
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.black38, fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  List<TextInputFormatter> getInputFormatter() {
    List<TextInputFormatter> formatters = [];
    if (widget.textInputFormatter != null) {
      formatters.add(widget.textInputFormatter!);
    }
    if (widget.textInputType == TextInputType.number) {
      formatters.add(NumberInputFormatter);
    }
    return formatters;
  }
}

final _numberFormat = RegExp(r'^[\u06F0-\u06F90-9]*$');

final NumberInputFormatter = TextInputFormatter.withFunction(
  (oldValue, newValue) {
    if (_numberFormat.hasMatch(newValue.text)) {
      return newValue.copyWith(
        text: newValue.text.replaceFarsiNumber(),
      );
    } else {
      return oldValue;
    }
  },
);
