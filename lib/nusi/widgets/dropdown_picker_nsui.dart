import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/nusi/widgets/dropdown_text_field_nsui.dart';
import 'package:iyc/screens/widgets/dropdown_text_field.dart';
import 'package:iyc/utils/constants.dart';

class DropDownPickerNSUI extends StatelessWidget {
  const DropDownPickerNSUI({
    Key? key,
    required this.currentValue,
    required this.listValues,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.icon,
    this.selectedBuilder,
    this.labelcolor,
    this.height,
    this.refKey,
    this.viewOnly = false,
  }) : super(key: key);

  final dynamic currentValue;
  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final List<Widget> Function(BuildContext context)? selectedBuilder;
  final Color? labelcolor;
  final String hintText;
  final String labelText;
  final double? height;
  final bool viewOnly;
  final IconData? icon;
  final GlobalKey? refKey;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextFielNSUI(
            title: listValues!
                .firstWhere((element) => element.value == currentValue)
                .name,
            label: labelText)
        : Container(
            // color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabelNSUI(icon: icon, label: labelText, color: labelcolor),
                Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200]!,
                            spreadRadius: 1.2,
                            blurRadius: 0.6),
                      ]),
                  //Constants.formItemDecoration,
                  child: Container(
                      alignment: Alignment.center,
                      height:
                          height ?? MediaQuery.of(context).size.height * 0.065,
                      padding: const EdgeInsets.only(
                          // top: 15, bottom: 15,
                          left: 10,
                          right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: Colors.white,
                          
                          key: refKey,
                          // itemHeight: height ??
                          //     MediaQuery.of(context).size.height * 0.08,
                          //alignment: Alignment.center,
                          onTap: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          selectedItemBuilder: selectedBuilder,
                          hint: Text(
                            hintText,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: theme.textTheme.bodyLarge!.color,
                          ),
                          value: currentValue,
                          isDense: true,
                          isExpanded: true,
                          style: theme.textTheme.bodyLarge!.copyWith(),
                          onChanged: onChanged,
                          items: listValues == null
                              ? []
                              : listValues?.map((item) {
                                  return DropdownMenuItem(
                                    value: item.value,
                                    child: Text(
                                      item.name,
                                      style: currentValue == item.value
                                          ? theme.textTheme.bodyLarge!
                                              .copyWith(
                                                color: theme.textTheme.bodyLarge!.color,
                                                fontWeight: FontWeight.w500
                                              )
                                          : theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.grey),
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
