import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class DistrictPickerDropDown extends StatelessWidget {
  const DistrictPickerDropDown(
      {Key? key,
      required this.currentDistrict,
      required this.districtList,
      required this.onChanged,
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

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextField(
            title: selectedConstituency,
            label: "${isRegistrationPage ? "Home " : ""}District")
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isRegistrationPage ? "Home " : ""}District",
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
                            selectedConstituency,
                            style: Constants.formFieldItemTextStyle,
                          ),
                          icon: Icon(
                            FontAwesomeIcons.angleDown,
                            size: 20,
                            color: Color(0xff788EA9),
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
