import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';

class CustomFloatingDropDown extends StatelessWidget {
  const CustomFloatingDropDown({
    Key? key,
    this.value,
    this.title,
    this.listValues,
    required this.onChanged,
    this.defaultMargin = true,
    this.readOnly = false,
  });

  final String? title;
  final String? value;
  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final bool defaultMargin;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!readOnly) {
            FocusScope.of(context).requestFocus(new FocusNode());

            Get.dialog(
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    constraints: BoxConstraints(maxHeight: 326),
                    height: 47.0 * listValues!.length + 2,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: appTheme.indigo800,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                      color: appTheme.gray50,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.h,
                        top: 13.v,
                        bottom: 13.v,
                      ),
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            listValues!.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    onChanged(listValues![index].value);
                                    Get.back();
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    margin: EdgeInsets.only(bottom: 3, top: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              listValues![index].name,
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            if (!(index ==
                                                (listValues!.length - 1)))
                                              SizedBox(height: 16.v),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  ),
                ),
                barrierColor: Colors.transparent,
                barrierDismissible: true);
          }
        },
        child: Container(
            margin: defaultMargin
                ? EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h)
                : EdgeInsets.only(left: 0, top: 0, right: 0),
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 9.v),
            decoration: AppDecoration.strokeWhite.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 3.v),
                            Text(
                              title!,
                              style: theme.textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 3.v),
                            Padding(
                                padding: EdgeInsets.only(top: 3.v),
                                child: Text(
                                    (value != null && listValues!.isNotEmpty)
                                        ? listValues!
                                            .firstWhere((element) =>
                                                element.value == value)
                                            .name
                                        : "",
                                    style: theme.textTheme.bodyLarge)),
                          ],
                        ),
                        CustomImageView(
                            svgPath: ImageConstant.imgArrowupBlueGray300,
                            height: 20.adaptSize,
                            width: 20.adaptSize,
                            margin: EdgeInsets.only(bottom: 4.v))
                      ])
                ])));
  }
}
