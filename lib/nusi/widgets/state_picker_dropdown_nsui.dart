import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
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
      this.icon,
      this.isRegistrationPage = false})
      : super(key: key);

  final IconData? icon;

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
                FieldLabelNSUI(
                    icon: icon,
                    label: "${isRegistrationPage ? "Home " : ""}State",
                    color: labelcolor),
                Container(
                  margin: const EdgeInsets.only(
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
