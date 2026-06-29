import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
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
    this.viewOnly = false,
  }) : super(key: key);

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
                Text(
                  labelText,
                  style: TextStyle(
                      color: labelcolor ?? Colors.blueAccent, fontSize: 14),
                ),
                Container(
                  margin: EdgeInsets.only(
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
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: theme.textTheme.bodyLarge!.color,
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
