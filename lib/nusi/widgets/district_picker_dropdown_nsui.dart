import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/nusi/widgets/dropdown_text_field_nsui.dart';
import 'package:iyc/utils/constants.dart';

class DistrictPickerDropDownNSUI extends StatelessWidget {
  const DistrictPickerDropDownNSUI(
      {Key? key,
      required this.hinttext,
      required this.districtList,
      this.onChanged,
      required this.onTap,
      required this.selectedDistrict,
      this.viewOnly = false,
      this.labelcolor,
      this.isRegistrationPage = false})
      : super(key: key);

  // final Districts? currentState;
  final List<Districts>? districtList;
  final void Function(dynamic v)? onChanged;
  final void Function() onTap;
  final Districts? selectedDistrict;
  final bool viewOnly;
  final bool isRegistrationPage;
  final Color? labelcolor;
  final String? hinttext;


  @override
  Widget build(BuildContext context) {
    return viewOnly
        ? DropDownTextFielNSUI(
            title: selectedDistrict!.name,
            label: "${isRegistrationPage ? "Home " : ""}District")
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isRegistrationPage ? "Home " : ""}District",
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
                            style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey)
                            // Constants.formFieldItemTextStyle,
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.angleDown,
                            size: 18,
                            color: Colors.blueAccent,
                          ),
                          value: selectedDistrict,
                          isDense: true,
                          isExpanded: true,
                          onTap: onTap,
                          onChanged: onChanged,
                          items: districtList?.map((value) {
                            return DropdownMenuItem(
                              value: value.districtCode,
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
