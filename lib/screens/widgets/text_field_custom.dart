import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String label;
  final TextInputType keyBoardType;
  final Function(String?) validation;
  final double? textFieldHeight;
  final void Function(dynamic v)? onChanged;
  final int? maxLength;
  const TextFieldCustom(
      {Key? key,
        this.hintText,
        this.textFieldHeight,
        this.controller,
        required this.label,
        required this.keyBoardType,
        required this.validation,
        this.onChanged,
        this.maxLength})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Container(
              height: textFieldHeight,
              //width: textFieldHeight! * 2,
              margin: EdgeInsets.only(top: 7),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: Colors.grey.shade100),
              child: TextFormField(
                validator: (str) => validation(str),
                controller: controller,
                keyboardType: keyBoardType,
                maxLength: maxLength,
                autocorrect: true,
                onChanged: onChanged,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                //  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey),
                  //filled: true,
                  //fillColor: Colors.grey.shade100,
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(22.0)),
                  //   borderSide: BorderSide(color: Colors.grey, width: 1),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //   borderSide: BorderSide(color: Colors.grey),
                  // ),
                ),
              )),
        ],
      ),
    );
  }
}