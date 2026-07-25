import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/model/offline_model/database/states.dart';

class StateDropDrownNSUI extends StatelessWidget {
  StateDropDrownNSUI(
      {Key? key,
      this.value,
      this.title,
      this.hintText,
      this.listValues,
      required this.onChanged,
      this.labelcolor,
      required this.lable,
      this.margin});

  final String? title;
  final String? hintText;

  final States? value;
  final List<States>? listValues;
  final dynamic Function(dynamic v) onChanged;
  EdgeInsetsGeometry? margin;
  final Color? labelcolor;
  final String? lable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          if (listValues == null) {
            CustomSnackBar.showWarningSnackBar("No item to select");
          } else {
            Get.dialog(
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 326),
                    height: 40.0 * listValues!.length,
                    width: 335,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(
                      //   color: const Color(0xFFC0D5F3),
                      //   width: 1,
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 10),
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              listValues!.length,
                              (index) => GestureDetector(
                                    onTap: () async {
                                      // Close this picker only after onChanged
                                      // finishes — some implementations (e.g.
                                      // Register's onChangeState) open/close
                                      // their own progress dialog on the same
                                      // GetX navigator stack, and closing this
                                      // dialog first races with that, leaving
                                      // the wrong dialog open.
                                      await onChanged(listValues![index]);
                                      Get.back();
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(4.0),
                                          width: double.maxFinite,
                                          child: Row(
                                            children: [
                                              Text(
                                                listValues![index].name,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (!(index ==
                                            (listValues!.length - 1)))
                                          SizedBox(height: 16.v),
                                      ],
                                    ),
                                  )),
                        ),
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
                lable!,
                style: TextStyle(
                    color: labelcolor ?? Colors.blueAccent, fontSize: 14),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
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
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(color: Colors.blueAccent)),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // hintText == null
                        //     ? const SizedBox()
                        //     : (value != null
                        //         ? const SizedBox()
                        //         : Text(hintText!, style: theme.textTheme.bodyLarge)),
                        // Text(title!, style: theme.textTheme.bodyLarge),
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
                                          value != null ? value!.name : title!,
                                          style: value != null
                                              ? theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)
                                              : theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.grey))),
                                  SizedBox(height: 10.v),
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
