import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
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
      this.title = "University"})
      : super(key: key);

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
                Text(
                  title,
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
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: theme.textTheme.bodyLarge!.color,
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
