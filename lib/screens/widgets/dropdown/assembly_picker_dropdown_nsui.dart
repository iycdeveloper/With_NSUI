import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class AssemblyPickerDropDownNSUI extends StatelessWidget {
  const AssemblyPickerDropDownNSUI(
      {Key? key,
      required this.currentAssembly,
      required this.assemblyList,
      required this.onChanged,
      required this.selectedAssembly,
      this.viewOnly = false,
      this.labelcolor,
      this.icon,
      this.title = "University"})
      : super(key: key);

  final IconData? icon;

  final Assembly? currentAssembly;
  final List<Assembly>? assemblyList;
  final void Function(dynamic v) onChanged;
  final String selectedAssembly;
  final bool viewOnly;
  final String title;
  final Color? labelcolor;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(title: selectedAssembly, label: "University")
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabelNSUI(icon: icon, label: title, color: labelcolor),
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
                      height: MediaQuery.of(context).size.height * 0.065,
                      padding: EdgeInsets.only(
                          // top: 15, bottom: 15,
                          left: 10,
                          right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                                                    borderRadius: BorderRadius.circular(10),

                          dropdownColor: Colors.white,
                          hint: Text(selectedAssembly,
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
                          value: currentAssembly?.assemblyCode,
                          isDense: true,
                          isExpanded: true,
                          onChanged: onChanged,
                          items: assemblyList?.map((value) {
                            return DropdownMenuItem(
                              value: value.assemblyCode,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  value.name,
                                  style: currentAssembly?.assemblyCode ==
                                          value.assemblyCode
                                      ? theme.textTheme.bodyLarge!.copyWith(
                                          color:
                                              theme.textTheme.bodyLarge!.color,
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
