import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class CategoryPickerWidget extends StatelessWidget {
  const CategoryPickerWidget({
    Key? key,
    this.currentValue,
    required this.listValues,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.viewOnly = false,
  }) : super(key: key);

  final String? currentValue;

  final List<Category> listValues;
  final void Function(dynamic v) onChanged;

  final String hintText;
  final String labelText;
  final bool viewOnly;
  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(title: currentValue ?? "", label: labelText)
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                Container(
                  // padding: EdgeInsets.all(15),
                  margin: EdgeInsets.only(top: 5),
                  decoration: Constants.formItemDecoration,
                  child: Container(
                      alignment: Alignment.center,
                      // width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 15, right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          dropdownColor: Colors.white,
                          hint: Text(
                            hintText,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 15,
                            color: Colors.grey.shade600,
                          ),
                          value: currentValue,
                          isDense: true,
                          isExpanded: true,
                          onChanged: onChanged,
                          items: listValues == null
                              ? []
                              : listValues.map((value) {
                                  return DropdownMenuItem(
                                    value: value.categoryCode,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(value.name),
                                    ),
                                  );
                                }).toList(),
                        ),
                      )),
                ),
              ],
            ),
          );
  }
}
