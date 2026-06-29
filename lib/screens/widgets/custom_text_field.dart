import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.title,
    required this.hindText,
    this.keyboardType,
    this.maxLength,
    this.validator,
    this.controller,
    this.focusNode,
    this.inputFormatters,
  }) : super(key: key);

  final String title;
  final String hindText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * .1,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffc0d5f3),
        ),
        color: Color(0xffffffff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1,
              color: Color(0xFF869DB6),
            ),
          ),
          SizedBox(height: 6),
          Expanded(
            child: TextFormField(
              maxLength: maxLength,
              keyboardType: keyboardType,
              controller: controller,
              focusNode: focusNode,
              validator: validator,
              inputFormatters: inputFormatters,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hindText,
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  color: Color(0xFF365B85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
