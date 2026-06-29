import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/screens/widgets/dropdown_text_field.dart';
import 'package:iyc/utils/constants.dart';

class EducationDropdown extends StatelessWidget {
  const EducationDropdown({
    Key? key,
    this.currentValue,
    required this.listValues,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.viewOnly = false,
  }) : super(key: key);

  final String? currentValue;

  final List<DropdownItem> listValues;
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
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: Constants.formItemDecoration,
                  child: Container(
                      alignment: Alignment.center,
                      //      height: MediaQuery.of(context).size.height * 0.08,
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, left: 10, right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          dropdownColor: Colors.white,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          hint: Text(
                            hintText,
                            //  style: Constants.formFieldItemTextStyle,
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
                                    value: value.value,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        value.name,
                                      ),
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
