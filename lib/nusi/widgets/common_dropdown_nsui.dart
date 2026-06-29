import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/nusi/widgets/dropdown_text_field_nsui.dart';
import 'package:iyc/utils/constants.dart';

class CommonPickerDropDownNSUI extends StatelessWidget {
  const CommonPickerDropDownNSUI(
      {Key? key,
      required this.listValues,
      required this.hinttext,
      this.onChanged,
      required this.onTap,
      required this.selectedValue,
      this.viewOnly = false,
      required this.lable,
      this.labelcolor,
      this.isRegistrationPage = false})
      : super(key: key);

  final List<DropdownItem>? listValues;
  final void Function(dynamic v)? onChanged;
  final void Function() onTap;
  final String? selectedValue;
  final String? hinttext;

  final String lable;

  final bool viewOnly;
  final bool isRegistrationPage;
  final Color? labelcolor;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextFielNSUI(title: selectedValue!, label: lable)
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lable,
                  style: TextStyle(
                      color: labelcolor ?? Colors.blueAccent, fontSize: 14),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: Constants.formItemDecoration,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      padding: const EdgeInsets.only(
                          // top: 15, bottom: 15,
                          left: 10,
                          right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          borderRadius: BorderRadius.circular(10),
                          dropdownColor: Colors.white,
                          hint: Text(
                            hinttext!,
                            style: Constants.formFieldItemTextStyle,
                          ),
                          icon: const Icon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: Colors.blueAccent,
                          ),
                          value: selectedValue,
                          isDense: true,
                          isExpanded: true,
                          onTap: onTap,
                          onChanged: onChanged,
                          items: listValues?.map((value) {
                            return DropdownMenuItem(
                              value: value.value,
                              child: Text(
                                value.name,
                                style: theme.textTheme.bodyMedium!
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
