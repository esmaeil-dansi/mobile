import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatefulWidget {
  String label;
  List<String> items;
  Function(String) onChange;
  String? value;
  bool required;

  CustomDropdownButtonFormField(
      {required this.label,
      required this.items,
      this.required = true,
      required this.onChange,
      this.value});

  @override
  State<CustomDropdownButtonFormField> createState() =>
      _CustomDropdownButtonFormFieldState();
}

class _CustomDropdownButtonFormFieldState
    extends State<CustomDropdownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 70,
      child: DropdownButtonFormField<String>(
        validator: (_) {
          if (!widget.required) {
            return null;
          }
          if (_ == null) {
            return "یک مورد را انتخاب کنید";
          }
          return null;
        },
        value: widget.value != null && widget.value!.isNotEmpty
            ? widget.value
            : null,
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            //<-- SEE HERE
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        items: widget.items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: (value) {
          widget.onChange(value ?? "");
        },
      ),
    );
  }
}
