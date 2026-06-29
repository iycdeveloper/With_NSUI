import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/theme/app_decoration.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/utils/constants.dart';

import '../dropdown_text_field.dart';

class CategoryPickerNew extends StatelessWidget {
  const CategoryPickerNew({
    Key? key,
    required this.currentValue,
    required this.listValues,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.selectedBuilder,
    this.height,
    this.refKey,
    this.viewOnly = false,
  }) : super(key: key);

  final dynamic currentValue;
  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final List<Widget> Function(BuildContext context)? selectedBuilder;

  final String hintText;
  final String labelText;
  final double? height;
  final bool viewOnly;
  final GlobalKey? refKey;

  @override
  Widget build(BuildContext context) {
    return viewOnly
        ?
        // DropDownTextField(
        //     title: currentValue == null
        //         ? ''
        //         : listValues!
        //             .firstWhere((element) => element.value == currentValue)
        //             .name,
        //     label: labelText)
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              // alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.095,
              padding: EdgeInsets.symmetric(horizontal: 5.h,),
              // margin: const EdgeInsets.only(top: 7),
              decoration: AppDecoration.strokeWhite
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder12),
              child: ListTile(
                // titleAlignment:ListTileTitleAlignment.top ,
                title: Text(
                  labelText,
                  style: theme.textTheme.bodyLarge,
                ),
                
                subtitle: Text(
                  'Gendral',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ))
        : Container(
            // color: Colors.white,
            margin: EdgeInsets.only(left: 20.h, top: 21.v, right: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   labelText,
                //   style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                // ),
                Container(
                  // margin: const EdgeInsets.only(
                  //   top: 10,
                  // ),
                  decoration: AppDecoration.strokeWhite.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder12),
                  child: Container(
                      alignment: Alignment.center,
                      height:
                          height ?? MediaQuery.of(context).size.height * 0.085,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.h, vertical: 5.v),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<dynamic>(
                          dropdownColor: Colors.white,
                          focusColor: Colors.grey,
                          decoration: InputDecoration(
                              //  contentPadding:EdgeInsets.symmetric(horizontal: 16.h, vertical: 9.v) ,
                              border: InputBorder.none,
                              labelText: labelText,
                              labelStyle: theme.textTheme.bodyLarge!
                                  .copyWith(fontSize: 18)),
                          key: refKey,
                          itemHeight: height ??
                              MediaQuery.of(context).size.height * 0.08,
                          //alignment: Alignment.center,
                          onTap: () =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          selectedItemBuilder: selectedBuilder,
                          hint: Text(
                            hintText,
                            style: theme.textTheme.bodyLarge,
                          ),
                          icon: Padding(
                            padding: EdgeInsets.only(right: 11, bottom: 12.v),
                            child: FaIcon(
                              FontAwesomeIcons.angleDown,
                              size: 10,
                              color: Color(0xff788EA9),
                            ),
                          ),
                          value: currentValue,
                          isDense: true,
                          isExpanded: true,

                          // style:  Constants.formFieldItemTextStyle,
                          onChanged: onChanged,
                          items: listValues?.map((item) {
                            return DropdownMenuItem(
                              value: item.value,
                              child: Text(
                                item.name,
                                style: theme.textTheme.bodyLarge,
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
