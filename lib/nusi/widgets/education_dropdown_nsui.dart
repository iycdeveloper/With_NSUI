import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/screens/widgets/dropdown_text_field.dart';
import 'package:iyc/utils/constants.dart';

class EducationDropdownNSUI extends StatelessWidget {
  const EducationDropdownNSUI({
    Key? key,
    this.currentValue,
    this.labelcolor,
    this.height,
    required this.listValues,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.icon,
    this.viewOnly = false,
  }) : super(key: key);

  final IconData? icon;

  final String? currentValue;

  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final Color? labelcolor;
  final double? height;

  final String hintText;
  final String labelText;
  final bool viewOnly;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(title: currentValue ?? "", label: labelText)
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabelNSUI(icon: icon, label: labelText, color: labelcolor),
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE7EDF9)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4)),
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
                          dropdownColor: Colors.white,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          itemHeight: height ??
                              MediaQuery.of(context).size.height * 0.08,
                          hint: Text(hintText,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.grey)
                              // Constants.formFieldItemTextStyle,
                              ),
                          icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1356BF).withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.angleDown,
                              size: 14,
                              color: Color(0xFF1356BF),
                            ),
                          ),
                          value: currentValue,
                          isDense: true,
                          isExpanded: true,
                          onChanged: onChanged,
                          items: listValues == null
                              ? []
                              : listValues!.map((value) {
                                  return DropdownMenuItem(
                                    value: value.value,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        value.name,
                                        style: currentValue == value.value
                                            ? theme.textTheme.bodyLarge!
                                                .copyWith(
                                                    color: theme.textTheme
                                                        .bodyLarge!.color,
                                                    fontWeight: FontWeight.w500)
                                            : theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.grey),
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
