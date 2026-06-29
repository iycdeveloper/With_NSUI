import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';

class CustomFloatingDropDownNSUI extends StatelessWidget {
  const CustomFloatingDropDownNSUI(
      {Key? key,
      this.value,
      required this.labelText,
      this.title,
      this.listValues,
      required this.onChanged,
      this.defaultMargin = true,
      this.readOnly = false,
      this.labelcolor});

  final String? title;
  final String? labelText;
  final String? value;
  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final bool defaultMargin;
  final bool readOnly;
  final Color? labelcolor;

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
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(
                      //   color: appTheme.indigo800,
                      //   width: 1,
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                      color: Colors.white,
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
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelText!,
                style: TextStyle(
                    color: labelcolor ?? Colors.blueAccent, fontSize: 14),
              ),
              Container(
                  margin: defaultMargin
                      ? EdgeInsets.only(left: 20.h, top: 24.v, right: 20.h)
                      : EdgeInsets.only(top: 5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 5.v),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[200]!,
                            spreadRadius: 1.2,
                            blurRadius: 0.6),
                      ]),
                  // AppDecoration.strokeWhite.copyWith(
                  //     borderRadius: BorderRadiusStyle.roundedBorder12,
                  //     border: Border.all(color: Colors.blueAccent)),
                  child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(height: 10.v),
                                  Padding(
                                      padding: EdgeInsets.only(top: 0.v),
                                      child: Text(
                                          (value != null &&
                                                  listValues!.isNotEmpty)
                                              ? listValues!
                                                  .firstWhere((element) =>
                                                      element.value == value)
                                                  .name
                                              : title!,
                                          style: value != null
                                              ? theme.textTheme.bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500)
                                              : theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.grey))),
                                  SizedBox(height: 12.v),
                                ],
                              ),
                              CustomImageView(
                                  svgPath: ImageConstant.imgArrowupBlueGray300,
                                  height: 22.adaptSize,
                                  width: 22.adaptSize,
                                  color: theme.textTheme.bodyLarge!.color,
                                  margin: EdgeInsets.only(bottom: 4.v))
                            ])
                      ])),
            ],
          ),
        ));
  }
}
