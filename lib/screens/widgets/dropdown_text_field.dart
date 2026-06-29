import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/utils/constants.dart';

class DropDownTextField extends StatelessWidget {
  final String title;
  final String label;

  const DropDownTextField({
    Key? key,
    required this.title,
    required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Container(
            margin: const EdgeInsets.only(top: 7),
            decoration: Constants.formItemDecoration,
            child: ListTile(
              leading: Text(
                title,
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
