import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class DropDownPicker extends StatelessWidget {
  const DropDownPicker({
    Key? key,
    required this.currentValue,
    required this.listValues,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.selectedBuilder,
    this.height,
    this.refKey,
    this.viewOnly = false,
  }) : super(key: key);

  final dynamic currentValue;
  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final List<Widget> Function(BuildContext context)? selectedBuilder;

  final String hintText;
  final String labelText;
  final double? height;
  final bool viewOnly;
  final GlobalKey? refKey;

  /// Name of the currently selected item, or the raw value when the list has
  /// no match for it. A bare `firstWhere` here threw "Bad state: No element"
  /// whenever a stored value wasn't present in the list (or the list hadn't
  /// loaded yet), which red-screened the whole page in viewOnly mode.
  String get _selectedName {
    for (final item in listValues ?? []) {
      if (item.value == currentValue) return item.name;
    }
    return currentValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(title: _selectedName, label: labelText)
        : Container(
            // color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: Constants.formItemDecoration,
                  child: Container(
                      alignment: Alignment.center,
                      height:
                          height ?? MediaQuery.of(context).size.height * 0.08,
                      padding: const EdgeInsets.only(
                          // top: 15, bottom: 15,
                          left: 10,
                          right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          dropdownColor: Colors.white,
                          key: refKey,
                          itemHeight: height ??
                              MediaQuery.of(context).size.height * 0.08,
                          //alignment: Alignment.center,
                          onTap: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          selectedItemBuilder: selectedBuilder,
                          hint: Text(
                            hintText,
                            style: Constants.formFieldItemTextStyle,
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.angleDown,
                            size: 20,
                            color: Color(0xff788EA9),
                          ),
                          value: currentValue,
                          isDense: true,
                          isExpanded: true,
                          // style:  Constants.formFieldItemTextStyle,
                          onChanged: onChanged,
                          items: listValues == null
                              ? []
                              : listValues?.map((item) {
                                  return DropdownMenuItem(
                                    value: item.value,
                                    child: Text(
                                      item.name,
                                      style: Constants.formItemText,
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
