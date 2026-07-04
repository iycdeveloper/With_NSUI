import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/nusi/widgets/field_label_nsui.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class DistrictPickerDropDownNSUI extends StatelessWidget {
  const DistrictPickerDropDownNSUI(
      {Key? key,
      required this.currentDistrict,
      required this.districtList,
      required this.onChanged,
            this.labelcolor,

      required this.selectedConstituency,
      this.icon,
      this.viewOnly = false,
      this.isRegistrationPage = false})
      : super(key: key);

  final IconData? icon;

  final Districts? currentDistrict;
  final List<Districts>? districtList;
  final void Function(dynamic v) onChanged;
  final String selectedConstituency;
  final bool viewOnly;
  final bool isRegistrationPage;
    final Color? labelcolor;


  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(
            title: selectedConstituency,
            label: "${isRegistrationPage ? "Home " : ""}District")
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabelNSUI(
                    icon: icon,
                    label: "${isRegistrationPage ? "Home " : ""}District",
                    color: labelcolor),
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
                  // Constants.formItemDecoration,
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
                          hint: Text(
                            selectedConstituency,
                            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey)
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
                          value: currentDistrict?.districtCode,
                          isDense: true,
                          isExpanded: true,
                          onChanged: onChanged,
                          items: districtList?.map((value) {
                            return DropdownMenuItem(
                              value: value.districtCode,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  value.name,
                                  style: currentDistrict?.districtCode == value.districtCode
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
