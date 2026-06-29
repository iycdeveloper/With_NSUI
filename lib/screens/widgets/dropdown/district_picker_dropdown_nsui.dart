import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
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
      this.viewOnly = false,
      this.isRegistrationPage = false})
      : super(key: key);

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
                Text(
                  "${isRegistrationPage ? "Home " : ""}District",
                  style: TextStyle(color:labelcolor?? Colors.blueAccent, fontSize: 14),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                  ),
                  decoration:
                   BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey[200]!,
                        spreadRadius: 1.2,
                        blurRadius: 0.6

                        ),
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
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: theme.textTheme.bodyLarge!.color,
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
