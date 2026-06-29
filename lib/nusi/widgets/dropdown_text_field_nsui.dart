import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/utils/constants.dart';

class DropDownTextFielNSUI extends StatelessWidget {
  final String title;
  final String label;

  const DropDownTextFielNSUI({
    Key? key,
    required this.title,
    required this.label,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Container(
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[200]!,
                      spreadRadius: 1.2,
                      blurRadius: 0.6),
                ]), //Constants.formItemDecoration,
            child: ListTile(
              leading: Text(
                title,
                style: theme.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
