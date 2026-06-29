import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class AssemblyPickerDropDown extends StatelessWidget {
  const AssemblyPickerDropDown({
    Key? key,
    required this.currentAssembly,
    required this.assemblyList,
    required this.onChanged,
    required this.selectedAssembly,
    this.viewOnly = false,
    this.title = "Assembly Constituency/Zonal/Ward"
  }) : super(key: key);

  final Assembly? currentAssembly;
  final List<Assembly>? assemblyList;
  final void Function(dynamic v) onChanged;
  final String selectedAssembly;
  final bool viewOnly;
  final String title;
  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(
            title: selectedAssembly, label: "Assembly Constituency/Block")
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  decoration: Constants.formItemDecoration,
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      padding: EdgeInsets.only(
                          // top: 15, bottom: 15,
                          left: 10,
                          right: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<dynamic>(
                          dropdownColor: Colors.white,
                          hint: Text(
                            selectedAssembly,
                            style: Constants.formFieldItemTextStyle,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.angleDown,
                            size: 20,
                            color: Color(0xff788EA9),
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
                                  style: Constants.formFieldItemTextStyle,
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
