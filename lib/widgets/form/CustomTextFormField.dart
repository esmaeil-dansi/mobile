import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frappe_app/utils/string_extension.dart';
import 'package:intl/intl.dart' as intl;

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
  bool useSeperator;
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
      this.useSeperator = false,
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
      // formatters.add(NumberInputFormatter);
    }
    if (widget.useSeperator) {
      formatters.add(NumberWithCommaFormatter());
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

class NumberWithCommaFormatter extends TextInputFormatter {
  final _digitReg = RegExp(r'^[\u06F0-\u06F90-9,]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!_digitReg.hasMatch(newValue.text)) {
      return oldValue;
    }

    final raw = newValue.text.replaceFarsiNumber().replaceAll(',', '');

    if (raw.isEmpty) return newValue.copyWith(text: '');

    final formatted = _formNum(raw);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formNum(String s) {
    return intl.NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
}
