import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/theme/app_decoration.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/offline_model/database/nominations.dart';
import 'package:iyc/utils/constants.dart';

class StateNominationPickerWidget extends StatelessWidget {
  const StateNominationPickerWidget(
      {Key? key,
      this.currentValue,
      required this.listValues,
      required this.onChanged,
      required this.labelText,
      required this.defaultValue,
      this.lablecolor})
      : super(key: key);

  final dynamic currentValue;

  final List<Nomination> listValues;
  final void Function(dynamic v) onChanged;

  final String defaultValue;
  final String labelText;
  final Color? lablecolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style:
                TextStyle(color: lablecolor ?? Colors.blueAccent, fontSize: 14),
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
            //  AppDecoration.strokeWhite.copyWith(
            //     borderRadius: BorderRadiusStyle.roundedBorder12,
            //     border: Border.all(color: Colors.blueAccent)),
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
                      defaultValue,
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: Colors.grey),
                      //Constants.formFieldItemTextStyle,
                    ),
                    icon: Icon(
                      FontAwesomeIcons.angleDown,
                      size: 18,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                    value: currentValue,
                    selectedItemBuilder: (context) => listValues
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text("$labelText CSN: ${e.csn}",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      color: theme.textTheme.bodyLarge!.color,
                                      fontWeight: FontWeight.w500)
                                  // Constants.formFieldItemTextStyle,
                                  ),
                            ))
                        .toList(),
                    isDense: true,
                    isExpanded: true,
                    onChanged: onChanged,
                    items: listValues.isEmpty
                        ? []
                        : listValues.map((value) {
                            return DropdownMenuItem(
                              value: value.csn?.toString(),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "CSN ${value.csn} : ${value.firstName} ${value.lastName}",
                                  style: theme.textTheme.bodyMedium!
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
