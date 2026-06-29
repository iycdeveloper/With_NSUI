import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class StatePickerDropDown extends StatelessWidget {
  const StatePickerDropDown(
      {Key? key,
      required this.currentState,
      required this.stateList,
      this.onChanged,
      required this.onTap,
      required this.selectedState,
      this.viewOnly = false,
      this.isRegistrationPage = false})
      : super(key: key);

  final States? currentState;
  final List<States>? stateList;
  final void Function(dynamic v)? onChanged;
  final void Function() onTap;
  final String selectedState;
  final bool viewOnly;
  final bool isRegistrationPage;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(
            title: selectedState,
            label:"${isRegistrationPage ? "Home " : ""}State" )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isRegistrationPage ? "Home " : ""}State",
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
                            selectedState,
                            style: Constants.formFieldItemTextStyle,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 20,
                            color: Color(0xff788EA9),
                          ),
                          value: currentState?.stateCode,
                          isDense: true,
                          isExpanded: true,
                          onTap: onTap,
                          onChanged: onChanged,
                          items: stateList?.map((value) {
                            return DropdownMenuItem(
                              value: value.stateCode,
                              child: Text(
                                value.name,
                                style: Constants.formFieldItemTextStyle,
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
