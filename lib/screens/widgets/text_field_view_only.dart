import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class TextFieldViewOnly extends StatelessWidget {
  final String contentValue;
  final String labelText;

  const TextFieldViewOnly({
    Key? key,
    required this.contentValue,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Container(
            margin: EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Constants.kitThemeGradients[3],
            ),
            child: ListTile(
              leading: Text(
                contentValue,
                style: TextStyle(color: Colors.black),
              ),
              //  trailing: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
