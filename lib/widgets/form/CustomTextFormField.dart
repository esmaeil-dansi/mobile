import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  CustomTextFormField(
      {this.label,
      this.height,
      this.maxLine = 1,
      this.maxLength,
      this.value = "",
      this.prefix,
      this.textInputType,
      this.readOnly = false,
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
          suffix: widget.prefix,
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
