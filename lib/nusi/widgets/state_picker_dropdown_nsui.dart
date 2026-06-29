import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/nusi/widgets/dropdown_text_field_nsui.dart';
import 'package:iyc/utils/constants.dart';

class StatePickerDropDownNSUI extends StatelessWidget {
  const StatePickerDropDownNSUI(
      {Key? key,
      required this.currentState,
      required this.stateList,
      this.onChanged,
      required this.onTap,
      required this.selectedState,
      this.viewOnly = false,
      this.labelcolor,
      this.isRegistrationPage = false})
      : super(key: key);

  final States? currentState;
  final List<States>? stateList;
  final void Function(dynamic v)? onChanged;
  final void Function() onTap;
  final String selectedState;
  final bool viewOnly;
  final bool isRegistrationPage;
  final Color? labelcolor;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextFielNSUI(
            title: selectedState,
            label: "${isRegistrationPage ? "Home " : ""}State")
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isRegistrationPage ? "Home " : ""}State",
                  style: TextStyle(
                      color: labelcolor ?? Colors.blueAccent, fontSize: 14),
                ),
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
                  // Constants.formItemDecoration,
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
                            selectedState,
                            style: theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.grey),
                            // Constants.formFieldItemTextStyle,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: theme.textTheme.bodyLarge!.color,
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
                                style: currentState?.stateCode ==
                                        value.stateCode
                                    ? theme.textTheme.bodyLarge!.copyWith(
                                        color: theme.textTheme.bodyLarge!.color,
                                        fontWeight: FontWeight.w500)
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
